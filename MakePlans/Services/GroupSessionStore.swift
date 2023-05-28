//
//  GroupSessionStore.swift
//  MakePlans
//
//  Created by Julian Riemersma on 25/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Firebase
import Combine
import Resolver

class GroupSessionStore: ObservableObject {
    @Injected var db: Firestore
//    @Published var isLoading = false
    @Injected var session: SessionStore
    
    @LazyInjected var groupSession: GroupSessionStore


    init() {
        db.collection("groups")
        .whereField("users", arrayContains: session.$user.uid)
        .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                print("looking for groupIDs")
                self.groups = querySnapshot.documents.compactMap { document -> UserGroup? in
                    try? document.data(as: UserGroup.self)
                }
            }
        }
    }
}
