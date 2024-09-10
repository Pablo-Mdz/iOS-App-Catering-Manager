//
//  ProfilView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 02/07/2024.
//

import SwiftUI

struct ProfilView: View {
    @EnvironmentObject private var loginViewModel: UserViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    var body: some View {
        NavigationView {
            VStack {
                // Profile Image Section
                profileImageSection
                // User Info Section
                userInfoSection
                // Navigation Links Section
                navigationLinksSection
                // Spacer()
                // Logout Button
                logoutButton
            }
            .padding()
        .navigationTitle("Profile")
            .background(CostumColors.primaryColor.opacity(0.1)) // swiftlint:disable:this superfluous_disable_command
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    // Profile Image Section
    private var profileImageSection: some View {
        Group {
            if let imageUrl = loginViewModel.user?.profileImageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
                .onTapGesture {
                    showingImagePicker = true
                }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 120, height: 120)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
                    .onTapGesture {
                        showingImagePicker = true
                    }
            }
        }
    }
    // User Info Section
    private var userInfoSection: some View {
        VStack(spacing: 8) {
            Text("Hello, \(loginViewModel.user?.username ?? "User")!")
                .font(.title)
                .fontWeight(.bold)
            if let email = loginViewModel.user?.email {
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    private var navigationLinksSection: some View {
            VStack {
                List {
                    NavigationLink(destination: ImpressumView()) {
                        Text("Impressum")
                    }
                    NavigationLink(destination: AboutMeView()) {
                        Text("About Me")
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    // Logout Button
    private var logoutButton: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer() // Pushes the text to the left
            }
            .padding(.leading, 20)
            Divider()
                .background(Color.red)
                .padding(.horizontal, 20)
            Button(action: {
                loginViewModel.logout()
            }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    struct SettingsView: View {
        var body: some View {
            Text("Settings")
                .font(.largeTitle)
                .padding()
        }
    }
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        loginViewModel.uploadProfileImage(image: inputImage)
    }
}

#Preview {
    let userViewModel = UserViewModel()
    userViewModel.setUser(FireUser(id: "skldjfsd", email: "pablo@cigoy.com", username: "Pablo", registeredAt: Date()))
    return ProfilView()
        .environmentObject(userViewModel)
}
