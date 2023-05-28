//
//  PlanViewModel.swift
//  MakePlans
//
//  Created by Julian Riemersma on 23/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Combine
import Resolver

class PlanCellViewModel: ObservableObject, Identifiable {
    @Published var planRepository: PlanRepository
    
    @Published var plan: Plan
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(plan: Plan, planRepository: PlanRepository) {
        self.planRepository = planRepository
        self.plan = plan
        
        $plan
            .compactMap { plan in
                plan.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $plan
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { plan in
                self.planRepository.updatePlan(plan)
            }
            .store(in: &cancellables)
    }
}
