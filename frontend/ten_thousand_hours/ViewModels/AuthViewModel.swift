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
    var userSession: UserSession?
    
    func login() async {
        isLoggingIn = true
        defer { isLoggingIn = false }
        
        do {
            let realmUser = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
            let appUser = User(id: realmUser.id, email: email, username: username, level: level, categories: [])
            await fetchAndSetUsername(userId: realmUser.id)
            DispatchQueue.main.async {
                self.userSession?.currentUser = appUser
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
    @EnvironmentObject var userSession: UserSession
    
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
                    self.storeUserData(userId: user.id, username: self.username, level: "Beginner")
                }
            }
        }
    }
    
    private func getDefaultCategories() -> [Category] {
        return [
            Category(id: UUID().uuidString, emoji: "⚽️", name: "Sport", targetTime: 3600, completedTime: 0, tasks: []),
            Category(id: UUID().uuidString, emoji: "📚", name: "Study", targetTime: 3600, completedTime: 0, tasks: []),
            Category(id: UUID().uuidString, emoji: "🎸", name: "Music", targetTime: 3600, completedTime: 0, tasks: []),
            Category(id: UUID().uuidString, emoji: "🎨", name: "Art", targetTime: 3600, completedTime: 0, tasks: [])
        ]
    }
    
    func storeUserData(userId: String, username: String, level: String) {
        let user = realmApp.currentUser!
        let mongoClient = user.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let usersCollection = database.collection(withName: "users")
        let categoriesCollection = database.collection(withName: "category")
        

        let defaultCategories = getDefaultCategories()

        // Store default categories in the database
        let viewModel = CategoryViewModel()
        for category in defaultCategories {
            Task {
                do {
                    let currUser = User(id: user.id, email: email, username: username, level: level, categories: [])
                    try await viewModel.addCategory(category, to: currUser)
                    print("Category \(category.name) inserted successfully")
                }
            }
        }

        // Update user document with default category IDs
        let updateData: [String: AnyBSON] = [
            "username": .string(username),
            "level": .string(level),
            "categories": .array(defaultCategories.map { AnyBSON($0.id) })
        ]

        usersCollection.updateOneDocument(
            filter: ["_id": AnyBSON(stringLiteral: userId)],
            update: ["$set": AnyBSON(updateData)],
            upsert: true
        ) { result in
            switch result {
            case .failure(let error):
                print("Failed to update user data: \(error.localizedDescription)")
            case .success(_):
                print("User data updated successfully")
            }
        }
    }
}
