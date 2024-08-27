//
//  CateringManagerTests.swift
//  CateringManagerTests
//
//  Created by Pablo Cigoy on 22/08/2024.
//

import XCTest
@testable import CateringManager

final class CateringManagerTests: XCTestCase {

    private var viewModel: EventViewModel?
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = EventViewModel()
    }
    @MainActor
    func testFetchMenus() async throws {
            // When
        self.viewModel?.fetchMenus()

            // Then: The list shouls have 1 event minim.
            XCTAssertNotNil(viewModel!.menus, "the list menu should not be empty")
        }
    
    @MainActor
       func testAddEvent() async throws {
           // Given: Create a sample event
           let event = Event(
               id: nil,
               title: "Test Event",
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
           
           // Ensure the event list is initially empty
           XCTAssertEqual(viewModel!.events.count, 0, "The events list should start empty")

           // When: Add the event to the ViewModel
           viewModel?.addEvent(event: event)
           // Then: Verify that the event was added correctly
           XCTAssertGreaterThan(viewModel!.events.count, 0, "The events list should contain at least one event")
           XCTAssertEqual(viewModel!.events.first?.title, "Test Event", "The title of the first event should be 'Test Event'")
       }
    
}
