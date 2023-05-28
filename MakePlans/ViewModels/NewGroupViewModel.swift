//
//  NewGroupViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 29/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import Resolver

class NewGroupViewModel: ObservableObject {
    @Published var userRepository: UserRepository = Resolver.resolve()
    @Published var userViewModels = [UserViewModel]()
    
    @Published var showingAlert = false
    @Published var alertInfo = Text("")

    private var cancellables = Set<AnyCancellable>()
    
    init() {
    userRepository.$users
        .map { users in
            users.map { user in
                UserViewModel(user: user)
            }
        }
        .assign(to: \.userViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func createGroup(groupName: String, users: [String]?, completion: @escaping () -> Void) {
        if groupName == "" {
            alertInfo = Text("Group needs a name")
            showingAlert = true
        } else {
            userRepository.createGroup(groupName: groupName, users: users)
            completion()
        }
    }
}
