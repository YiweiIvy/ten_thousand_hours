//
//  TaskAndCategoryViewModel.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/31/23.
//

import Foundation
import RealmSwift

class CategoryViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var userCategories: [Category] = []
        
        func fetchCategoriesForCurrentUser() {
            if let currentUserID = realmApp.currentUser?.id {
                Task {
                    print("Fetching categories for current user ID: \(currentUserID)")
                    await fetchUserCategories(forUserID: currentUserID)
                }
            } else {
                print("No current user")
            }
        }
    
    func addCategory(_ category: Category, to user: User) async {
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let categoriesCollection = database.collection(withName: "category")
        
        do {
            let categoryDocument: [String: AnyBSON] = [
                "id": .string(category.id),
                    "emoji": .string(category.emoji),
                    "name": .string(category.name),
                    // Add other category fields
                ]
                _ = try await categoriesCollection.insertOne(categoryDocument)
                self.errorMessage = "Added category"
                
                // Update the user's categories
                await updateUserCategories(user, with: category.id)
                self.errorMessage = "Updated user's categories"
            } catch {
                // Handle errors
                self.errorMessage = "Error adding category: \(error.localizedDescription)"
            }
        }

    private func updateUserCategories(_ user: User, with categoryId: String) async {
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let usersCollection = database.collection(withName: "users")
        print("Updating user with ID: \(user.id) to add category ID: \(categoryId)")

        do {
            let result = try await usersCollection.updateOneDocument(
                filter: ["_id": AnyBSON(user.id)],
                update: ["$addToSet": ["categories": AnyBSON(categoryId)]]
            )
            print("Update result: \(result)")
            print("Matched count: \(result.matchedCount), Modified count: \(result.modifiedCount)")
        } catch {
            print("Error updating user categories: \(error.localizedDescription)")
        }
    }

    func fetchUserCategories(forUserID userID: String) async {
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let usersCollection = database.collection(withName: "users")
        let categoriesCollection = database.collection(withName: "category")

        do {
            // Fetch the user document to get category IDs
            let userDocument = try await usersCollection.findOneDocument(filter: ["_id": AnyBSON(userID)])
            guard let categoryIds = userDocument?["categories"]??.arrayValue?.compactMap({ $0?.stringValue }) else {
                print("No categories found for user")
                return
            }

            // Now fetch categories based on those IDs
            let query: [String: AnyBSON] = ["id": ["$in": AnyBSON.array(categoryIds.map(AnyBSON.string))]]
            let categoryDocuments = try await categoriesCollection.find(filter: query)

            // Convert documents to Category objects and update userCategories
            self.userCategories = categoryDocuments.map { doc in
                Category(
                    id: doc["id"]??.stringValue ?? "",
                    emoji: doc["emoji"]??.stringValue ?? "",
                    name: doc["name"]??.stringValue ?? "",
                    targetTime: doc["targetTime"]??.doubleValue ?? 100000,
                    completedTime: doc["completedTime"]??.doubleValue ?? 0,
                    goalCards: doc["goalCards"]??.arrayValue?.compactMap { $0?.stringValue } ?? []
                )
            }
        } catch {
            self.errorMessage = "Error fetching categories: \(error.localizedDescription)"
        }
    }
}
