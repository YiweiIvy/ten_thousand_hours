//
//  AddCategoryView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 12/31/23.
//

import SwiftUI

struct AddCategoryView: View {
    @State private var emoji: String = ""
    @State private var name: String = ""
    @State private var targetTime: TimeInterval = 100000
    @StateObject var viewModel = CategoryViewModel()
    @FocusState private var isInputActive: Bool
    @EnvironmentObject var userSession: UserSession
    
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
            
            Button("Add Category") {
                if let currentUser = userSession.currentUser {
                    // Your view code that requires currentUser
                    print(currentUser)
                    Task {
                        do {
                            let newCategory = Category(
                                id: UUID().uuidString,
                                emoji: emoji,
                                name: name,
                                destination: AnyView(Text(name)),
                                targetTime: targetTime
                            )
                            try await viewModel.addCategory(newCategory, to: currentUser)
                        } catch {
                            // Handle the error appropriately
                            print("Error adding category: \(error)")
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
    AddCategoryView()
}
