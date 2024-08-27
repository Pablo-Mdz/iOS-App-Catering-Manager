//
//  LoginView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 04/07/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var hidePassword: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(15)
                VStack(alignment: .leading, spacing: 15) {
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
                    loginViewModel.login(email: email, password: password)
                }) { // swiftlint:disable:this multiple_closures_with_trailing_closure
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(CostumColors.primaryColor)
                        .cornerRadius(10)
                        .padding([.leading, .trailing], 27.5)
                }
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                    NavigationLink(destination: SignInView().environmentObject(loginViewModel)) {
                        Text("Register")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
    }

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
