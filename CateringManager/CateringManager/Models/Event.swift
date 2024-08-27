//
//  Event.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var address: String
    var contactName: String
    var contactPhone: String
    var contactEmail: String
    var guestCount: Int
    var startDate: Date
    var endDate: Date?
    var startHour: Date
    var menuId: String?
    var notes: String
}
