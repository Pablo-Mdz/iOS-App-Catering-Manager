//
//  SignInView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import SwiftUI
struct SignInView: View {
    @EnvironmentObject var loginViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @State private var username: String = ""
    @State private var hidePassword: Bool = true
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 20) {
                Image("logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(15)
            VStack(alignment: .leading, spacing: 15) {
                TextField("User Name", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground).opacity(0.7))
                    .cornerRadius(8)
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                HStack {
                    if hidePassword {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    } else {
                        TextField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                SecureField("Confirm passwort ", text: $passwordCheck)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                if let passwordError = loginViewModel.passwordError {
                    Text(passwordError)
                        .foregroundStyle(.red)
                    Button(action: {
                        hidePassword.toggle()
                    }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                        Image(systemName: hidePassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding([.leading, .trailing], 27.5)
            Button(action: {
                loginViewModel.signIn(email: email, password: password, username: username, passwordCheck: passwordCheck)
                presentationMode.wrappedValue.dismiss()
            }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CostumColors.primaryColor)
                    .cornerRadius(10)
                    .padding([.leading, .trailing], 27.5)
            }
            HStack {
                Text("Already have an account??")
                    .font(.footnote)
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    SignInView()
        .environmentObject(UserViewModel())
}
