//
//  NewGroupViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 27/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Combine
import Resolver
import Firebase

class UserRepository: ObservableObject {
    @Published var users = [CustomUser]()
    
    @Injected var groupRepository: GroupRepository
    @Injected var db: Firestore
    private var listenerRegistration: ListenerRegistration?
    
    var usersPath = "users"
    @Published var showingAlert = false
    @Published var alertInfo = Text("")
    
    init() {
        loadUsers()
    }
    
      private func loadUsers() {
        if listenerRegistration != nil {
          listenerRegistration?.remove()
        }
        
        listenerRegistration = db.collection(usersPath)
            .order(by: "displayName")
            .addSnapshotListener { (querySnapshot, error) in
                print("Listening for custom users!")
            if let querySnapshot = querySnapshot {
                self.users = querySnapshot.documents.compactMap { document -> CustomUser? in
                    try? document.data(as: CustomUser.self)
              }
            }
          }
      }
    
    
    func createGroup(groupName: String, users: [String]?) {
        let group = UserGroup(groupName: groupName, users: users)
        groupRepository.createGroup(group)
    }
    
}
