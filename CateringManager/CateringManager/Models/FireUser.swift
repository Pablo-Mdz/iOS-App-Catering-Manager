//
//  FireUser.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import Foundation

struct FireUser: Codable, Identifiable {
    let id: String
    let email: String
    let username: String
    let registeredAt: Date
    var profileImageUrl: String?
}
