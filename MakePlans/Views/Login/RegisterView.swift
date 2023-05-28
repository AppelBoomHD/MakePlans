//
//  RegisterView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 29/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var registerViewModel = RegisterViewModel()
    
    @State var displayName = ""
    
    var body: some View {
        VStack {
            Text("How do you want others to see you?")
            TextField("Display name", text: $displayName)
                .padding()
                .background(Color("lightGrey"))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                registerViewModel.changeDisplayName(displayName: displayName)
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
        .alert(isPresented: $registerViewModel.showingAlert) {
            Alert(title: Text("Failed to sign in"), message: registerViewModel.alertInfo, dismissButton: .default(Text("Try again")))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
