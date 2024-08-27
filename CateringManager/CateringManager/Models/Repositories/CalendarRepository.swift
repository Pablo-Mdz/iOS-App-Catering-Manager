//
//  CalendarRepository.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 18/07/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CalendarRepository: ObservableObject {
    private let db = Firestore.firestore() // swiftlint:disable:this identifier_name

    func fetchEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Event.self)
        }
    }

}
