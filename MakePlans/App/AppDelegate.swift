//
//  AppDelegate.swift
//  MakePlans
//
//  Created by Julian Riemersma on 09/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Resolver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @LazyInjected var session: SessionStore
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      if let error = error {
        print("error while signing in: \(error.localizedDescription)")
        return
        }
        
        guard let idToken = user.idToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
//        Auth.auth().currentUser?.link(with: credential) { (authResult, error) in
//            if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
//                print("The account you're trying to sign in to has already been linked")
//                if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
//                    print("Signing in using updated credentials")
//                    Auth.auth().signIn(with: updatedCredential) { (authResult, error) in
//                        if (authResult?.user) != nil {
//
//                                print("Succesfully logged in with email: \((authResult?.user.email)!)")
//                                return
//                        }
//                    }
//                }
//            }
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("user=" + (authResult?.user.email)!)
                return
            }
        }
        
//        Auth.auth().signIn(with: credential) { (res, error) in
//            if error != nil {
//                print((error?.localizedDescription)!)
//                return
//            }
//
//            print("user=" + (res?.user.email)!)
//        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
          
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
}

