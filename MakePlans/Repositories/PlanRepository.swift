//
//  PlanRespository.swift
//  MakePlans
//
//  Created by Julian Riemersma on 23/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

import FirebaseFunctions
import Resolver

import Combine

class PlanRepository: ObservableObject {
    @Published var plans = [Plan]()
    @Injected var db: Firestore
    @LazyInjected var functions: Functions
    @Injected var session: SessionStore
    
    var plansPath: String = "plans"
    @Published var group: UserGroup
    var groupID = "unknown"
    var userID: String = "unknown"
    
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    init(group: UserGroup) {
        self.group = group
        
        session.$user
          .compactMap { user in
            user?.id
          }
          .assign(to: \.userID, on: self)
          .store(in: &cancellables)

        $group
            .compactMap { group in
                group.id
        }
        .assign(to: \.groupID, on: self)
        .store(in: &cancellables)
        
        
        // (re)load data if group changes
        $group
          .receive(on: DispatchQueue.main)
          .sink { [weak self] group in
            self?.loadData()
          }
          .store(in: &cancellables)
    }
    
      private func loadData() {
        if listenerRegistration != nil {
          listenerRegistration?.remove()
        }
        
        listenerRegistration = db.collection(plansPath)
            .whereField("groupID", isEqualTo: self.groupID)
            .order(by: "kudos", descending: true)
            .order(by: "createdAt")
          .addSnapshotListener { (querySnapshot, error) in
            print("Listening for plans!")
            if let querySnapshot = querySnapshot {
                self.plans = querySnapshot.documents.compactMap { document -> Plan? in
                    try? document.data(as: Plan.self)
              }
            }
          }
      }
      
      func addPlan(_ plan: Plan) {
        do {
          var userPlan = plan
          userPlan.userID = self.userID
          userPlan.groupID = self.groupID
          let _ = try db.collection(plansPath).addDocument(from: userPlan)
        }
        catch {
          fatalError("Unable to encode task: \(error.localizedDescription).")
        }
      }
      
      func removePlan(_ plan: Plan) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
        if let planID = plan.id {
            db.collection(plansPath).document(planID).delete { (error) in
            if let error = error {
              print("Unable to remove document: \(error.localizedDescription)")
            }
          }
        }
      }
      
      func updatePlan(_ plan: Plan) {
        if let planID = plan.id {
          do {
            try db.collection(plansPath).document(planID).setData(from: plan)
          }
          catch {
            fatalError("Unable to encode task: \(error.localizedDescription).")
          }
        }
      }
      
      func migratePlans(fromUserID: String) {
        let data = ["previousUserId": fromUserID]
        functions.httpsCallable("migrateTasks").call(data) { (result, error) in
          if let error = error as NSError? {
            print("Error: \(error.localizedDescription)")
          }
          print("Function result: \(result?.data ?? "(empty)")")
        }
      }
}
