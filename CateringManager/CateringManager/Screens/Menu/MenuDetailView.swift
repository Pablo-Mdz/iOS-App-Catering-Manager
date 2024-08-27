//
//  MenuDetailView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import SwiftUI

struct MenuDetailView: View {
    @ObservedObject var menuViewModel: MenuViewModel
    @State private var showingShoppingList = false
    @State private var showingEditMenu = false
    @State private var numberOfGuests: String = "10"
    var menuId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let menu = menuViewModel.selectedMenu {
                    HStack {
                        Text(menu.name)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Button(action: {
                            showingEditMenu.toggle()
                        }) {  // swiftlint:disable:this multiple_closures_with_trailing_closure
                            Image(systemName: "pencil")
                                .font(.title)
                        }
                    }

                    Text(menu.description)
                        .font(.body)
                        .padding(.bottom, 20)
                    HStack {
                        Text("Number of guests: ")
                            .font(.body)
                        TextField("Number of guests", text: $numberOfGuests)
                            .keyboardType(.numberPad)
                            .font(.body)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 20)

                    if !menu.dishes.isEmpty {
                        Text("Dishes")
                            .font(.title2)
                            .bold()
                        ForEach(menu.dishes) { dish in
                            DishView(dish: dish, numberOfGuests: Binding(
                                get: { Int(numberOfGuests) ?? 0 },
                                set: { numberOfGuests = String($0) }
                            ), menuViewModel: MenuViewModel())
                            .padding()
//                            .background(CostumColors.primaryColor.opacity(0.2))
                            .cornerRadius(5)
                        }
                    }

                    Text("Total Cost: \(String(format: "€%.2f", calculateTotalCost()))")
                        .font(.headline)
                        .padding(.top, 20)

                    Button(action: {
                        showingShoppingList.toggle()
                    }) {  // swiftlint:disable:this multiple_closures_with_trailing_closure
                        Text("View Shopping List")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(CostumColors.primaryColor)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    .sheet(isPresented: $showingShoppingList) {
                        ShoppingListView(ingredients: compileShoppingList(), eventTitle: "event", eventDate: Date())
                    }
                }
            }
            .onAppear {
                menuViewModel.fetchMenuId(menuId: menuId)
            }
            .padding()
        }
        .sheet(isPresented: $showingEditMenu) {
            if let menu = menuViewModel.selectedMenu {
                EditMenuView(menu: menu, onSave: { updatedMenu in
                    menuViewModel.selectedMenu = updatedMenu
                })
                .environmentObject(menuViewModel)
            }
        }
        .background(CostumColors.primaryColor.opacity(0.1))
    }

    private func compileShoppingList() -> [Ingredient] {
        var ingredientDict: [String: Ingredient] = [:]
        guard let guestCount = Int(numberOfGuests), let menu = menuViewModel.selectedMenu else { return [] }

        for dish in menu.dishes {
            let scalingFactor = Double(guestCount) / Double(dish.servings)
            for ingredient in dish.ingredients {
                let adjustedQuantity = Double(ingredient.quantity) * scalingFactor
                if let existingIngredient = ingredientDict[ingredient.name] {
                    let newQuantity = existingIngredient.quantity + Int(adjustedQuantity)
                    let updatedIngredient = Ingredient(id: existingIngredient.id, name: existingIngredient.name, quantity: newQuantity, unit: existingIngredient.unit, price: existingIngredient.price)
                    ingredientDict[ingredient.name] = updatedIngredient
                } else {
                    let newIngredient = Ingredient(id: ingredient.id, name: ingredient.name, quantity: Int(adjustedQuantity), unit: ingredient.unit, price: ingredient.price)
                    ingredientDict[ingredient.name] = newIngredient
                }
            }
        }

        return Array(ingredientDict.values)
    }

    private func calculateTotalCost() -> Double {
        guard let guestCount = Int(numberOfGuests), let menu = menuViewModel.selectedMenu else { return 0.0 }
        var totalCost: Double = 0.0

        for dish in menu.dishes {
            let servings = Double(dish.servings)
            for ingredient in dish.ingredients {
                let ingredientCostPerServing = ingredient.price / servings
                let ingredientCostForGuests = ingredientCostPerServing * Double(guestCount)
                totalCost += ingredientCostForGuests
            }
        }
        return totalCost
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView(menuViewModel: MenuViewModel(), menuId: "sampleMenuId")
    }
}
