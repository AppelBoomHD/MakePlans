//
//  GroupInfoView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 30/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI

struct GroupInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var groupVM: GroupViewModel
    
    @State var isShowingInviteView = false
    
    var body: some View {
        VStack {
            Text("Group:")
                .font(.headline)
                .bold()
                .padding(.top, 40)
            Text(groupVM.group.groupName)
                .font(.headline)
            Spacer()
                .frame(height: 40)
            Text("Owner:")
                .font(.headline)
            Text(groupVM.group.owner ?? "Unknown")
            Spacer()
                .frame(height: 40)
            NavigationLink(destination: Text("Second View"), isActive: $isShowingInviteView) { EmptyView() }
            Button("Invite a friend") {
                self.isShowingInviteView = true
            }
            .buttonStyle(LightButtonStyle(paddingSize: 20, shape: RoundedRectangle(cornerRadius: 25)))
            Spacer()
            Button(action: {
                self.groupVM.deleteGroup()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete group")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.red)
                    .cornerRadius(15.0)

            }
        }
    }
}

//struct GroupInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupInfoView()
//    }
//}
