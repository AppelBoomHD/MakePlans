//
//  RegisterViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 29/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Firebase
import Resolver
import Combine

class RegisterViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertInfo = Text("")
    
    init() { }
    
    func changeDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges { (error) in
                if let error = error {
                    self.alertInfo = Text(error.localizedDescription)
                    self.showingAlert = true
                } else {
                    return
                }
        }
    }
}
