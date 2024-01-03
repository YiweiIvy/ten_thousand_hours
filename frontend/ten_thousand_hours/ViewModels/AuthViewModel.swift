//
//  LoginViewModel.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/30/23.
//
import SwiftUI
import RealmSwift

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var level: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggingIn: Bool = false
    var onDismiss: (() -> Void)?
    
    func login() async {
        isLoggingIn = true
        defer { isLoggingIn = false } // This ensures that isLoggingIn is set to false when the function exits
        do {
            let user = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
            await fetchAndSetUsername(userId: user.id)
            DispatchQueue.main.async { // Switch to the main thread to update the UI
                self.onDismiss?()
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

class SignupViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    func signup() {
        realmApp.emailPasswordAuth.registerUser(email: email, password: password) { [self] (error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Signup failed: \(error.localizedDescription)"
                } else {
                    // User successfully registered, now log them in
                    self.loginAfterSignup(email: self.email, password: self.password)
                    self.errorMessage = "Signup successful"
                }
            }
        }
    }
    
    private func loginAfterSignup(email: String, password: String) {
        let credentials = Credentials.emailPassword(email: email, password: password)
        realmApp.login(credentials: credentials) { [self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.errorMessage = "Login after signup failed: \(error.localizedDescription)"
                case .success(let user):
                    // User is now logged in, can store additional data
                    self.errorMessage = "Login after signup succeeded"
                    self.storeUserData(userId: user.id, username: self.username, level: "BeginnerCat")
                }
            }
        }
    }
    
    func storeUserData(userId: String, username: String, level: String) {
        let user = realmApp.currentUser!
        let mongoClient = user.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let collection = database.collection(withName: "users")
        
        let updateData: [String: AnyBSON] = [
            "username": .string(username),
            "level": .string(level)
        ]
        
        collection.updateOneDocument(
            filter: ["_id": AnyBSON(stringLiteral: userId)],
            update: ["$set": AnyBSON(updateData)],
            upsert: true
        ) { result in
            switch result {
            case .failure(let error):
                print("Failed to update user data: \(error.localizedDescription)")
            case .success(_):
                self.errorMessage = "Store successful"
            }
        }
    }
}
