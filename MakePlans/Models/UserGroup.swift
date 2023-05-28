//
//  Group.swift
//  MakePlans
//
//  Created by Julian Riemersma on 24/12/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserGroup: Codable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var groupName: String
    var owner: String?
    var users: [String]?
}
