//
//  Listitems.swift
//  MakePlans
//
//  Created by Julian Riemersma on 09/07/2020.
//  Copyright © 2020 com.julianriemersma. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Plan: Codable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var userID: String?
    var title: String
    var kudos: Int = 0
    var groupID: String?
}

#if DEBUG
let testData = [
Plan(title: "Eerste voorbeeld"),
Plan(title: "Test"),
Plan(title: "Laatste voorbeeld")
]
#endif
