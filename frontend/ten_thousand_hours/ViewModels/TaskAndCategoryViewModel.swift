//
//  TaskAndCategoryViewModel.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/31/23.
//

import Foundation
import RealmSwift
import Combine

// Updated ViewModel
class CategoryViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var userCategories: [Category] = []
    
    private var model: CategoryModel
    
    init(model: CategoryModel) {
        self.model = model
        fetchCategoriesForCurrentUser()
    }
    
    func fetchCategoriesForCurrentUser() {
        guard let currentUserID = realmApp.currentUser?.id else {
            print("No current user")
            return
        }
        
        Task {
            let result = await model.fetchCategoriesForUserID(currentUserID)
            switch result {
            case .success(let categories):
                self.userCategories = categories
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func addCategory(_ category: Category) async {
        guard let currentUserID = realmApp.currentUser?.id else {
            print("No current user")
            return
        }
        
        let result = await model.addCategory(category, toUserID: currentUserID)
        switch result {
        case .success():
            fetchCategoriesForCurrentUser()
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}


class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var isLoading = false
    let tasksUpdated = PassthroughSubject<Void, Never>()
    
    func fetchTasks(withIds taskIds: [String]) async {
        isLoading = true
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let tasksCollection = database.collection(withName: "task")
        
        let query: [String: AnyBSON] = ["id": ["$in": AnyBSON.array(taskIds.map(AnyBSON.string))]]
        
        do {
            let taskDocuments = try await tasksCollection.find(filter: query)
            self.tasks = taskDocuments.map { doc in
                TaskItem(
                    id: doc["id"]??.stringValue ?? "",
                    name: doc["name"]??.stringValue ?? "",
                    targetTime: doc["targetTime"]??.doubleValue ?? 0,
                    completedTime: doc["completedTime"]??.doubleValue ?? 0
                )
            }
            isLoading = false
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func addTask(_ task: TaskItem, toCategoryId categoryId: String) async {
        let mongoClient = realmApp.currentUser!.mongoClient("mongodb-atlas")
        let database = mongoClient.database(named: "10000H")
        let tasksCollection = database.collection(withName: "task")
        
        // Create a task document
        let categoriesCollection = database.collection(withName: "category")
        let taskDocument: [String: AnyBSON] = [
            "id": .string(task.id),
            "name": .string(task.name),
            "targetTime": .double(task.targetTime),
            "completedTime": .double(task.completedTime)
        ]
        
        do {
            isLoading = true
            // Insert the task into the 'task' collection
            _ = try await tasksCollection.insertOne(taskDocument)
            
            // Update the category document to include the task's ID
            let updateResult = try await categoriesCollection.updateOneDocument(
                filter: ["id": AnyBSON(categoryId)],
                update: ["$addToSet": ["tasks": AnyBSON(task.id)]]
            )
            print("Updated category with new task, matched count: \(updateResult.matchedCount), modified count: \(updateResult.modifiedCount)")
            tasksUpdated.send()
            self.isLoading = false
        } catch {
            self.isLoading = false
            print("Error adding task or updating category: \(error.localizedDescription)")
        }
    }
    
    func fetchTasksIfNeeded(for category: Category) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            await fetchTasks(withIds: category.tasks)
        }
        self.isLoading = false
    }
}
