//
//  GroupListView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 25/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI
import Resolver

struct GroupListView: View {
    @State var showingSettings = false
    @State var showingNewGroup = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var groupListVM = GroupListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                List {
                    ForEach(groupListVM.groupViewModels) { groupVM in
                        GroupView(groupVM: groupVM)
                    }
                }
                .navigationBarItems(trailing: Button(action: {self.showingSettings.toggle()}) {
                                                Image(systemName: "gear")
                    
                })
                .navigationBarTitle("Groups")
                Button(action: {self.showingNewGroup.toggle()}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New group")
                    }
                }.padding()

            }
            
            .sheet(isPresented: self.$showingNewGroup) {
                NewGroupView()
            }
            }
        .sheet(isPresented: self.$showingSettings) {
            SettingsView()
        }
            
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}

struct GroupView: View {
    @ObservedObject var groupVM: GroupViewModel
    
    var body: some View {
        NavigationLink(destination: ListView(groupVM: groupVM)) {
                Text(groupVM.group.groupName)
            }
            .padding(.trailing)
    }
}
