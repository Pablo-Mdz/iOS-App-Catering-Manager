//
//  EventRepository.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 11/07/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class EventRepository: ObservableObject {
    private let db = Firestore.firestore() // swiftlint:disable:this identifier_name

    func fetchEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Event.self)
        }
    }

    func addEvent(_ event: Event) throws {
        try db.collection("events").document(event.id ?? UUID().uuidString).setData(from: event)
    }

    func deleteEvent(withId id: String) {
        db.collection("events").document(id).delete()
    }

    func updateEventTitle(withId id: String, newTitle: String) {
        db.collection("events").document(id).updateData(["title": newTitle])
    }

    func updateEvent(_ event: Event) throws {
           try db.collection("events").document(event.id ?? UUID().uuidString).setData(from: event)
       }

    func updateAdress(withId id: String, newAdress: String) {
        db.collection("events").document(id).updateData(["address": newAdress])
    }

}
