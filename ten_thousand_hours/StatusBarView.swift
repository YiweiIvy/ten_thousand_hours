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
        ScrollView {
            VStack {
                // User Profile
                HStack(alignment: .center, spacing: 10){
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 36, height: 36)
                        .background(
                            Image("ProfilePic")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipped()
                        )
                        .background(Color("LightPurple"))
                        .cornerRadius(100)
                        .padding(.leading, 18)
                        .padding(.trailing, 12)
                    
                    VStack(alignment: .leading) {
                        Text("Ivy")
                            .font(Font.custom("DM Sans", size: 14).weight(.bold))
                            .frame(width: 163, alignment: .leading) // Align text to the left
                        
                        Text("Beginner")
                            .font(Font.custom("DM Sans", size: 10))
                            .foregroundColor(Color.white) // Set the font color to white
                            .frame(width: 50, height: 20) // Set the frame size
                            .padding(.horizontal, 8) // Horizontal padding
                            .padding(.top, 0) // Top padding
                            .padding(.bottom, 1) // Bottom padding
                            .background(Color("DarkPurple")) // Set the background color
                            .cornerRadius(100) // Rounded corners
                        
                    }
                    Spacer()
                    // Add your icons here
                }
                .padding(.horizontal, 8)
                .padding(.top, 12)
                .cornerRadius(100)
                
                
                // Tasks In Progress Section
                VStack(alignment: .leading) {
                    Text("Tasks In Progress")
                        .font(.title2)
                        .padding(.leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            // Add your task cards here
                        }
                    }
                }
                
                // Bottom Navigation Bar: Assuming you have a custom component for this
                BottomNavigationBar()
            }
        }
    }
}

// MARK: - StatusBar
struct StatusBar: View {
    var body: some View {
        ZStack {
            Constants.backgroundColor
                .edgesIgnoringSafeArea(.top)
                .frame(height: 44)
            
            HStack {
                Spacer()
                Text("9:41")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Constants.textColor)
                Spacer()
                // Add other status icons here
            }
        }
        .frame(height: 44)
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
            .foregroundColor(Constants.accentColor)
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
        .background(Constants.backgroundColor)
        .frame(height: 60)
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
