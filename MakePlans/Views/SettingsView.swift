//
//  SettingsView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 28/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @State private var isShowingInviteView = false

    var body: some View {
        ZStack {
            Color("offWhite").edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(.black)
                    .padding()
                }
                Spacer()

                Button(action: {
                    self.settingsViewModel.signOut {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Sign out")
                }
                .buttonStyle(LightButtonStyle(paddingSize: 20, shape: RoundedRectangle(cornerRadius: 25)))
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
