//
//  AddMenuView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import SwiftUI
import FirebaseAuth

struct AddMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MenuViewModel
    @State private var entries: [Dish] = []
    @State private var mains: [Dish] = []
    @State private var desserts: [Dish] = []
    @State private var showingAddDishSheet = false
    @State private var dishType: DishType = .entry
    @State private var showEmptyFieldAlert = false

    @State private var isMenuNameEmpty = false
    @State private var isMenuDescriptionEmpty = false
    @State private var isCostPerPersonInvalid = false

    var body: some View {
        NavigationStack {
            Form {
                menuDetailsSection
                dishesSection(title: "Entries", dishes: $entries, dishType: .entry)
                dishesSection(title: "Mains", dishes: $mains, dishType: .main)
                dishesSection(title: "Desserts", dishes: $desserts, dishType: .dessert)
            }
            .navigationTitle("Add New Menu")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        isMenuNameEmpty = viewModel.menuName.isEmpty
                        isMenuDescriptionEmpty = viewModel.menuDescription.isEmpty
                        isCostPerPersonInvalid = viewModel.costPerPerson <= 0

                        if isMenuNameEmpty || isMenuDescriptionEmpty || isCostPerPersonInvalid {
                            showEmptyFieldAlert.toggle()
                        } else {
                            let newMenu = Menu(
                                userId: Auth.auth().currentUser?.uid ?? "",
                                name: viewModel.menuName,
                                description: viewModel.menuDescription,
                                costPerPerson: viewModel.costPerPerson,
                                dishes: entries + mains + desserts
                            )
                            viewModel.createMenu(newMenu: newMenu)
                            dismiss()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddDishSheet) {
                AddDishView(dishes: bindingForCurrentDishType(), viewModel: MenuViewModel())
            }
            .alert("Error", isPresented: $showEmptyFieldAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("All fields are required and cost per person must be greater than 0.")
            }
        }
    }
    private var menuDetailsSection: some View {
        Section(header: Text("Menu Details")) {
            TextField("Menu Name", text: $viewModel.menuName)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 5).stroke(isMenuNameEmpty ? Color.red : Color.clear, lineWidth: 1))
            TextField("Menu Description", text: $viewModel.menuDescription)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 5).stroke(isMenuDescriptionEmpty ? Color.red : Color.clear, lineWidth: 1))
            TextField("Cost per Person", value: $viewModel.costPerPerson, formatter: NumberFormatter())
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 5).stroke(isCostPerPersonInvalid ? Color.red : Color.clear, lineWidth: 1))
        }
    }

    private func dishesSection(title: String, dishes: Binding<[Dish]>, dishType: DishType) -> some View {
        Section(header: Text(title)) {
            ForEach(dishes.wrappedValue) { dish in
                Text(dish.name)
            }
            Button(action: {
                self.dishType = dishType
                showingAddDishSheet.toggle()
            }) { // swiftlint:disable:this superfluous_disable_command multiple_closures_with_trailing_closure
                Text("Add \(title)")
            }
        }
    }

    private func bindingForCurrentDishType() -> Binding<[Dish]> {
        switch dishType {
        case .entry:
            return $entries
        case .main:
            return $mains
        case .dessert:
            return $desserts
        }
    }
}

enum DishType {
    case entry, main, dessert
}

struct AddMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuView(viewModel: MenuViewModel())
    }
}
