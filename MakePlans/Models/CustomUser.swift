//
//  User.swift
//  MakePlans
//
//  Created by Julian Riemersma on 27/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CustomUser: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String?
    var displayName: String?
    var groupIDs: [String]?
}
