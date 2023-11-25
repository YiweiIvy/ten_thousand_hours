//
//  SecondPage.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 11/24/23.
//

import SwiftUI

struct Bside: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    GoalProgressView(title: "Tech", progress: 0.5, goalText: "Goal: 10,000h")
                    ProgressGridView(items: [
                        ProgressItem(title: "Python", color: .green, progress: 0.6),
                        ProgressItem(title: "Java", color: .blue, progress: 0.6),
                        ProgressItem(title: "Security", color: .blue, progress: 0.6, hours: 15),
                        ProgressItem(title: "CPU", color: .green, progress: 0.6),
                        ProgressItem(title: "OS", color: .orange, progress: 0.6),
                        ProgressItem(title: "Frontend", color: .blue, progress: 0.6)
                    ])
                }
                .navigationBarTitle("Progress Tracker", displayMode: .inline)
            }
        }
    }
}

struct GoalProgressView: View {
    var title: String
    var progress: Float
    var goalText: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            ProgressView(value: progress)
            Text(goalText)
            Button("Continue") {
                // Actions to continue
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white)) // Background color for the box
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)) // Border color and width for the box
        .padding([.horizontal, .top])
    }
}

struct ProgressGridView: View {
    var items: [ProgressItem]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(items, id: \.title) { item in
                ProgressCell(item: item)
            }
        }
    }
}

struct ProgressItem {
    var title: String
    var color: Color
    var progress: Float
    var hours: Int? = nil
}

struct ProgressCell: View {
    var item: ProgressItem
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.headline)
            if let hours = item.hours {
                Text("\(hours)h")
                    .font(.caption)
            } else {
                ProgressView(value: item.progress)
                    .tint(item.color)
            }
        }
        .padding()
    }
}

struct Bside_Previews: PreviewProvider {
    static var previews: some View {
        Bside()
    }
}
