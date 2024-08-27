//
//  Ingredients.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 03/07/2024.
//

import Foundation

enum Unit: String, Codable {
    case other
    case cc // swiftlint:disable:this identifier_name
    case g // swiftlint:disable:this identifier_name
    case unit // swiftlint:disable:this superfluous_disable_command
}

struct Ingredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantity: Int
    var unit: Unit
    var price: Double
}
