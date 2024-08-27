//
//  LoginRepository.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 01/07/2024.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit
import FirebaseStorage
class UserViewModel: ObservableObject {
    private let firebaseAuthentication = Auth.auth()
    private let firestore = Firestore.firestore()
    @Published private(set) var user: FireUser?
    @Published var isLogged: Bool = false
    @Published private(set) var passwordError: String?
    @Published var loginError: String?
    var isUserLoggedIn: Bool {
        self.user != nil
    }
    init() {
        if let currentUser = self.firebaseAuthentication.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
        }
    }
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            self.loginError = "Email and Password cannot be empty."
            return
        }
        firebaseAuthentication.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.loginError = "Error in login: \(error.localizedDescription)"
                print("Error in login: \(error)")
                return
            }
            guard let authResult = authResult, let userEmail = authResult.user.email else {
                self.loginError = "AuthResult or Email are empty"
                print("AuthResult or Email are empty")
                return
            }
            print("Successfully signed in with user-Id \(authResult.user.uid) and email \(userEmail)")
            self.isLogged = true
            self.fetchFirestoreUser(withId: authResult.user.uid)
        }
    }
    func signIn(email: String, password: String, username: String, passwordCheck: String) {
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else {
            self.passwordError = "All fields must be filled."
            return
        }
        guard password == passwordCheck else {
            self.passwordError = "Passwords do not match."
            return
        }
        firebaseAuthentication.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.passwordError = "Error in registration: \(error.localizedDescription)"
                print("Error in registration: \(error)")
                return
            }
            guard let authResult = authResult else {
                self.passwordError = "AuthResult or Email are empty"
                print("AuthResult or Email are empty")
                return
            }
            self.createFireUser(withId: authResult.user.uid, email: email, username: username)
            self.fetchFirestoreUser(withId: authResult.user.uid)
            self.isLogged = true
        }
    }
    func createFireUser(withId id: String, email: String, username: String) {
        let newUser = FireUser(id: id, email: email, username: username, registeredAt: Date())
        do {
            try firestore.collection("users").document(id).setData(from: newUser)
        } catch {
            print("Saving user failed: \(error)")
        }
    }
    private func fetchFirestoreUser(withId id: String) {
        firestore.collection("users").document(id).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }
            guard let document = document else {
                print("Document does not exist")
                return
            }
            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }

    func logout() {
        do {
            try firebaseAuthentication.signOut()
            self.user = nil
        } catch {
            print("Error in logout: \(error)")
        }
    }

    // to make public the user
    func setUser(_ user: FireUser) {
        self.user = user
    }

    //  user image
    func uploadProfileImage(image: UIImage) {
        guard let userId = user?.id else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        print("Uploading image for userId: \(userId)")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Error uploading image: \(String(describing: error))")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(String(describing: error))")
                    return
                }
                print("Image uploaded successfully. Download URL: \(downloadURL)")
                self.updateProfileImageUrl(url: downloadURL.absoluteString)
            }
        }
    }

    func updateProfileImageUrl(url: String) {
        guard let userId = user?.id else { return }
        firestore.collection("users").document(userId).updateData([
            "profileImageUrl": url
        ]) { error in
            if let error = error {
                print("Error updating profile image URL: \(error)")
            } else {
                self.user?.profileImageUrl = url
            }
        }
    }
}
