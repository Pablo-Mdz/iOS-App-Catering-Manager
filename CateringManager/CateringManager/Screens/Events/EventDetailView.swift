//
//  AddMenuView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event
    @StateObject private var viewModel = EventViewModel()
    @StateObject private var menuViewModel = MenuViewModel()
    @State private var isEditing = false
    @State private var newAddress: String = ""
    @State private var showCopyAlert = false
    @State private var isEditingAddress = false
    @State private var showEditEventView = false
    @State private var showingShoppingList = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Event Title
                Text(event.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .padding(.horizontal)

                // Event Details
                Group {
                    EventDetailRow(title: "Contact Name", value: event.contactName)
                    EventDetailRow(title: "Contact Phone", value: event.contactPhone)
                    EventDetailRow(title: "Contact Email", value: event.contactEmail)
                    EventDetailRow(title: "Guest Count", value: "\(event.guestCount)")
                    EventDetailRow(title: "Start Date", value: dateFormatter.string(from: event.startDate))
                    if let endDate = event.endDate {
                        EventDetailRow(title: "End Date", value: dateFormatter.string(from: endDate))
                    }
                    EventDetailRow(title: "Start hour", value: timeFormatter.string(from: event.startHour))
                    EventDetailRow(title: "Notes", value: event.notes)
                }
                .padding(.horizontal)

                // Address with Copy Functionality
                VStack(alignment: .leading, spacing: 10) {
                    Text("Address")
                        .font(.headline)
                    if isEditingAddress {
                        TextField("New Address", text: $newAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack {
                            Button("Save") {
                                viewModel.updateAdress(withId: event.id!, newAdress: newAddress)
                                isEditingAddress = false
                                viewModel.fetchEvents()
                            }
                            Button("Cancel") {
                                isEditingAddress = false
                                newAddress = event.address
                            }
                        }
                    } else {
                        HStack {
                            Text(event.address)
                                .font(.subheadline)
                            Button(action: {
                                UIPasteboard.general.string = event.address
                                showCopyAlert.toggle()
                            }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.blue)
                            }
                            .alert(isPresented: $showCopyAlert) {
                                Alert(title: Text("Address Copied"), message: Text("The address has been copied to the clipboard."), dismissButton: .default(Text("OK")))
                            }
                            Spacer()
                            Button("Edit") {
                                isEditingAddress = true
                                newAddress = event.address
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

                // Map View
                MapView(address: event.address, eventName: event.title)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)

                // Menu Details
                if let menu = menuViewModel.selectedMenu {
                    Divider()
                        .background(CostumColors.primaryColor.opacity(0.1))
                        .padding(.horizontal, 10)
                    Text("Menu: \(menu.name)")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                        .padding(.horizontal)
                    ForEach(menu.dishes) { dish in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(dish.name)
                                .font(.headline)
                            Text(dish.description)
                                .font(.subheadline)
//                            Text("Servings: \(dish.servings)")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                ForEach(calculateIngredients(for: dish)) { ingredient in
                                    HStack {
                                        Text(ingredient.name)
                                        Spacer()
                                        Text("\(ingredient.quantity) \(ingredient.unit.rawValue)")
                                        Text(String(format: "€%.2f", ingredient.price))
                                    }
                                    .padding(.vertical, 5)
                                    Divider()
                                }
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            Text("Subtotal: \(String(format: "€%.2f", calculateDishSubtotal(for: dish)))")
                                .font(.headline)
                                .padding(.top, 5)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }

                    Text("Total Cost: \(String(format: "€%.2f", calculateTotalCost(for: menu)))")
                        .font(.headline)
                        .padding(.top, 20)
                        .padding(.horizontal)

                    Button(action: {
                        showingShoppingList.toggle()
                    }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                        Text("View Shopping List")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(CostumColors.primaryColor)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .sheet(isPresented: $showingShoppingList) {
                        ShoppingListView(ingredients: compileShoppingList(), eventTitle: event.title, eventDate: event.startDate)
                    }
                }
                Spacer()
            }
            .padding(.vertical)
            .navigationBarItems(trailing: Button(action: {
                showEditEventView = true
            }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                Image(systemName: "pencil")
            })
            .sheet(isPresented: $showEditEventView) {
                EditEventView(event: event)
            }
        }
        .background(CostumColors.primaryColor.opacity(0.1))
        .onAppear {
            if let menuId = event.menuId {
                menuViewModel.fetchMenuId(menuId: menuId)
            }
            viewModel.fetchEvents()
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    private func calculateIngredients(for dish: Dish) -> [Ingredient] {
        let multiplier = event.guestCount / dish.servings
        return dish.ingredients.map { ingredient in
            let newQuantity = ingredient.quantity * multiplier
            let newPrice = ingredient.price * Double(newQuantity) / Double(ingredient.quantity)
            return Ingredient(id: ingredient.id, name: ingredient.name, quantity: newQuantity, unit: ingredient.unit, price: newPrice)
        }
    }

    private func calculateDishSubtotal(for dish: Dish) -> Double {
        let ingredients = calculateIngredients(for: dish)
        return ingredients.reduce(0) { $0 + $1.price }
    }

    private func calculateTotalCost(for menu: Menu) -> Double {
        return menu.dishes.reduce(0) { $0 + calculateDishSubtotal(for: $1) }
    }

    private func compileShoppingList() -> [Ingredient] {
        var ingredientDict: [String: Ingredient] = [:]
        guard let menu = menuViewModel.selectedMenu else { return [] }

        for dish in menu.dishes {
            let scalingFactor = Double(event.guestCount) / Double(dish.servings)
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
}

struct EventDetailRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Event(
            id: "1234",
            title: "18 Birthday ",
            address: "Bürgerstr. 1, 13409",
            contactName: "Noelia Knopf",
            contactPhone: "+49 123124849494",
            contactEmail: "pablo@cigoy.com",
            guestCount: 150,
            startDate: Date(),
            endDate: Date().addingTimeInterval(7200),
            startHour: Date(),
            menuId: "234234",
            notes: "notes for the event hier."
        ))
    }
}
