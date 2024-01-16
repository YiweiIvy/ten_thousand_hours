//
//  CategoryModel.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 1/11/24.
//
import Foundation
import RealmSwift

// Separate Model class for handling database operations
class CategoryModel {
    
    // Fetch categories for a given user ID
    func fetchCategoriesForUserID(_ userID: String) async -> Result<[Category], Error> {
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let usersCollection = database.collection(withName: "users")
        let categoriesCollection = database.collection(withName: "category")

        do {
            // Fetch the user document to get category IDs
            let userDocument = try await usersCollection.findOneDocument(filter: ["_id": AnyBSON(userID)])
            guard let categoryIds = userDocument?["categories"]??.arrayValue?.compactMap({ $0?.stringValue }) else {
                return .failure(NSError(domain: "UserCategoriesError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No categories found for user"]))
            }

            // Now fetch categories based on those IDs
            let query: [String: AnyBSON] = ["id": ["$in": AnyBSON.array(categoryIds.map(AnyBSON.string))]]
            let categoryDocuments = try await categoriesCollection.find(filter: query)

            // Convert documents to Category objects
            let categories = categoryDocuments.map { doc in
                Category(
                    id: doc["id"]??.stringValue ?? "",
                    emoji: doc["emoji"]??.stringValue ?? "",
                    name: doc["name"]??.stringValue ?? "",
                    targetTime: doc["targetTime"]??.doubleValue ?? 100000,
                    completedTime: doc["completedTime"]??.doubleValue ?? 0,
                    tasks: doc["tasks"]??.arrayValue?.compactMap { $0?.stringValue } ?? []
                )
            }
            return .success(categories)
        } catch {
            return .failure(error)
        }
    }

    // Add a new category for a specific user
    func addCategory(_ category: Category, toUserID userID: String) async -> Result<Void, Error> {
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let categoriesCollection = database.collection(withName: "category")
        let usersCollection = database.collection(withName: "users")

        do {
            // Add the category document
            let categoryDocument: [String: AnyBSON] = [
                "id": .string(category.id),
                "emoji": .string(category.emoji),
                "name": .string(category.name),
                "targetTime": .double(category.targetTime),
                "completedTime": .double(category.completedTime),
                "tasks":[]
            ]
            _ = try await categoriesCollection.insertOne(categoryDocument)

            // Update the user's categories
            let result = try await usersCollection.updateOneDocument(
                filter: ["_id": AnyBSON(userID)],
                update: ["$addToSet": ["categories": AnyBSON(category.id)]]
            )

            guard result.matchedCount > 0 else {
                throw NSError(domain: "UpdateUserError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User update failed"])
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
