//
//  ContentView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 01/07/2024.
//

import SwiftUI

struct ContentView: View {
    // farbe 1684AC
    @StateObject var todoListViewModel = ToDoListViewModel()
    @StateObject var userViewModel = UserViewModel()
    private var notComplete: Int {
        todoListViewModel.todoItems.filter { !$0.isCompleted }.count
    }
    var body: some View {
        TabView {
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "list.bullet.clipboard")
                }
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "menucard")
                }
            ToDoView()
                .tabItem {
                    Label("ToDo", systemImage: "checkmark.circle")
                }
                .badge(notComplete)
                .environmentObject(todoListViewModel)
            ProfilView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
        .accentColor(CostumColors.primaryColor)
        .background(CostumColors.primaryColor.opacity(0.1))
        .onAppear {
            todoListViewModel.fetchToDoItems()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserViewModel())
            .environmentObject(ToDoListViewModel())
    }
}
