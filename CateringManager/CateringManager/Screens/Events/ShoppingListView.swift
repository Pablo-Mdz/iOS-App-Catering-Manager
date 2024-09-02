//
//  ShoppingListView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 05/08/2024.
//

import SwiftUI
import PDFKit

struct ShoppingListView: View {
    var ingredients: [Ingredient]
    var eventTitle: String
    var eventDate: Date
    @State private var pdfURL: URL?
    @EnvironmentObject private var todoListViewModel: ToDoListViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Text("List of products for the event \(eventTitle) \ndate: \(dateFormatter.string(from: eventDate))")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()

            List {
                ForEach(ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text("\(ingredient.quantity) \(ingredient.unit.rawValue)")
                        Text(String(format: "€%.2f", ingredient.price))
                    }
                }
            }
            Button(action: addToToDoList) {
                Text("Add to ToDo List")
            }
            .padding()
        }
        .padding()
        .background(CostumColors.primaryColor.opacity(0.1))
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private func addToToDoList() {
        let ingredientTitles = ingredients.map { ingredient in
            "\(ingredient.quantity) \(ingredient.unit.rawValue) of \(ingredient.name)"
        }
        todoListViewModel.createNewToDoItems(titles: ingredientTitles)
        dismiss()
    }
}
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView(
            ingredients: [
                Ingredient(id: UUID(), name: "Tomato", quantity: 10, unit: .cc, price: 5.0),
                Ingredient(id: UUID(), name: "Cheese", quantity: 2, unit: .cc, price: 20.0)
            ],
            eventTitle: "Birthday Party",
            eventDate: Date()
        )
    }
}
