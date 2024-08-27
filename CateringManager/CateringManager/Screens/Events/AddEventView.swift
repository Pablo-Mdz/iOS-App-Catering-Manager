//
//  AddEventView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 11/07/2024.
//
import SwiftUI

struct AddEventView: View {
    @StateObject var viewModel = EventViewModel()
    @State private var title: String = ""
    @State private var address: String = ""
    @State private var contactName: String = ""
    @State private var contactPhone: String = ""
    @State private var contactEmail: String = ""
    @State private var guestCount: Int = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date?
    @State private var startHour: Date = Date()
    @State private var hasEndDate: Bool = false
    @State private var selectedMenuId: String?
    @State private var notes: String = ""
    @Environment(\.dismiss) private var dismiss

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
                Picker("Select Menu", selection: $selectedMenuId) {
                    ForEach(viewModel.menus) { menu in
                        Text(menu.name).tag(menu.id)
                    }
                }
                Button("Save") {
                    let combinedDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: startHour),
                         minute: Calendar.current.component(.minute, from: startHour),
                         second: 0, of: startDate)

                    let newEvent = Event(
                        title: title,
                        address: address,
                        contactName: contactName,
                        contactPhone: contactPhone,
                        contactEmail: contactEmail,
                        guestCount: guestCount,
                        startDate: combinedDate ?? startDate,  // swiftlint:disable:this trailing_whitespace superfluous_disable_command
                        endDate: endDate,
                        startHour: startHour,
                        menuId: selectedMenuId,
                        notes: notes
                    )
                    viewModel.addEvent(event: newEvent)
                    dismiss()
                }
            }
            .navigationTitle("Add New Event")
            .onAppear {
                viewModel.fetchMenus()
            }
        }
    }
}

extension Binding {
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

#Preview {
    AddEventView()
}
