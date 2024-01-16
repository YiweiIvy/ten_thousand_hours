//
//  TimingPage.swift
//  ten_thousand_hours
//
//  Created by Justin Bai on 1/8/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct TimerPageView: View {
    @State private var timeElapsed = 0 // Starts at 0 seconds
    @State private var timerRunning = false
    var task: TaskItem
    @ObservedObject var taskViewModel: TaskViewModel

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 40) {
            // Task name and icon
            HStack {
                Image(systemName: "list.bullet")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Text(task.name)
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.blue.opacity(0.3)))
            .foregroundColor(Color.blue)
            
            // Inspirational quote
            Text("“A little progress each day adds up to big results”")
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            // Timer display
            Text(formatTime(timeElapsed))
                .font(.system(size: 64, weight: .bold, design: .default))
                .foregroundColor(.primary)
                .onReceive(timer) { _ in
                    if self.timerRunning {
                        self.timeElapsed += 1
                        print(self.timeElapsed)
                    }
                }
            
            // Control buttons
            HStack(spacing: 30) {
                Button(action: { self.resetTimer() }) {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .shadow(radius: 10)
                }
                
                Button(action: { self.startTimer() }) {
                    Image(systemName: "play.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .shadow(radius: 10)
                }
            }
            
            // Pause button
            Button(action: { self.pauseTimer() }) {
                Image(systemName: "pause.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().fill(Color.blue))
                    .shadow(radius: 10)
            }
        }
        .padding()
    }
    
    func startTimer() {
        timerRunning = true
    }

    func pauseTimer() {
        timerRunning = false
    }
    
    func resetTimer() {
        // Call update functions before resetting timeElapsed
        pauseTimer()
        Task {
            print("before update:\(self.timeElapsed)")
            let timeToUpdate = self.timeElapsed
            let timeToUpdateInHours = Double(timeToUpdate) / 3600.0 // Convert to Double
            print("before update:\(timeToUpdateInHours)")
            await taskViewModel.updateCompletedTimeForTask(taskId: self.task.id, additionalTime: TimeInterval(timeToUpdateInHours))
            await taskViewModel.updateCompletedTimeForCategory(additionalTime: TimeInterval(timeToUpdateInHours))

            // Reset timeElapsed after the above await functions are completed
            DispatchQueue.main.async {
                self.timeElapsed = 0
                print("after update:\(self.timeElapsed)")
            }
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        // Modify the format if you also want to show hours after a certain period
        return (hours > 0 ? String(format: "%02d:", hours) : "") + String(format: "%02d:%02d", minutes, seconds)
    }
}
