//
//  LoginViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 28/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Resolver
import Combine

class LoginViewModel: ObservableObject {
    @Published private var session: SessionStore = Resolver.resolve()
    @Published var showingAlert = false
    @Published var alertInfo = Text("")
    
    init() { }
    
    func signInEmail (email: String, password: String) {
        session.signInEmail(email: email, password: password) { (authResult, error) in
            if let error = error {
                self.alertInfo = Text(error.localizedDescription)
                self.showingAlert = true
            } else {
                return
            }
        }
    }
    
    func signInGoogle () {
        session.signInGoogle()
    }
    
    func signOut () {
        session.signOut()
    }
}
