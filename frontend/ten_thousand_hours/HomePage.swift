//
//  ContentView.swift
//  ten_thousand_hours
//
//  Created by 余懿炜 on 11/16/23.
//

import SwiftUI

// MARK: - Constants
struct Constants {
    static let backgroundColor: Color = Color(red: 0.97, green: 0.97, blue: 0.99)
    static let textColor: Color = .black
    static let accentColor: Color = .blue // Replace with actual accent color hex code
    static let inactiveTabColor: Color = .gray
}

// MARK: - ContentView
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        HStack(alignment: .center, spacing: 10) {
                            // Profile picture and name setup
                            ProfilePhoto()
                            
                            // User name and Tag
                            NameAndTag()
                            
                            Spacer()
                            
                            // Search button with white/green circle background
                            ProfileButtons()
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 12)
                        .cornerRadius(100)
                        
                        Spacer()
                        
                        // Your other content here
                        Categories()
                        
                        Spacer()
                        
                        TasksView()
                            .padding(.top, 20)
                    }
                }
                .background(Color("HomeBackground"))
                
                Spacer() // This will push all content to the top, but we're removing it to keep the bar fixed at bottom
                
                // Bottom Navigation Bar
                BottomNavigationBar()
            }
        }
    }
}

// MARK: - Profile Photo
struct ProfilePhoto: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 44, height: 44)
            .background(
                Image("ProfilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            )
            .background(Color("LightPurple"))
            .cornerRadius(100)
            .padding(.leading, 18)
            .padding(.trailing, 12)
    }
}

// MARK: - Name and Tag
struct NameAndTag: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ivy")
                .font(
                    Font.custom("DM Sans", size: 18)
                        .weight(.bold)
                )
                .frame(alignment: .leading) // Align text to the left
            
            Text("Beginner")
                .font(Font.custom("DM Sans", size: 10))
                .foregroundColor(Color.white) // Set the font color to white
                .frame(width: 45, height: 15) // Set the frame size
                .padding(.horizontal, 8) // Horizontal padding
                .padding(.top, 0) // Top padding
                .padding(.bottom, 1) // Bottom padding
                .background(Color("DarkPurple")) // Set the background color
                .cornerRadius(100) // Rounded corners
            
        }
    }
}

// MARK: - Profile Buttons
struct ProfileButtons: View {
    // State variables to track the toggled state of buttons
    @State private var isSearchActive = false
    @State private var isNotificationActive = false
    @State private var isSettingsActive = false
    
    var body: some View {
        HStack {
            // Search button
            Button(action: {
                // Toggle the search button state
                self.isSearchActive.toggle()
            }) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(isSearchActive ? Color.white : Color.black) // Icon color changes based on state
            }
            .frame(width: 34, height: 34) // Size of the entire button
            .background(Circle().fill(isSearchActive ? Color("MyGreen") : Color.white)) // Background color depends on isSearchActive
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 0.5) // Gray border
            )
            .padding(.trailing, 3)
            
            // Notification button
            Button(action: {
                // Toggle the notification button state
                self.isNotificationActive.toggle()
            }) {
                Image(systemName: "bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(isNotificationActive ? Color.white : Color.black) // Icon color changes based on state
            }
            .frame(width: 34, height: 34) // Size of the entire button
            .background(Circle().fill(isNotificationActive ? Color("MyGreen") : Color.white)) // Background color depends on isNotificationActive
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 0.5) // Gray border
            )
            .padding(.horizontal, 3)
            
            // Settings button
            Button(action: {
                // Toggle the settings button state
                self.isSettingsActive.toggle()
            }) {
                Image(systemName: "gearshape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(isSettingsActive ? Color.white : Color.black) // Icon color changes based on state
            }
            .frame(width: 34, height: 34) // Size of the entire button
            .background(Circle().fill(isSettingsActive ? Color("MyGreen") : Color.white)) // Background color depends on isSettingsActive
            .overlay(
                Circle().stroke(isSettingsActive ? Color.white : Color.gray, lineWidth: 0.5) // Border color changes based on state
            )
            .padding(.trailing, 18)
        }
    }
}

// MARK: - Categories
struct Categories: View {
    var body: some View {
        VStack {
            HStack {
                CircleButtonView(emoji: "⚽️", label: "Sport")
                CircleButtonView(emoji: "🎨", label: "Design")
                CircleButtonView(emoji: "💻", label: "Tech", destination: AnyView(Bside()))
                CircleButtonView(emoji: "🍪", label: "Cook")
            }
            HStack {
                CircleButtonView(emoji: "🕺", label: "Dance")
                CircleButtonView(emoji: "🥁", label: "Music")
                CircleButtonView(emoji: "➕", label: "Add")
            }
        }
        .padding(.top, 20)
    }
}

struct CircleButtonView: View {
    var emoji: String
    var label: String
    var destination: AnyView? // Optional destination view
    
