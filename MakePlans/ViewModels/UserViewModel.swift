//
//  UserViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 29/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Combine
import Resolver

class UserViewModel: ObservableObject, Identifiable {
    @Published var user: CustomUser
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: CustomUser) {
        self.user = user
        
        $user
            .compactMap { user in
                user.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
