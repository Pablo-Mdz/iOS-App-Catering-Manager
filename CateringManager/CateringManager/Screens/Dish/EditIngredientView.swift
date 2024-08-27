//
//  EditIngredientView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 22/07/2024.
//

import SwiftUI

struct EditIngredientView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var menuViewModel: MenuViewModel
    @State private var name: String
    @State private var quantity: Int
    @State private var price: Double
    @State private var unit: Unit
    var ingredient: Ingredient
    var dishId: UUID
    var menuId: String

    init(ingredient: Ingredient, dishId: UUID, menuId: String, menuViewModel: MenuViewModel) {
        self.ingredient = ingredient
        self.dishId = dishId
        self.menuId = menuId
        _name = State(initialValue: ingredient.name)
        _quantity = State(initialValue: ingredient.quantity)
        _price = State(initialValue: ingredient.price)
        _unit = State(initialValue: ingredient.unit)
        _menuViewModel = ObservedObject(initialValue: menuViewModel)
        menuViewModel.fetchMenus()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ingredient Details")) {
                    TextField("Ingredient Name", text: $name)
                    HStack {
                        HStack {
                            Text("Quantity")

                            TextField("Quantity", value: $quantity, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .foregroundColor(.blue)
                        }
                        Picker("Unit", selection: $unit) {
                            Text("cc").tag(Unit.cc)
                            Text("g").tag(Unit.g)
                            Text("unit").tag(Unit.unit)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("Price", value: $price, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Edit Ingredient")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let updatedIngredient = Ingredient(id: ingredient.id, name: name, quantity: quantity, unit: unit, price: price)
                        menuViewModel.updateIngredient(updatedIngredient, inDish: dishId, inMenu: menuId)
                        menuViewModel.fetchMenus()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIngredient = Ingredient(id: UUID(), name: "Carrot", quantity: 100, unit: .g, price: 1.0)
        EditIngredientView(ingredient: sampleIngredient, dishId: UUID(), menuId: "sampleMenuId", menuViewModel: MenuViewModel())
    }
}
