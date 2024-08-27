//
//  DishView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 05/07/2024.
//
import SwiftUI

struct DishView: View {
    var dish: Dish
    @Binding var numberOfGuests: Int
    @ObservedObject var menuViewModel: MenuViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(dish.name)
                .font(.headline)
            Text(dish.description)
                .font(.subheadline)
//            Text("Servings: \(dish.servings)")
//                .font(.subheadline)
//                .foregroundColor(.brown)
            VStack(alignment: .leading) {
                ForEach(dish.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text("\(menuViewModel.adjustedQuantity(for: ingredient, in: dish, numberOfGuests: numberOfGuests)) \(ingredient.unit.rawValue)")
                        Text(String(format: "€%.2f", menuViewModel.adjustedPrice(for: ingredient, in: dish, numberOfGuests: numberOfGuests)))
                    }
                    .padding(.vertical, 5)
                    Divider()
                }
            }
            .padding()
            .background(Color(.white))
            .cornerRadius(10)
            Text("Subtotal: \(String(format: "€%.2f", menuViewModel.calculateDishSubtotal(for: dish, numberOfGuests: numberOfGuests)))")
                .font(.headline)
                .padding(.top, 5)
        }
        .padding(.bottom, 10)
    }
}

struct DishView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIngredients = [
            Ingredient(id: UUID(), name: "Chicken", quantity: 500, unit: .g, price: 5.0),
            Ingredient(id: UUID(), name: "Rice", quantity: 250, unit: .g, price: 2.5),
            Ingredient(id: UUID(), name: "Vegetables", quantity: 300, unit: .g, price: 3.0)
        ]
        let sampleDish = Dish(id: UUID(), name: "Grilled Chicken", description: "Grilled chicken with rice and vegetables", servings: 4, ingredients: sampleIngredients)
        let menuViewModel = MenuViewModel()
        DishView(dish: sampleDish, numberOfGuests: .constant(10), menuViewModel: menuViewModel)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
