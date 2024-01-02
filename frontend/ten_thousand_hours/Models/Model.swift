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
    let id : String
    let emoji: String
    let name: String
    let destination: AnyView
    var targetTime: TimeInterval = 100000  // Default value set to 100000
    var completedTime: TimeInterval = 0
    var goalCards: [GoalCard] = []
}

struct GoalCard {
    var targetTime: TimeInterval  // Target time for this goal card
    var completedTime: TimeInterval  // Time already completed for this goal card
}

extension Category {
    static func defaultCategories() -> [Category] {
        // Return a list of default categories
        // For example:
        return [
            Category(id: "1", emoji: "⚽️", name: "Sport", destination: AnyView(Text("Sport View")), targetTime: 3600, completedTime: 0, goalCards: []),
            Category(id: "2", emoji: "📚", name: "Study", destination: AnyView(Text("Study View")), targetTime: 3600, completedTime: 0, goalCards: []),
            Category(id: "3", emoji: "🎸", name: "Music", destination: AnyView(Text("Music View")), targetTime: 3600, completedTime: 0, goalCards: []),
            Category(id: "4", emoji: "🎨", name: "Art", destination: AnyView(Text("Art View")), targetTime: 3600, completedTime: 0, goalCards: []),]
    }
}

class UserSession: ObservableObject {
    @Published var currentUser: User?

    // Include any other user-related properties or methods you need
    // e.g., login, logout, update user data, etc.
}
