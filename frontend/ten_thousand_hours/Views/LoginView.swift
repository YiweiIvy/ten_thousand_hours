//
//  LoginView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/29/23.
//
import SwiftUI
import RealmSwift

struct LoginView: View {
    @Binding var username: String
    @Binding var level: String
    @Environment(\.dismiss) var dismiss
    @State private var isLoggingIn = false
    @State private var showingSignup = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoggingIn {
                    Text("Logging in...")
                } else {
                    VStack {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .padding()
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                        
                        Button("Login") {
                            Task {
                                await login()
                            }
                        }
                        .padding()
                    }
                    .padding()
                    
                    Button("Sign Up") {
                        showingSignup = true
                    }
                }
            }
            .navigationDestination(isPresented: $showingSignup) {
                SignupView() // Make sure you have this view defined
            }
        }
    }
    
    private func login() async {
        isLoggingIn = true
        defer { isLoggingIn = false } // This ensures that isLoggingIn is set to false when the function exits
        
        do {
            let user = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
            await fetchAndSetUsername(userId: user.id)
            DispatchQueue.main.async { // Switch to the main thread to update the UI
                dismiss()
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }

    private func fetchAndSetUsername(userId: String) async {
        let user = realmApp.currentUser!
        let mongoClient = user.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let collection = database.collection(withName: "users")

        do {
            let result = try await collection.findOneDocument(filter: ["_id": AnyBSON(userId)])
            if let result = result, let username = result["username"]??.stringValue, let level = result["level"]??.stringValue{
                DispatchQueue.main.async {
                    self.username = username
                    self.level = level
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch user data: \(error.localizedDescription)"
            }
        }
    }

}


