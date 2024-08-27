//
//  TestEventRepository.swift
//  CateringManagerTests
//
//  Created by Pablo Cigoy on 23/08/2024.
//

import XCTest
@testable import CateringManager

final class EventRepositoryTests: XCTestCase {

    private var eventRepository: EventRepository!
    private let event = Event(
        id: "testEventID",
        title: "Test Event for EventRepository",
        address: "BürgerStr 4, 13455",
        contactName: "Pablo",
        contactPhone: "1234567890",
        contactEmail: "pablo@cigoy.com",
        guestCount: 50,
        startDate: Date(),
        endDate: nil,
        startHour: Date(),
        menuId: nil,
        notes: "Some note"
    )
    
    override func setUpWithError() throws {
        // Setup before each test execution
        self.eventRepository = EventRepository()
    }

    override func tearDownWithError() throws {
        // Cleanup after each test
        self.eventRepository = nil
    }

    func testAddEvent() async throws {
        // Given: Create a sample event
        // event
        // When: Add the event to the repository
        try eventRepository.addEvent(event)
        
        // Then: Try to retrieve the added event to verify it was correctly added
        let events = try await eventRepository.fetchEvents()
        XCTAssertTrue(events.contains(where: { $0.id == event.id }), "The event should have been added to the repository")
    }

    func testDeleteEvent() async throws {
        // Given: Add a sample event
        // event
        try eventRepository.addEvent(event)
        
        // When: Delete the event
        eventRepository.deleteEvent(withId: event.id ?? "")
        
        // Then: Verify that the event was deleted
        let events = try await eventRepository.fetchEvents()
        XCTAssertFalse(events.contains(where: { $0.id == event.id }), "The event should have been deleted from the repository")
    }

    func testUpdateEventTitle() async throws {
        // Given: Add a sample event
        // event
        try eventRepository.addEvent(event)
        
        // When: Update the event's title
        let newTitle = "New Title"
        eventRepository.updateEventTitle(withId: event.id ?? "", newTitle: newTitle)
        
        // Then: Verify that the title was correctly updated
        let events = try await eventRepository.fetchEvents()
        XCTAssertTrue(events.contains(where: { $0.title == newTitle }), "The event's title should have been updated")
    }

    func testFetchEvents() async throws {
        // When: Retrieve events from the repository
        let events = try await eventRepository.fetchEvents()
        
        // Then: Verify that the event list is not empty
        XCTAssertNotNil(events, "The event list should not be empty")
        XCTAssertGreaterThan(events.count, 0, "The event list should contain at least one event")
    }
}
