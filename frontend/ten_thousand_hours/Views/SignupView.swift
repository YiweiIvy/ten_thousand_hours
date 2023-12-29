//
//  SignupView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/29/23.
//

import SwiftUI
import RealmSwift

struct SignupView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Sign Up") {
                signup()
            }
            .padding()
        }
        .padding()
    }

    private func signup() {
        realmApp.emailPasswordAuth.registerUser(email: email, password: password) { [self] (error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Signup failed: \(error.localizedDescription)"
                } else {
                    // User successfully registered, now log them in
                    loginAfterSignup(email: email, password: password)
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

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
