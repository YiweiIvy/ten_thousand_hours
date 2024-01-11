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
    @State private var targetTime: TimeInterval = 10000
    @EnvironmentObject var userSession: UserSession
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var categoryViewModel: CategoryViewModel

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
                Task {
                    let newCategory = Category(
                        id: UUID().uuidString,
                        emoji: emoji,
                        name: name,
                        targetTime: targetTime,
                        tasks: []
                    )
                    await categoryViewModel.addCategory(newCategory)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .padding()
    }
}

