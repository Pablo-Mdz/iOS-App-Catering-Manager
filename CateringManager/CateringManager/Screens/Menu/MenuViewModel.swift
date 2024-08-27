//
//  MenuViewModel.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class MenuViewModel: ObservableObject {
    private let firebaseFirestore = Firestore.firestore() // swiftlint:disable:this superfluous_disable_command
    private let repository = MenuRepository()
    @Published var menus: [Menu] = []
    @Published var selectedMenu: Menu?
    @Published var menuName = ""
    @Published var menuDescription = ""
    @Published var costPerPerson: Double = 0.0
    @Published var numberOfGuests: Int = 0
    // Ingredient properties
    @Published var ingredientName: String = ""
    @Published var ingredientQuantity: Int = 1
    @Published var ingredientUnit: Unit = .g
    @Published var ingredientPrice: Double = 0.0
    func createMenu(newMenu: Menu) {
        do {
            try repository.addMenu(newMenu)
            fetchMenus()
        } catch {
            print("error \(error)")
        }
    }
    func fetchMenus() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        Task {
            do {
                self.menus = try await repository.fetchMenus(userId: userId)
            } catch {
                print("error in menu viewModel \(error)")
            }
        }
    }
    func fetchMenuId(menuId id: String) {
        Task {
            do {
                if let menu = try await repository.fetchMenuId(menuId: id) {
                    self.selectedMenu = menu
                }
            } catch {
                print("error in menu viewModel \(error)")
            }
        }
    }
    func updateMenuTitle(withId id: String, name: String) {
        guard let index = menus.firstIndex(where: { $0.id == id }) else {
            return
        }
        menus[index].name = name
        do {
            try repository.updateMenu(menus[index])
            fetchMenus()
        } catch {
            print("Error updating menu: \(error)")
        }
    }
    func deleteMenu(withId id: String) {
        repository.deleteMenu(menuId: id)
        fetchMenus()
    }
    func addDish(_ dish: Dish, toMenu menuId: String) {
        guard let index = menus.firstIndex(where: { $0.id == menuId }) else {
            return
        }
        menus[index].dishes.append(dish)
        do {
            try repository.updateMenu(menus[index])
            fetchMenus()
        } catch {
            print("Error adding dish: \(error)")
        }
    }
    func updateDish(_ dish: Dish, inMenu menuId: String) {
        guard let menuIndex = menus.firstIndex(where: { $0.id == menuId }),
              let dishIndex = menus[menuIndex].dishes.firstIndex(where: { $0.id == dish.id }) else {
            return
        }
        menus[menuIndex].dishes[dishIndex] = dish
        do {
            try repository.updateMenu(menus[menuIndex])
            fetchMenus()
        } catch {
            print("Error updating dish: \(error)")
        }
    }
    func updateMenu(_ menu: Menu) {
        do {
            try repository.updateMenu(menu)
            fetchMenus()
        } catch {
            print("Error updating menu: \(error)")
        }
    }
    func deleteDish(_ dish: Dish, fromMenu menuId: String) {
        guard let menuIndex = menus.firstIndex(where: { $0.id == menuId }) else {
            return
        }
        menus[menuIndex].dishes.removeAll { $0.id == dish.id }
        do {
            try repository.updateMenu(menus[menuIndex])
            fetchMenus()
        } catch {
            print("Error deleting dish: \(error)")
        }
    }
    // Ingredient-related methods
    func addIngredient(_ ingredient: Ingredient, toDish dishId: UUID, inMenu menuId: String) {
        guard let menuIndex = menus.firstIndex(where: { $0.id == menuId }),
              let dishIndex = menus[menuIndex].dishes.firstIndex(where: { $0.id == dishId }) else {
            return
        }
        menus[menuIndex].dishes[dishIndex].ingredients.append(ingredient)
        do {
            try repository.updateMenu(menus[menuIndex])
            fetchMenus()
        } catch {
            print("Error adding ingredient: \(error)")
        }
    }
    func deleteIngredient(_ ingredient: Ingredient, fromDish dishId: UUID, inMenu menuId: String) {
        guard let menuIndex = menus.firstIndex(where: { $0.id == menuId }),
              let dishIndex = menus[menuIndex].dishes.firstIndex(where: { $0.id == dishId }) else {
            return
        }
        menus[menuIndex].dishes[dishIndex].ingredients.removeAll { $0.id == ingredient.id }
        do {
            try repository.updateMenu(menus[menuIndex])
            fetchMenus()
        } catch {
            print("Error deleting ingredient: \(error)")
        }
    }
    func updateIngredient(_ updatedIngredient: Ingredient, inDish dishId: UUID, inMenu menuId: String) {
        guard let menuIndex = menus.firstIndex(where: { $0.id == menuId }),
              let dishIndex = menus[menuIndex].dishes.firstIndex(where: { $0.id == dishId }),
              let ingredientIndex = menus[menuIndex].dishes[dishIndex].ingredients.firstIndex(where: { $0.id == updatedIngredient.id }) else {
            return
        }
        menus[menuIndex].dishes[dishIndex].ingredients[ingredientIndex] = updatedIngredient
        do {
            try repository.updateMenu(menus[menuIndex])
            fetchMenus()
        } catch {
            print("Error updating ingredient: \(error)")
        }
    }
    // other functions // EditDishView // Picker Helpers
    var pricePicker: some View {
        Picker("Price", selection: Binding(
            get: { self.ingredientPrice },
            set: { self.ingredientPrice = $0 }
        )) {
            ForEach(priceRange, id: \.self) { price in
                Text(String(format: "€%.1f", price)).tag(price)
            }
        }
    }
    var priceRange: [Double] {
        Array(stride(from: 0.0, to: 500.0, by: 0.5))
    }
    var ingredientQuantityRange: [Int] {
        if ingredientUnit == .unit {
            return (1...100).map { $0 } + Array(stride(from: 50, to: 5001, by: 50))
        } else {
            return Array(stride(from: 10, to: 10001, by: 10))
        }
    }
    // DishView
    func adjustedQuantity(for ingredient: Ingredient, in dish: Dish, numberOfGuests: Int) -> Int {
        let scalingFactor = Double(numberOfGuests) / Double(dish.servings)
        return Int(Double(ingredient.quantity) * scalingFactor)
    }
    func adjustedPrice(for ingredient: Ingredient, in dish: Dish, numberOfGuests: Int) -> Double {
        let scalingFactor = Double(numberOfGuests) / Double(dish.servings)
        return ingredient.price * scalingFactor
    }
    func calculateDishSubtotal(for dish: Dish, numberOfGuests: Int) -> Double {
        let scalingFactor = Double(numberOfGuests) / Double(dish.servings)
        return dish.ingredients.reduce(0) { subtotal, ingredient in
            subtotal + ingredient.price * scalingFactor
        }
    }
}
