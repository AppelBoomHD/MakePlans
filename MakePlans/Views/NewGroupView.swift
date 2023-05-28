//
//  NewGroupView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 27/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Firebase
import Resolver
import SwiftUI

struct NewGroupView: View {
    @Injected var session: SessionStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var newGroupVM = NewGroupViewModel()
    @State var groupName = ""
    @State var friendName = ""
    @State var friends: [String]?
    
    @State var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Group name:")
                        .font(.headline)
                        .padding(.horizontal)
                    Spacer()
                }
                TextField("Group Name", text: $groupName)
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                HStack {
                    Text("Add friends:")
                        .font(.headline)
                        .padding(.horizontal)
                    Spacer()
                }
                SearchBar(text: $friendName, isEditing: $isEditing)
                
                List(
                    newGroupVM.userViewModels.filter { userVM in
                        (friendName.isEmpty ? true : userVM.user.displayName?.contains(friendName) ?? false) &&
                        userVM.user.displayName != session.user?.displayName
                    }) { item in
                        UserView(userViewModel: item, friends: $friends)
                    }
                    .listStyle(.plain)
                
                Spacer()
                
                Button(action: {
                    self.newGroupVM.createGroup(groupName: groupName, users: friends) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Create group!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
            }
            .alert(isPresented: $newGroupVM.showingAlert) {
                Alert(title: Text("Failed to create a group"), message: newGroupVM.alertInfo, dismissButton: .default(Text("Try again")))
            }
            .navigationTitle("Create new group")
            .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        .foregroundColor(.black)
                    }
                }
        }
    }
}

struct NewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupView()
    }
}

struct UserView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var friends: [String]?
    
    @State var isAdded = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                if isAdded {
                    isAdded.toggle()
                    self.friends?.removeAll { userID in
                        userID == self.userViewModel.user.id!
                    }
                } else {
                    isAdded.toggle()
                    if (self.friends?.append(self.userViewModel.user.id!)) == nil {
                        self.friends = [self.userViewModel.user.id!]
                    }
                }
            }
        }) {
            HStack {
                Text(userViewModel.user.displayName!)
                Spacer()
                Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle.fill")
                    .foregroundColor(isAdded ? Color.green : Color.blue)
                    .font(.system(size: 25))
                    .padding(.vertical, 4)
                    .padding(.horizontal)
            }
        }
        .foregroundColor(.primary)
    }
}
