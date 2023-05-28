//
//  ListViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 23/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Combine
import Resolver

class ListViewModel: ObservableObject {
    @Published var planRepository: PlanRepository
    @Published var planCellViewModels = [PlanCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(group: UserGroup) {
        self.planRepository = PlanRepository(group: group)
        
        planRepository.$plans
            .map { plans in
                plans.map { plan in
                    PlanCellViewModel(plan: plan, planRepository: self.planRepository)
                }
            }
            .assign(to: \.planCellViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func addPlan(plan: Plan) {
        planRepository.addPlan(plan)
    }
    
    func removePlans(atOffsets indexSet: IndexSet) {
      // remove from repo
      let viewModels = indexSet.lazy.map { self.planCellViewModels[$0] }
      viewModels.forEach { planCellViewModel in
        planRepository.removePlan(planCellViewModel.plan)
      }
    }
}
