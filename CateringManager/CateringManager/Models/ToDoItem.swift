//
//  FireToDoItem.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct ToDoItem: Codable, Identifiable {
    let title: String
    let isCompleted: Bool
    let userId: String

    @DocumentID var id: String?
}
