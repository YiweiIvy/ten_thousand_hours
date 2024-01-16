//
//  LoginModel.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/30/23.
//

import SwiftUI

struct User {
    var id: String
    var email: String
    var username: String
    var level: String
    var categories: [String]
}

struct Category: Identifiable {
    var id: String
    var emoji: String
    var name: String
    var targetTime: TimeInterval = 10000  // Default value set to 10000
    var completedTime: TimeInterval = 0
    var tasks: [String]
}

struct TaskItem: Identifiable, Hashable {
    var id: String
    var name: String
    var targetTime: TimeInterval  // Target time for this goal card
    var completedTime: TimeInterval  // Time already completed for this goal card
}

class UserSession: ObservableObject {
    @Published var currentUser: User?
}

extension TaskCard {
    init(taskItem: TaskItem) {
        self.title = taskItem.name
        self.iconName = "💡"
        self.progress = Float(taskItem.completedTime / taskItem.targetTime)
        self.goalText = "Goal: \(taskItem.targetTime)h" // Customize as needed
        self.color = "MyBlue" // Replace with actual color logic
    }
}
