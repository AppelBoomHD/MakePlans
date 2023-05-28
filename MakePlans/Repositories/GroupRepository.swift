//
//  SessionStore.swift
//  MakePlans
//
//  Created by Julian Riemersma on 25/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Firebase
import Combine
import Resolver

class GroupRepository: ObservableObject {
    @Published var groups = [UserGroup]()
    @Injected var db: Firestore
    @Injected var session: SessionStore
    
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    var groupsPath: String = "groups"
    var usersPath: String = "users"
    var userID: String = "unknown"
    
    init () {        
        session.$user
          .compactMap { user in
            user?.id
          }
          .assign(to: \.userID, on: self)
          .store(in: &cancellables)

        // (re)load data if user changes
        session.$user
          .receive(on: DispatchQueue.main)
          .sink { [weak self] user in
            self?.loadGroups()
          }
          .store(in: &cancellables)
    }
    
    private func loadGroups() {
      if listenerRegistration != nil {
        listenerRegistration?.remove()
      }
      
      listenerRegistration = db.collection(groupsPath)
          .whereField("users", arrayContains: self.userID)
          .order(by: "createdAt")
          .addSnapshotListener { (querySnapshot, error) in
                print("Listening for groups!")
              if let querySnapshot = querySnapshot {
                  self.groups = querySnapshot.documents.compactMap { document -> UserGroup? in
                      try? document.data(as: UserGroup.self)
                  }
              }
          }
    }
    
    func createGroup(_ group: UserGroup) {
      do {
        var userGroup = group
        if (userGroup.users?.append(userID)) == nil {
            userGroup.users = [userID]
        }
        userGroup.owner = userID
        let groupID = try db.collection(groupsPath).addDocument(from: userGroup).documentID
        
        if (self.session.user?.groupIDs?.append(groupID)) == nil {
            self.session.user?.groupIDs = [groupID]
        }
        try? self.db.collection(usersPath).document(self.userID).setData(from: self.session.user)
      }
      catch {
        fatalError("Unable to encode task: \(error.localizedDescription).")
      }
    }
    
    func deleteGroup(_ group: UserGroup) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
      if let groupID = group.id {
          db.collection(groupsPath).document(groupID).delete { (error) in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
    
    func updateGroup(_ group: UserGroup) {
      if let groupID = group.id {
        do {
          try db.collection(groupsPath).document(groupID).setData(from: group)
        }
        catch {
          fatalError("Unable to encode task: \(error.localizedDescription).")
        }
      }
    }
}
