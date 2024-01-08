//
//  TimingPage.swift
//  ten_thousand_hours
//
//  Created by Justin Bai on 1/8/24.
//

import Foundation
import SwiftUI

struct TimerApp: View {
    var body: some View {
        VStack(spacing: 40) {
            // Task name and icon
            HStack {
                Image(systemName: "list.bullet")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Text("Task Name")
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
            Text("14:59")
                .font(.system(size: 64, weight: .bold, design: .default))
                .foregroundColor(.primary)
            
            // Control buttons
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .shadow(radius: 10)
                }
                
                Button(action: {}) {
                    Image(systemName: "play.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .shadow(radius: 10)
                }
            }
            
            // Pause button
            Button(action: {}) {
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
}

struct TimerApp_Previews: PreviewProvider {
    static var previews: some View {
        TimerApp()
    }
}
