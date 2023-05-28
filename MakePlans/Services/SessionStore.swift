//
//  SessionStore.swift
//  MakePlans
//
//  Created by Julian Riemersma on 27/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Firebase
import Combine
import GoogleSignIn
import Resolver

class SessionStore: ObservableObject {
    @Published var isLoading = false
    @Published var user: CustomUser?
    
    @Injected var db: Firestore
    @LazyInjected var session: SessionStore
    var handle: AuthStateDidChangeListenerHandle?
    
    var usersPath = "users"
    
    init () {
        listen()
    }
    
    func listen () {
        self.isLoading = true
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("new user")
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.user = CustomUser(id: user.uid, email: user.email, displayName: user.displayName)
                try? self.db.collection(self.usersPath).document(user.uid).setData(from: self.user, merge: true)
                self.isLoading = false
            } else {
                // if we don't have a user, set our session to nil
                self.user = nil
                self.isLoading = false
            }
        }
    }
    
    func signInGoogle () {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let user = signInResult?.user else {
              // Inspect error
                print("error")
              return
            }
            
            guard let idToken = user.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("user=" + (authResult?.user.email)!)
                    return
                }
            }
            
        }
//        DispatchQueue(label: "SignIn Check", qos: DispatchQoS.background).async(execute: { () -> Void in
//                while true {
//                    if GIDSignIn.sharedInstance()?.currentUser != nil {
//                        completion()
//                        break
//                    }
//                }
//            })
    }
    
    func signUpEmail(
        email: String,
        password: String,
        handler: @escaping (AuthDataResult?, Error?) -> Void
        ) {
            Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signInEmail(
        email: String,
        password: String,
        handler: @escaping (AuthDataResult?, Error?) -> Void
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signInAnonymous () {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }

    func signOut () {
        do {
            try Auth.auth().signOut()
            print("Succesfully signed out")
        } catch {
            print("Error when trying to sign out: \(error.localizedDescription)")
        }
    }
    
    func invite (email: String) {
        
    }
}

