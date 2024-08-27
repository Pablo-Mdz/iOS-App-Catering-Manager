//
//  CalendarViewModel.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth

class CalendarViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var selectedDate = Date()
    private var db = Firestore.firestore() // swiftlint:disable:this identifier_name
    private var calendarRepository = CalendarRepository()
    func fetchEvents() {
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting events: \(error)")
                return
            }
            self.events = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Event.self)
            } ?? []
        }
    }

    func events(for date: Date) -> [Event] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date)
        }
    }

    func hasEvent(on date: Date) -> Bool {
        return !events(for: date).isEmpty
    }

    var monthAndYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    var daysInMonth: [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: selectedDate) else { return [] }
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
        return range.compactMap { Calendar.current.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }

    var firstDayOffset: Int {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        return (weekday + 5) % 7 // Adjusting the offset to start with Monday
    }
}
