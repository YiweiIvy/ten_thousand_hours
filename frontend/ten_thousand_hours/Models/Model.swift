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
    var targetTime: TimeInterval = 100000  // Default value set to 100000
    var completedTime: TimeInterval = 0
    var goalCards: [String]
}

struct GoalCard {
    var targetTime: TimeInterval  // Target time for this goal card
    var completedTime: TimeInterval  // Time already completed for this goal card
}

class UserSession: ObservableObject {
    @Published var currentUser: User?
}
