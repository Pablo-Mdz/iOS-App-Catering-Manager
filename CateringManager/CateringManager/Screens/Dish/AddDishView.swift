//
//  AddDishView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//
import SwiftUI

struct AddDishView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dishes: [Dish]
    @State private var dishName: String = ""
    @State private var dishDescription: String = ""
    @State private var servings: Int = 1
    @State private var ingredients: [Ingredient] = []
    @State private var ingredientName: String = ""
    @State private var ingredientQuantity: Int = 1
    @State private var ingredientUnit: Unit = .g
    @State private var ingredientPrice: Double = 0.0
    @State private var isDishNameEmpty: Bool = false
    @State private var isIngredientEmpty: Bool = false
    @State private var editingDishId: UUID? = nil // swiftlint:disable:this redundant_optional_initialization
    @ObservedObject var viewModel: MenuViewModel

    var body: some View {
        NavigationStack {
            Form {
                dishDetailsSection
                ingredientsSection
                ingredientListSection
            }
            .navigationTitle(editingDishId == nil ? "Add New Dish" : "Edit Dish")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if dishName.isEmpty {
                            isDishNameEmpty = true
                        } else {
                            saveDish()
                        }
                    }
                }
            }
        }
        .onAppear {
            if let dishId = editingDishId, let dish = dishes.first(where: { $0.id == dishId }) {
                dishName = dish.name
                dishDescription = dish.description
                servings = dish.servings
                ingredients = dish.ingredients
            }
            viewModel.fetchMenus()
        }
    }

    private var dishDetailsSection: some View {
        Section(header: Text("Dish Details")) {
            TextField("Dish Name", text: $dishName)
            if isDishNameEmpty {
                Text("Dish name cannot be empty")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            TextField("Dish Description", text: $dishDescription)
            Picker("Servings (Number of People)", selection: $servings) {
                ForEach(1..<101) { number in
                    Text("\(number)").tag(number)
                }
            }
        }
    }

    private var ingredientsSection: some View {
        Section(header: Text("Add Ingredients")) {
            TextField("Ingredient Name", text: $ingredientName)
            if isIngredientEmpty {
                Text("Ingredient name cannot be empty")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            HStack {
                Picker("Unit", selection: $ingredientUnit) {
                    Text("cc").tag(Unit.cc)
                    Text("g").tag(Unit.g)
                    Text("unit").tag(Unit.unit)
                }
                .pickerStyle(MenuPickerStyle())
                Picker("Quantity", selection: $ingredientQuantity) {
                    ForEach(ingredientQuantityRange, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            HStack {
                pricePicker
            }
            Button("Add Ingredient") {
                if ingredientName.isEmpty {
                    isIngredientEmpty = true
                } else {
                    addIngredient()
                }
            }
        }
    }

    private var ingredientListSection: some View {
        Section(header: Text("Ingredients List")) {
            ForEach(ingredients) { ingredient in
                HStack {
                    Text(ingredient.name)
                    Spacer()
                    Text(String(format: "€%.2f", ingredient.price))
                    Text("\(ingredient.quantity) \(ingredient.unit.rawValue)")
                }
                .padding(.vertical, 5)
                .swipeActions(edge: .trailing) {
                    Button("Delete", role: .destructive) {
                        deleteIngredient(ingredient)
                    }
                }
                .swipeActions(edge: .leading) {
                    Button("Edit", role: .none) {
                        editIngredient(ingredient)
                    }
                    .tint(.blue)
                }
            }
        }
    }

    private var pricePicker: some View {
        Picker("Price", selection: $ingredientPrice) {
            ForEach(priceRange, id: \.self) { price in
                Text(String(format: "€%.1f", price)).tag(price)
            }
        }
    }

    private var priceRange: [Double] {
        Array(stride(from: 0.0, to: 500.0, by: 0.5))
    }

    private var ingredientQuantityRange: [Int] {
        if ingredientUnit == .unit {
            return (1...100).map { $0 } + Array(stride(from: 50, to: 5001, by: 50))
        } else {
            return Array(stride(from: 10, to: 10001, by: 10))
        }
    }

    private func addIngredient() {
        let newIngredient = Ingredient(id: UUID(), name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit, price: ingredientPrice)
        ingredients.append(newIngredient)
        ingredientName = ""
        ingredientQuantity = 1
        ingredientPrice = 0.0
    }

    private func deleteIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
    }

    private func editIngredient(_ ingredient: Ingredient) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredientName = ingredient.name
            ingredientQuantity = ingredient.quantity
            ingredientUnit = ingredient.unit
            ingredientPrice = ingredient.price
            ingredients.remove(at: index)
        }
    }

    private func saveDish() {
        let newDish = Dish(id: editingDishId ?? UUID(), name: dishName, description: dishDescription, servings: servings, ingredients: ingredients)
        if let index = dishes.firstIndex(where: { $0.id == newDish.id }) {
            dishes[index] = newDish
        } else {
            dishes.append(newDish)
        }
        dismiss()
    }
}

struct AddDishView_Previews: PreviewProvider {
    static var previews: some View {
        AddDishView(dishes: .constant([]), viewModel: MenuViewModel())
    }
}