    var body: some View {
        VStack {
            if let destinationView = destination {
                // If there is a destination, make the button a NavigationLink
                NavigationLink(destination: destinationView) {
                    CircleButtonContent(emoji: emoji, label: label)
                }
            } else {
                // If there isn't a destination, just create a button without navigation
                Button(action: {
                    // Action to navigate to another page
                }) {
                    CircleButtonContent(emoji: emoji, label: label)
                }
            }
        }
    }
    
    private func CircleButtonContent(emoji: String, label: String) -> some View {
        VStack {
            Text(emoji)
                .font(Font.custom("DM Sans", size: 20).weight(.bold))
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.white))
                .shadow(color: Color("mygray"), radius: 1)
                .padding(.horizontal, 15)
                            .padding(.bottom, 7)
            Text(label)
                .font(Font.custom("DM Sans", size: 12).weight(.medium))
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Tasks
// Define the horizontal scroll view
struct TaskScrollView: View {
    
    // Two-dimensional array to hold tasks in pairs
    private var taskPairs: [[Task]] {
        var pairs: [[Task]] = []
        for index in stride(from: 0, to: Task.allTasks.count, by: 2) {
            var pair: [Task] = []
            if index < Task.allTasks.count {
                pair.append(Task.allTasks[index])
            }
            if index + 1 < Task.allTasks.count {
                pair.append(Task.allTasks[index + 1])
            }
            pairs.append(pair)
        }
        return pairs
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { // Set spacing to 0 or another small value
            HStack {
                Text("Tasks In Progress")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    // Action for View All
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("MyGreen"))
                            .frame(minWidth: 42, minHeight: 25)
                        Text("View all")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                    }
                    .fixedSize()
                }
            }
            .padding([.horizontal, .top])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(taskPairs, id: \.self) { pair in // Loop through task pairs
                        VStack {
                            ForEach(pair, id: \.id) { task in
                                ProgressView(task: task)
                                    .frame(width: 300, height: 180) // Set a larger frame for each card
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// Example usage
struct TasksView: View {
    
    var body: some View {
        TaskScrollView()
    }
}

struct ProgressView: View {
    let task: Task // Your Task model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.iconName) // Replace with your icon name
                    .font(.system(size: 33))
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(task.color))
                        .frame(minWidth: 42, minHeight: 21) // Minimum size to accommodate the text and padding
                    Text("\(Int(task.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                }
                .fixedSize()
            }
            
            ZStack {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 45)
                        .frame(height: 10)
                        .foregroundColor(Color.gray.opacity(0.2))
                    RoundedRectangle(cornerRadius: 45)
                        .frame(width: geometry.size.width * CGFloat(task.progress), height: 10)
                        .foregroundColor(Color(task.color))
                        .animation(.easeInOut, value: task.progress)
                }
            }
            .frame(height: 10)
            
            Divider()
                .background(Color.gray.opacity(0.5)) // Custom color from asset catalog
                
            HStack {
                Text(task.goalText)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                
                Spacer()
                
                Button(action: {
                    // Actions to continue
                }) {
                    Text("Continue")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color("DarkPurple"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .shadow(radius: 1)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .scaleEffect(0.95) // Adjust the scale to match the size from the image
    }
}

struct Task: Identifiable, Hashable { // Conform to Hashable
    let id: UUID = UUID()
    let title: String
    let iconName: String
    let progress: Float
    let goalText: String
    let color: String
    
    // Provide a hash function for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Make sure to also provide an equality operator for Hashable conformance
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
    
    // Sample data
    static let allTasks = [
        Task(title: "Web Design", iconName: "🎨", progress: 0.44, goalText: "Goal: 100h", color:"MyOrange"),
        Task(title: "Python", iconName: "💻", progress: 0.80, goalText: "Goal: 50h", color:"MyBlue"),
        Task(title: "Python", iconName: "💻", progress: 0.25, goalText: "Goal: 50h", color:"MyBlue"),
        Task(title: "Python", iconName: "🎨", progress: 0.50, goalText: "Goal: 50h", color:"MyGreen"),
        // Add more tasks here...
    ]
}

// MARK: - BottomNavigationBar
struct BottomNavigationBar: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "house") // Use your home icon image
                Text("Home")
            }
            .foregroundColor(Color("DarkPurple"))
            Spacer()
            VStack {
                Image(systemName: "checkmark") // Use your tasks icon image
                Text("Tasks")
            }
            .foregroundColor(Constants.inactiveTabColor)
            Spacer()
            VStack {
                Image(systemName: "person.3") // Use your groups icon image
                Text("Groups")
            }
            .foregroundColor(Constants.inactiveTabColor)
            Spacer()
        }
        .padding(.vertical, 10)
        .background(.white)
        .frame(height: 60)
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
