//
//  GroupListViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 25/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Combine
import Resolver

class GroupListViewModel: ObservableObject {
    @Published var groupRepository: GroupRepository = Resolver.resolve()
    @Published var groupViewModels = [GroupViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        groupRepository.$groups
            .map { groups in
                groups.map { group in
                    GroupViewModel(group: group)
                }
            }
            .assign(to: \.groupViewModels, on: self)
            .store(in: &cancellables)
    }
}
