//
//  AddTaskView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 1/10/24.
//

import SwiftUI

struct AddTaskView: View {
    @State private var emoji: String = ""
    @State private var name: String = ""
    @State private var targetTime: TimeInterval = 100000
    @FocusState private var isInputActive: Bool
    @EnvironmentObject var userSession: UserSession
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Icon", text: $emoji)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Target Time", value: $targetTime, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add Task") {
                if let currentUser = userSession.currentUser {
                    // Your view code that requires currentUser
                    print(currentUser)
                    let viewModel = CategoryViewModel()
                    Task {
                        do {
                            let newCategory = Category(
                                id: UUID().uuidString,
                                emoji: emoji,
                                name: name,
                                targetTime: targetTime,
                                tasks: []
                            )
                            try await viewModel.addCategory(newCategory, to: currentUser)
                            // Dismiss the view after adding the category
                            DispatchQueue.main.async {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    
                } else {
                    // Your view code for when currentUser is not available
                    print("no user")
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddTaskView()
}
