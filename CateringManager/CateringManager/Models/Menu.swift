//
//  Menu.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Menu: Codable, Identifiable {
    let userId: String
    var name: String
    var description: String
    var costPerPerson: Double
    var dishes: [Dish]

  @DocumentID  var id: String?
}
