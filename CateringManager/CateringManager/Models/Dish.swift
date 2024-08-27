//
//  Dish.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 03/07/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Dish: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var servings: Int
    var ingredients: [Ingredient]
}
