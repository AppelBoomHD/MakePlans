//
//  LoginView.swift
//  MakePlans
//
//  Created by Julian Riemersma on 23/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var loginViewModel = LoginViewModel()
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        ZStack {
            if colorScheme == .dark {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2549019608, alpha: 1)), Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1176470588, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                
                KeyboardHost {
                VStack {
                    Spacer()
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color("lightGrey"))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color("lightGrey"))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Button(action: {self.loginViewModel.signInEmail(email: self.email, password: self.password )}) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    }
                    .buttonStyle(DarkButtonStyle(paddingSize: 10, shape: RoundedRectangle(cornerRadius: 25)))
                    Spacer()
                    
                    HStack {
                        Button(action: {self.loginViewModel.signInGoogle()}) {
                            Image("google")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .buttonStyle(DarkButtonStyle(paddingSize: 10, shape: Circle()))
                        .padding()
                        
                        Button(action: { print("Facebook button pressed")}) {
                            Image("facebook")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .buttonStyle(DarkButtonStyle(paddingSize: 10, shape: Circle()))
                        .padding()
                    }
                    
                }
                .padding()
                .alert(isPresented: $loginViewModel.showingAlert) {
                    Alert(title: Text("Failed to sign in"), message: loginViewModel.alertInfo, dismissButton: .default(Text("Try again")))
                }
                }
            } else {
                Color(#colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.9215686275, alpha: 1)).edgesIgnoringSafeArea(.all)
                
                KeyboardHost {
                VStack {
                    Spacer()
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color("lightGrey"))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color("lightGrey"))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Button(action: {self.loginViewModel.signInEmail(email: self.email, password: self.password )}) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    }
                    .buttonStyle(LightButtonStyle(paddingSize: 10, shape: RoundedRectangle(cornerRadius: 25)))
                    Spacer()
                    
                    HStack {
                        Button(action: {self.loginViewModel.signInGoogle()}) {
                            Image("google")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(LightButtonStyle(paddingSize: 10, shape: Circle()))
                        .padding()
                        
                        Button(action: { print("Facebook button pressed")}) {
                            Image("facebook")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(LightButtonStyle(paddingSize: 10, shape: Circle()))
                        .padding()
                    }
                    
                }
                .padding()
                .alert(isPresented: $loginViewModel.showingAlert) {
                    Alert(title: Text("Failed to sign in"), message: loginViewModel.alertInfo, dismissButton: .default(Text("Try again")))
                }
                }
            }
        }
        
    }
}

let emailTextField: UITextField = {
    let emailTF = UITextField()
    emailTF.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [kCTForegroundColorAttributeName as NSAttributedString.Key: kCISamplerWrapBlack])

    emailTF.translatesAutoresizingMaskIntoConstraints = false
    //User input text white
    emailTF.textColor = UIColor.white
    emailTF.backgroundColor = UIColor.black
    emailTF.borderStyle = .roundedRect
    emailTF.font = UIFont.systemFont(ofSize: 16)
    return emailTF
}()

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
