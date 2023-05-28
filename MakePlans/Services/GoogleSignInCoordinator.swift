//
//  GoogleSignInCoordinator.swift
//  MakePlans
//
//  Created by Julian Riemersma on 24/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleSignInCoordinator: NSObject {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("error while signing in: \(error.localizedDescription)")
            return
        }
        
        guard let idToken = user.idToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: user.accessToken.tokenString)
        
        Auth.auth().currentUser?.link(with: credential) { (authResult, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            print("user=" + (authResult?.user.email)!)
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
           // Perform any operations when the user disconnects from app here.
           // ...
       }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        return true
    }
        
}
