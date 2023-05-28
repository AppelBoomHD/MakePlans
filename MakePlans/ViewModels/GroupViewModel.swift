//
//  GroupViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 25/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Combine
import Resolver

class GroupViewModel: ObservableObject, Identifiable {
    @Injected var groupRepository: GroupRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var deletedGroup = false
    @Published var group: UserGroup
    var id = ""

    init(group: UserGroup) {
        self.group = group
        
        $group
            .compactMap { group in
                group.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func deleteGroup() {
        groupRepository.deleteGroup(group)
        deletedGroup.toggle()
    }
}
