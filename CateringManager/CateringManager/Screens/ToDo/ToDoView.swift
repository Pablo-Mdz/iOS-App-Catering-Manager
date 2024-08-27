//
//  ToDoView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import SwiftUI

struct ToDoView: View {
    @StateObject private var todoListViewModel = ToDoListViewModel()
    @EnvironmentObject private var loginViewModel: UserViewModel
    @State private var showNewToDoItem = false
    @State private var showEditToDoItem = false
    @State private var newToDoItemTitle = ""
    @State private var editingToDoItemId: String?
    @State private var showEmptyFieldAlert = false
    @State private var showClearListConfirmation = false

    var body: some View {
        NavigationStack {
            VStack {
                List(todoListViewModel.todoItems) { item in
                    HStack {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                todoListViewModel.updateToDoItem(withId: item.id, isCompleted: !item.isCompleted)
                            }
                        Text(item.title)
                            .strikethrough(item.isCompleted, color: .gray)
                            .foregroundColor(item.isCompleted ? .gray : .primary)
                        Spacer()
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", role: .destructive) {
                            todoListViewModel.deleteToDoItem(withId: item.id)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button("Edit") {
                            editingToDoItemId = item.id
                            newToDoItemTitle = item.title
                            showEditToDoItem.toggle()
                        }
                        .tint(.blue)
                    }
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    todoListViewModel.fetchToDoItems()
                }
                Button(action: {
                    showClearListConfirmation = true
                }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                    Text("Clear List")
                        .padding(.leading)
                        .foregroundStyle(Color(.red))
                }
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewToDoItem.toggle()
                    }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Task", isPresented: $showNewToDoItem) {
                TextField("Task", text: $newToDoItemTitle)
                Button("Cancel", role: .cancel) {
                    showNewToDoItem.toggle()
                    newToDoItemTitle = ""
                }
                Button("Save") {
                    if newToDoItemTitle.isEmpty {
                        showEmptyFieldAlert.toggle()
                    } else {
                        todoListViewModel.createNewToDoItem(title: newToDoItemTitle)
                        showNewToDoItem.toggle()
                        newToDoItemTitle = ""
                    }
                }
            } message: {
                Text("Enter the title for the new task")
            }
            .alert("Edit Task", isPresented: $showEditToDoItem) {
                TextField("Title", text: $newToDoItemTitle)
                Button("Cancel", role: .cancel) {
                    showEditToDoItem.toggle()
                    newToDoItemTitle = ""
                }
                Button("Save") {
                    if newToDoItemTitle.isEmpty {
                        showEmptyFieldAlert.toggle()
                    } else {
                        if let id = editingToDoItemId {
                            todoListViewModel.updateToDoItemTitle(withId: id, title: newToDoItemTitle)
                        }
                        showEditToDoItem.toggle()
                        newToDoItemTitle = ""
                    }
                }
            } message: {
                Text("Enter the new title for the task")
            }
            .alert("Error", isPresented: $showEmptyFieldAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("You can not save empty tasks.")
            }
            .alert("Are you sure you want to clear the entire list?", isPresented: $showClearListConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    todoListViewModel.clearToDoList()
                }
            }
            .navigationTitle("\(loginViewModel.user?.username ?? "Unknown")'s ToDos")
            .background(CostumColors.primaryColor.opacity(0.1))
        }
    }
}

#Preview {
    ToDoView()
        .environmentObject(UserViewModel())
        .environmentObject(ToDoListViewModel())
}
