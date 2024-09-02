//
//  MenuRepository.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MenuRepository: ObservableObject {
    // change simulator
    private let db = Firestore.firestore() // swiftlint:disable:this identifier_name
    func addMenu(_ menu: Menu) throws {
        try db.collection("menus").document(menu.id ?? UUID().uuidString).setData(from: menu)
    }

    func fetchMenus(userId: String) async throws -> [Menu] {
        let snapshot = try await db.collection("menus").whereField("userId", isEqualTo: userId).getDocuments()
        let menus = snapshot.documents.compactMap { document -> Menu? in
            return try? document.data(as: Menu.self)
        }
        return menus
    }
    func fetchMenuId(menuId: String) async throws -> Menu? {
        
        let document = try await db.collection("menus").document(menuId).getDocument()
        return try document.data(as: Menu.self)
    }

    func updateMenu(_ menu: Menu) throws {
        try db.collection("menus").document(menu.id ?? UUID().uuidString).setData(from: menu)
    }

    func deleteMenu(menuId: String?) {
        guard let menuId = menuId, !menuId.isEmpty else {
            print("Menu ID is empty or nil")
            return
        }

        db.collection("menus").document(menuId).delete { error in
            if let error = error {
                print("Error deleting menu: \(error)")
            } else {
                print("Menu successfully deleted with ID: \(menuId)")
            }
        }
    }
}
