//
//  SignupView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/29/23.
//

import SwiftUI
import RealmSwift

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel() // Instantiate ViewModel
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username) // Bind to ViewModel
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $viewModel.email) // Bind to ViewModel
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $viewModel.password) // Bind to ViewModel
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage) // Use ViewModel's errorMessage
                    .foregroundColor(.red)
            }

            Button("Sign Up") {
                Task {
                    viewModel.signup()// Call signup on ViewModel
                    viewModel.onDismiss = {
                        dismiss()
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}
