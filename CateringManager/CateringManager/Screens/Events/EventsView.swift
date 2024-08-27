//
//  EventsView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//
import SwiftUI

struct EventsView: View {
    @StateObject var viewModel = EventViewModel()
    @State private var showingAddEventSheet = false
    @State private var editingEventId: String?
    @State private var newEventTitle: String = ""
    @State private var showDeleteConfirmation = false
    @State private var eventToDeleteId: String?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        NavigationStack {
            ScrollView {
                Image("logo-transp")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(15)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.events.sorted(by: { $0.startDate > $1.startDate })) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            VStack {
                                Spacer()
                                Text(event.title)
                                    .font(.title2)
                                    .foregroundColor(CostumColors.accentColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Spacer()
                                Text(dateFormatter.string(from: event.startDate))
                                    .font(.subheadline)
                                    .foregroundColor(CostumColors.accentColor)
                                    .padding(.bottom, 10)
                            }
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(CostumColors.secondaryColor)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .contextMenu {
                                Button("Edit Title") {
                                    editingEventId = event.id
                                    newEventTitle = event.title
                                }
                                Button("Delete Event", role: .destructive) {
                                    eventToDeleteId = event.id
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(CostumColors.primaryColor.opacity(0.1))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddEventSheet.toggle()
                    }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingAddEventSheet) {
                        AddEventView(viewModel: viewModel)
                    }
                }
            }
            .onAppear {
                viewModel.fetchEvents()
            }
            .alert("Edit Event Title", isPresented: Binding<Bool>(
                get: { editingEventId != nil },
                set: { if !$0 { editingEventId = nil } }
            )) {
                TextField("New Title", text: $newEventTitle)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    if let id = editingEventId {
                        viewModel.updateEventTitle(withId: id, newTitle: newEventTitle)
                    }
                }
            }
            .alert("Are you sure you want to delete this event?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let id = eventToDeleteId {
                        viewModel.deleteEvent(withId: id)
                    }
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}

#Preview {
    EventsView()
}
