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
                    
                    // Your other content here
                    
                }
            }
            .background(Color("HomeBackground"))
            
            Spacer() // This will push all content to the top, but we're removing it to keep the bar fixed at bottom
            
            // Bottom Navigation Bar
            BottomNavigationBar()
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
