//
//  EditMenuView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 22/07/2024.
//

import SwiftUI

struct EditMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var menuViewModel: MenuViewModel
    @State private var name: String
    @State private var description: String
    @State private var costPerPerson: Double
    @State private var dishes: [Dish]
    @State private var editingDish: Dish?
    @State private var showingAddDishSheet = false

    var menu: Menu
    var onSave: (Menu) -> Void

    init(menu: Menu, onSave: @escaping (Menu) -> Void) {
        self.menu = menu
        self.onSave = onSave
        _name = State(initialValue: menu.name)
        _description = State(initialValue: menu.description)
        _costPerPerson = State(initialValue: menu.costPerPerson)
        _dishes = State(initialValue: menu.dishes)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Menu Details")) {
                    TextField("Menu Name", text: $name)
                    TextField("Menu Description", text: $description)
                    TextField("Cost Per Person", value: $costPerPerson, formatter: NumberFormatter())
                }

                Section(header: Text("Dishes")) {
                    ForEach(dishes) { dish in
                        HStack {
                            Text(dish.name)
                            Spacer()
                            Button(action: {
                                editingDish = dish
                            }) {  // swiftlint:disable:this multiple_closures_with_trailing_closure
                                Image(systemName: "pencil")
                            }
                        }
                    }
                    Button("Add New Dish") {
                        showingAddDishSheet.toggle()
                    }
                }

                Button("Save") {
                    let updatedMenu = Menu(
                        userId: menu.userId,
                        name: name,
                        description: description,
                        costPerPerson: costPerPerson,
                        dishes: dishes,
                        id: menu.id
                    )
                    menuViewModel.updateMenu(updatedMenu)
                    onSave(updatedMenu)
                    dismiss()
                    menuViewModel.fetchMenus()
                }
            }
            .navigationTitle("Edit Menu")
            .sheet(item: $editingDish) { dish in
                EditDishView(dish: dish, menuId: menu.id ?? "") { updatedDish in
                    if let index = dishes.firstIndex(where: { $0.id == updatedDish.id }) {
                        dishes[index] = updatedDish
                    }
                    editingDish = nil
                }
            }
            .sheet(isPresented: $showingAddDishSheet) {
                AddDishView(dishes: $dishes, viewModel: MenuViewModel())
            }
        }
        .onAppear {
            menuViewModel.fetchMenus()
        }
    }
}

struct EditMenuView_Previews: PreviewProvider {
    static var previews: some View {
        EditMenuView(menu: Menu(
            userId: "Pablo",
            name: "Sample Menu",
            description: "Sample Menu Description",
            costPerPerson: 20.0,
            dishes: [
                Dish(id: UUID(), name: "Entry 1", description: "Entry Description", servings: 4, ingredients: []),
                Dish(id: UUID(), name: "Main 1", description: "Main Description", servings: 4, ingredients: []),
                Dish(id: UUID(), name: "Dessert 1", description: "Dessert Description", servings: 4, ingredients: [])
            ]
        )) { _ in }
        .environmentObject(MenuViewModel())
    }
}
