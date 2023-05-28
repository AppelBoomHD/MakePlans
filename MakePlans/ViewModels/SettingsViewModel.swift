//
//  SettingsViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 28/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Combine
import Resolver
import Firebase

class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var email: String = ""
    @Published var displayName: String = ""
    @Published private var session: SessionStore = Resolver.resolve()
    
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        session.$user.compactMap { user in
          user?.email
        }
        .assign(to: \.email, on: self)
        .store(in: &cancellables)
        
        session.$user.compactMap { user in
          user?.displayName
        }
        .assign(to: \.displayName, on: self)
        .store(in: &cancellables)
    }
    
    func signInEmail (email: String, password: String) {
        session.signInEmail(email: email, password: password) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                return
            }
        }
    }
    
    func signOut (completion: @escaping () -> Void) {
        session.signOut()
        completion()
    }
}

// func signOut () {
//        session.signOut()
//    }
//}
