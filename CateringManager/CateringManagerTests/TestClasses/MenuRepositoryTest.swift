//
//  TestMenuRepository.swift
//  CateringManagerTests
//
//  Created by Pablo Cigoy on 23/08/2024.
//

import XCTest
@testable import CateringManager

final class MenuRepositoryTests: XCTestCase {

    private var menuRepository: MenuRepository!
    private let menu = Menu(
            userId: "testUserID",
            name: "Test Menu",
            description: "desc",
            costPerPerson: 44.5,
            dishes: []
        )
    
    override func setUpWithError() throws {
        // Setup before each test execution
        self.menuRepository = MenuRepository()
    }

    override func tearDownWithError() throws {
        // Cleanup after each test
        self.menuRepository = nil
    }

    func testUpdateMenu() async throws {
        // Given: Add a sample menu
        // menu
        try menuRepository.addMenu(menu)
        
        // When: Update the menu's name
        var updatedMenu = menu
        updatedMenu.name = "Updated Menu Name"
        try menuRepository.updateMenu(updatedMenu)
        
        // Then: Verify that the menu was updated correctly
        let menus = try await menuRepository.fetchMenus(userId: menu.userId)
        XCTAssertTrue(menus.contains(where: { $0.name == "Updated Menu Name" }), "The menu's name should have been updated")
    }

    func testFetchMenus() async throws {
        // When: Retrieve menus for a specific user from the repository
        let menus = try await menuRepository.fetchMenus(userId: "testUserID")
        
        // Then: Verify that the menu list is not empty
        XCTAssertNotNil(menus, "The menu list should not be empty")
        XCTAssertGreaterThan(menus.count, 0, "The menu list should contain at least one menu")
    }
}
