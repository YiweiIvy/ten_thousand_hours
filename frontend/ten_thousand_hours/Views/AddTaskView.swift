//
//  AddTaskView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 1/10/24.
//

import SwiftUI

struct AddTaskView: View {
    @State private var name: String = ""
    @State private var targetTime: TimeInterval = 100000
    @State private var categoryId: String
    @EnvironmentObject var userSession: UserSession
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskViewModel: TaskViewModel
    var onDismiss: () -> Void
    
    init(categoryId: String, taskViewModel: TaskViewModel, onDismiss: @escaping () -> Void) {
        self._categoryId = State(initialValue: categoryId)
        self.taskViewModel = taskViewModel
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack {
            TextField("Task Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Target Time", value: $targetTime, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Task") {
                    let newTask = TaskItem(id: UUID().uuidString, name: name, targetTime: targetTime, completedTime: 0)
                    Task {
                        await taskViewModel.addTask(newTask, toCategoryId: categoryId)
                        DispatchQueue.main.async {
                            self.presentationMode.wrappedValue.dismiss()
                            self.onDismiss() // Notify on dismissal
                        }
                    }
                }
        }
        .padding()
    }
}
