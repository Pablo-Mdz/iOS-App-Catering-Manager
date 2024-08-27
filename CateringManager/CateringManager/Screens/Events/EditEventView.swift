//
//  EditEventView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 22/07/2024.
//

import SwiftUI

struct EditEventView: View {
    @StateObject var viewModel = EventViewModel()
    @State var event: Event
    @State private var title: String
    @State private var address: String
    @State private var contactName: String
    @State private var contactPhone: String
    @State private var contactEmail: String
    @State private var guestCount: Int
    @State private var startDate: Date
    @State private var endDate: Date?
    @State private var startHour: Date
    @State private var hasEndDate: Bool
    @State private var selectedMenuId: String?
    @State private var notes: String
    @Environment(\.dismiss) private var dismiss

    init(event: Event) {
        self.event = event
        _title = State(initialValue: event.title)
        _address = State(initialValue: event.address)
        _contactName = State(initialValue: event.contactName)
        _contactPhone = State(initialValue: event.contactPhone)
        _contactEmail = State(initialValue: event.contactEmail)
        _guestCount = State(initialValue: event.guestCount)
        _startDate = State(initialValue: event.startDate)
        _endDate = State(initialValue: event.endDate)
        _startHour = State(initialValue: event.startHour)
        _hasEndDate = State(initialValue: event.endDate != nil)
        _selectedMenuId = State(initialValue: event.menuId)
        _notes = State(initialValue: event.notes)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Title", text: $title)
                    TextField("Contact Name", text: $contactName)
                    TextField("Event Address", text: $address)
                    TextField("Contact Phone", text: $contactPhone)
                    TextField("Contact Email", text: $contactEmail)
                }
                Section(header: Text("Number of guests")) {
                    TextField("Guest Count", value: $guestCount, formatter: NumberFormatter())
                }
                Section(header: Text("Date")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    Toggle("Has End Date", isOn: $hasEndDate)
                    if hasEndDate {
                        DatePicker("End Date", selection: Binding($endDate, default: startDate), displayedComponents: .date)
                    }
                    DatePicker("Start Hour", selection: $startHour, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes)
                }
                Section(header: Text("Select Menu")) {
                    Picker("Select Menu", selection: $selectedMenuId) {
                        ForEach(viewModel.menus) { menu in
                            Text(menu.name).tag(menu.id)
                        }
                    }
                }
                Button("Save") {
                    let updatedEvent = Event(
                        id: event.id,
                        title: title,
                        address: address,
                        contactName: contactName,
                        contactPhone: contactPhone,
                        contactEmail: contactEmail,
                        guestCount: guestCount,
                        startDate: startDate,
                        endDate: endDate,
                        startHour: startHour,
                        menuId: selectedMenuId,
                        notes: notes
                    )
                    viewModel.updateEvent(updatedEvent)
                    viewModel.fetchEvents()
                    dismiss()
                }
            }
            .navigationTitle("Edit Event")
            .onAppear {
                viewModel.fetchMenus()
                viewModel.fetchEvents()
            }
        }
    }
}

#Preview {
    EditEventView(event: Event(
        id: "1234",
        title: "18 Birthday ",
        address: "Bürgerstr. 1, 13409",
        contactName: "Noelia Knopf",
        contactPhone: "+49 123124849494",
        contactEmail: "pablo@cigoy.com",
        guestCount: 150,
        startDate: Date(),
        endDate: Date().addingTimeInterval(7200),
        startHour: Date(),
        menuId: "sampleMenuId",
        notes: "notes for the event hier."
    ))
}
