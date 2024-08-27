//
//  EditDishView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 22/07/2024.
//

import SwiftUI

struct EditDishView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var menuViewModel: MenuViewModel
    @State private var name: String
    @State private var description: String
    @State private var servings: Int = 1
    @State private var ingredients: [Ingredient]
    @State private var showEditIngredientSheet = false
    @State private var ingredientToEdit: Ingredient?

    var dish: Dish
    var menuId: String
    var onSave: (Dish) -> Void

    init(dish: Dish, menuId: String, onSave: @escaping (Dish) -> Void) {
        self.dish = dish
        self.menuId = menuId
        self.onSave = onSave
        _name = State(initialValue: dish.name)
        _description = State(initialValue: dish.description)
        _servings = State(initialValue: dish.servings)
        _ingredients = State(initialValue: dish.ingredients)
        _menuViewModel = ObservedObject(initialValue: MenuViewModel())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dish Details")) {
                    TextField("Dish Name", text: $name)
                    TextField("Dish Description", text: $description)
                    Picker("Servings (Number of People)", selection: $servings) {
                        ForEach(1..<101) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                }

                Section(header: Text("Add Ingredients")) {
                    TextField("Ingredient Name", text: $menuViewModel.ingredientName)
                    HStack {
                        Picker("Unit", selection: $menuViewModel.ingredientUnit) {
                            Text("cc").tag(Unit.cc)
                            Text("g").tag(Unit.g)
                            Text("unit").tag(Unit.unit)
                        }
                        .pickerStyle(MenuPickerStyle())
                        Picker("Quantity", selection: $menuViewModel.ingredientQuantity) {
                            ForEach(menuViewModel.ingredientQuantityRange, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        menuViewModel.pricePicker
                    }
                    Button("Add Ingredient") {
                        let newIngredient = Ingredient(id: UUID(), name: menuViewModel.ingredientName, quantity: menuViewModel.ingredientQuantity, unit: menuViewModel.ingredientUnit, price: menuViewModel.ingredientPrice)
                        ingredients.append(newIngredient)
                        menuViewModel.ingredientName = ""
                        menuViewModel.ingredientQuantity = 1
                        menuViewModel.ingredientPrice = 0.0
                    }
                }

                Section(header: Text("Ingredients List")) {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\(ingredient.quantity) \(ingredient.unit.rawValue)")
                            Text(String(format: "€%.2f", ingredient.price))
                        }
                        .padding(.vertical, 5)
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                ingredients.removeAll { $0.id == ingredient.id }
                                menuViewModel.deleteIngredient(ingredient, fromDish: dish.id, inMenu: menuId)
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                ingredientToEdit = ingredient
                                showEditIngredientSheet = true
                            }
                            .tint(.blue)
                        }
                    }
                }

                Button("Save") {
                    let updatedDish = Dish(id: dish.id, name: name, description: description, servings: servings, ingredients: ingredients)
                    onSave(updatedDish)
                    menuViewModel.updateDish(updatedDish, inMenu: menuId)
                    print(updatedDish)
                    menuViewModel.fetchMenus()
                    dismiss()
                }
            }
            .navigationTitle("Edit Dish")
            .sheet(isPresented: $showEditIngredientSheet) {
                if let ingredientToEdit = ingredientToEdit {
                    EditIngredientView(ingredient: ingredientToEdit, dishId: dish.id, menuId: menuId, menuViewModel: menuViewModel)
                        .onDisappear {
                            // Update the ingredients in the EditDishView after the sheet is dismissed
                            if let updatedIngredient = menuViewModel.menus.first(where: { $0.id == menuId })?.dishes.first(where: { $0.id == dish.id })?.ingredients.first(where: { $0.id == ingredientToEdit.id }) {
                                if let index = ingredients.firstIndex(where: { $0.id == updatedIngredient.id }) {
                                    ingredients[index] = updatedIngredient
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            menuViewModel.fetchMenus()
        }
    }
}

struct EditDishView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIngredients = [
            Ingredient(id: UUID(), name: "Chicken", quantity: 500, unit: .g, price: 5.0),
            Ingredient(id: UUID(), name: "Rice", quantity: 250, unit: .g, price: 2.5),
            Ingredient(id: UUID(), name: "Vegetables", quantity: 300, unit: .g, price: 3.0)
        ]
        let sampleDish = Dish(id: UUID(), name: "Grilled Chicken", description: "Grilled chicken with rice and vegetables", servings: 4, ingredients: sampleIngredients)
        EditDishView(dish: sampleDish, menuId: "sampleMenuId") { updatedDish in  // swiftlint:disable:this unused_closure_parameter
            // handle save
        }
    }
}
