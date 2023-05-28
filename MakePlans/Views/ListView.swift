//
//  ContentView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 09/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Resolver

enum ActiveSheet {
    case settings, groupInfo
}

struct ListView: View {
    @State var activeSheet: ActiveSheet = .settings
    @State var showingSheet = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var groupVM: GroupViewModel
    @ObservedObject var listVM: ListViewModel
    
    init(groupVM: GroupViewModel) {
        self.groupVM = groupVM
        self.listVM = ListViewModel(group: groupVM.group)
    }
    
    @State var presentNewItem = false
    
    var body: some View {
            VStack(alignment: .trailing) {
                List {
                    ForEach(listVM.planCellViewModels) { planCellVM in
                        PlanCellView(planCellVM: planCellVM)
                    }
                    .onDelete { index in
                        self.listVM.removePlans(atOffsets: index)
                    }
                    if presentNewItem {
                        AddPlanCellView(planCellVM: PlanCellViewModel(plan: Plan(title: ""), planRepository: listVM.planRepository)) { plan in
                            self.listVM.addPlan(plan: plan)
                            self.presentNewItem.toggle()
                        }
                    }
                }
                .navigationBarItems(trailing:
                                        HStack {
                                            Button(action: {
                                                self.activeSheet = .groupInfo
                                                self.showingSheet.toggle()
                                            }) {
                                                Image(systemName: "person.2.circle")
                                            }
                                            Button(action: {
                                                self.activeSheet = .settings
                                                self.showingSheet.toggle()
                                            }) {
                                                Image(systemName: "gear")
                                            }
                })
                .navigationBarTitle(groupVM.group.groupName)
                Button(action: {self.presentNewItem.toggle()}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add new idea")
                    }
                }.padding()
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                if groupVM.deletedGroup {
                   self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                switch activeSheet {
                case .groupInfo:
                    GroupInfoView(groupVM: groupVM)
                case .settings:
                    SettingsView()
                }
            }
    }
}

struct PlanCellView: View {
    @ObservedObject var planCellVM: PlanCellViewModel
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                // (hacky) method to keep alignment fixed
                Text("1234567891011121314151617181920212223")
                    .opacity(0)
                    .accessibility(hidden: true)
                Text(planCellVM.plan.title)
            }
            .padding(.trailing)

            MinusButton(planCellVM: planCellVM)
                .padding(2)

            PlusButton(planCellVM: planCellVM)
                .padding(2)
            
            ZStack {
                // (hacky) method to keep alignment fixed
                Text("123")
                    .opacity(0)
                    .accessibility(hidden: true)
                Text("\(planCellVM.plan.kudos)")
            }
            .padding(.leading)
        }
    }
}

struct AddPlanCellView: View {
    @ObservedObject var planCellVM: PlanCellViewModel
    @State private var isActive = false
    
    var onCommit: (Plan) -> (Void)
    
    var body: some View {
        TextField("Enter your idea here", text: $planCellVM.plan.title, onCommit: {
                self.onCommit(self.planCellVM.plan)
            })
    }
}

struct PlusButton: View {
    @ObservedObject var planCellVM: PlanCellViewModel
    
    var body: some View {
            Image(systemName: "plus.app.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .onTapGesture {
                    self.planCellVM.plan.kudos += 1
                }
    }
}

struct MinusButton: View {
    @ObservedObject var planCellVM: PlanCellViewModel
    
    var body: some View {
            Image(systemName: "minus.square.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .onTapGesture {
                    self.planCellVM.plan.kudos -= 1
                }
    }
}

