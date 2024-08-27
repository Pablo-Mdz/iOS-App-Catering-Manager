//
//  EventsViewModel.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth
@MainActor
class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var menus: [Menu] = []
    private var db = Firestore.firestore() // swiftlint:disable:this identifier_name
    private var cancellables = Set<AnyCancellable>()
    private let eventRepository = EventRepository()
    private let menuRepository = MenuRepository()
    
    func fetchEvents() {
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting events: \(error)")
                return
            }
            // to clean the background threads
            DispatchQueue.main.async {
                self.events = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Event.self)
                } ?? []
            }
        }
    }
    func fetchMenus() {
        Task {
            do {
                self.menus = try await menuRepository.fetchMenus(userId: Auth.auth().currentUser?.uid ?? "")
            } catch {
                print("Error fetching menus: \(error)")
            }
        }
    }
    func addEvent(event: Event) {
        do {
            _ = try db.collection("events").addDocument(from: event)
            self.events.append(event)
            print("Event added to Firestore: \(event.title) at \(event.startDate)")
        } catch {
            print("Error adding event: \(error)")
        }
        let now = Date()
        let calendar = Calendar.current
        if let eventDateMinusOneDay = calendar.date(byAdding: .day, value: -1, to: event.startDate) {
            if eventDateMinusOneDay > now {
                print("Event scheduled: \(event.title) at \(event.startDate)")
                scheduleNotification(for: event)
            } else {
                print("Event not scheduled because the date is in the past.")
            }
        }
        print("Current date (UTC): \(now)")
        print("Event startDate (UTC): \(event.startDate)")
        print("Current date (Local): \(convertToLocalTime(now))")
        print("Event startDate (Local): \(convertToLocalTime(event.startDate))")
    }
    func convertToLocalTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    func deleteEvent(withId id: String) {
        Task {
            do {
                eventRepository.deleteEvent(withId: id)
                fetchEvents()
            }
        }
    }
    func updateEventTitle(withId id: String, newTitle: String) {
        Task {
            do {
                eventRepository.updateEventTitle(withId: id, newTitle: newTitle)
                fetchEvents()
            }
        }
    }
    func updateEvent(_ event: Event) {
        Task {
            do {
                try eventRepository.updateEvent(event)
                fetchEvents()
            } catch {
                print("Error updating event: \(error)")
            }
        }
    }
    func updateAdress(withId id: String, newAdress: String) {
        Task {
            do {
                eventRepository.updateAdress(withId: id, newAdress: newAdress)
                fetchEvents()
            }
        }
    }
    func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.body = "Don't forget: \(event.title) starts tomorrow!"
        content.badge = 1
        if let eventDate = Calendar.current.date(byAdding: .day, value: -1, to: event.startDate) {
            print("Scheduling notification for: \(eventDate)")
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: eventDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully!")
                }
            }
        } else {
            print("Error calculating eventDate")
        }
    }
}
