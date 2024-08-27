//
//  MenuView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @EnvironmentObject var loginViewModel: UserViewModel
    // Edit
    @State private var showNewMenuItem = false
    @State private var showingAddMenuSheet = false
    @State private var showEditMenuItem = false
    @State private var newMenuTitle = ""
    @State private var editingMenuId: String?
    // Delete
    @State private var selectedMenu: Menu?
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
                VStack {
                    List(viewModel.menus) { menu in
                        NavigationLink(destination: MenuDetailView(menuViewModel: viewModel, menuId: menu.id ?? "")) {
                            Text(menu.name).bold()
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                selectedMenu = menu
                                showDeleteConfirmation.toggle()
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                editingMenuId = menu.id
                                newMenuTitle = menu.name
                                showEditMenuItem.toggle()
                            }
                            .tint(.blue)
                        }
                    }
                    .padding(20)
                    .listStyle(PlainListStyle())
                    .background(CostumColors.primaryColor.opacity(0.1)) // Background for the List
                    .navigationTitle("\(loginViewModel.user?.username ?? "User")'s Menus")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showingAddMenuSheet.toggle()
                            }
                            ){ // swiftlint:disable:this multiple_closures_with_trailing_closure opening_brace
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddMenuSheet) {
                        AddMenuView(viewModel: viewModel)
                    }
                    .alert("Are you sure you want to delete this menu?", isPresented: $showDeleteConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            if let id = selectedMenu?.id {
                                viewModel.deleteMenu(withId: id)
                            }
                        }
                    } message: {
                        Text("This action cannot be undone.")
                    }
                    .alert("Edit Menu Name", isPresented: $showEditMenuItem) {
                        TextField("Title", text: $newMenuTitle)

                        Button("Cancel", role: .cancel) {
                            showEditMenuItem.toggle()
                            newMenuTitle = ""
                        }
                        Button("Save") {
                            if let id = editingMenuId {
                                viewModel.updateMenuTitle(withId: id, name: newMenuTitle)
                            }
                            showEditMenuItem.toggle()
                            newMenuTitle = ""
                        }
                    } message: {
                        Text("Enter the new title for the task")
                    }
                    .onAppear {
                        viewModel.fetchMenus()
                    }
                }
            }
        }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        userViewModel.setUser(FireUser(id: "34534543", email: "pablo@cigoy.com", username: "Pablo", registeredAt: Date()))

        return MenuView()
            .environmentObject(userViewModel)
    }
}
