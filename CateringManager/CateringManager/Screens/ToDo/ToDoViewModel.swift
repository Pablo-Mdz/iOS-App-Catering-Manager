//
//  ToDoViewModel.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ToDoListViewModel: ObservableObject {
    @Published var todoItems: [ToDoItem] = []
    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    private var listener: ListenerRegistration?
    func createNewToDoItem(title: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        let newFireToDoItem = ToDoItem(title: title, isCompleted: false, userId: userId)
        do {
            try self.firebaseFirestore.collection("todos").addDocument(from: newFireToDoItem)
        } catch {
            print(error)
        }
    }
    func createNewToDoItems(titles: [String]) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        for title in titles {
            let newFireToDoItem = ToDoItem(title: title, isCompleted: false, userId: userId)
            do {
                try self.firebaseFirestore.collection("todos").addDocument(from: newFireToDoItem)
            } catch {
                print(error)
            }
        }
    }
    func fetchToDoItems() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        self.listener = self.firebaseFirestore.collection("todos")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Fehler beim Laden der Todos: \(error)")
                    return
                }
                guard let snapshot else {
                    print("Snapshot ist leer")
                    return
                }
                let todoItems = snapshot.documents.compactMap { document -> ToDoItem? in
                    do {
                        return try document.data(as: ToDoItem.self)
                    } catch {
                        print(error)
                    }
                    return nil
                }
                self.todoItems = todoItems
            }
    }
    func updateToDoItem(withId id: String?, isCompleted: Bool) {
        guard let id else {
            print("Item hat keine id!")
            return
        }
        let fieldsToUpdate = [
            "isCompleted": isCompleted
        ]
        firebaseFirestore.collection("todos").document(id).updateData(fieldsToUpdate) { error in
            if let error {
                print("Update fehlgeschlagen: \(error)")
            }
        }
    }
    func updateToDoItemTitle(withId id: String?, title: String) {
        guard let id else {
            print("Item has no id!")
            return
        }
        let fieldsToUpdate = [
            "title": title
        ]
        firebaseFirestore.collection("todos").document(id).updateData(fieldsToUpdate) { error in
            if let error {
                print("Update title failed: \(error)")
            }
        }
    }
    func deleteToDoItem(withId id: String?) {
        guard let id else {
            print("Item hat keine id!")
            return
        }
        firebaseFirestore.collection("todos").document(id).delete { error in
            if let error {
                print("Löschen fehlgeschlagen: \(error)")
            }
        }
    }
    func clearToDoList() {
        guard let userId = firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        firebaseFirestore.collection("todos").whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching todos: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully deleted")
                    }
                }
            }
            self.todoItems.removeAll()
        }
    }
}
