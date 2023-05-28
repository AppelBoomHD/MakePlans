//
//  AppDelegate + Injection.swift
//  MakePlans
//
//  Created by Julian Riemersma on 29/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import Resolver
import FirebaseFunctions
import FirebaseFirestore

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {    
    // register application components
      register { Firestore.firestore() }
      register { SessionStore() }.scope(.application)
      register { GroupRepository() }.scope(.application)
      register { UserRepository() }.scope(.application)
  }
}

