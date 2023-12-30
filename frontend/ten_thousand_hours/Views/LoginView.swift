//
//  LoginView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/29/23.
//
import SwiftUI
import RealmSwift

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @Binding var username: String
    @Binding var level: String
    @Environment(\.dismiss) var dismiss
    @State private var showingSignup = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoggingIn {
                    Text("Logging in...")
                } else {
                    loginForm
                    signupButton
                }
            }
            .navigationDestination(isPresented: $showingSignup) {
                SignupView() // Define this view
            }
            .onAppear {
                viewModel.onDismiss = {
                    username = viewModel.username
                    level = viewModel.level
                    dismiss()
                }
            }
        }
    }
    
    private var loginForm: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }

            Button("Login") {
                Task {
                    await viewModel.login()
                }
            }
            .padding()
        }
        .padding()
    }
    
    private var signupButton: some View {
        Button("Sign Up") {
            showingSignup = true
        }
        .padding()
    }
}
