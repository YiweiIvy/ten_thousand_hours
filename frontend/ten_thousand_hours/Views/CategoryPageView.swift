import SwiftUI

// Define custom colors to match the design
extension Color {
    static let backgroundGray = Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255)
    static let progressGray = Color(red: 229 / 255, green: 229 / 255, blue: 234 / 255)
    static let textGray = Color(red: 142 / 255, green: 142 / 255, blue: 147 / 255)
}

struct CategoryPage: View {
    var category: Category
    
    var body: some View {
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            VStack {
                GoalProgressView(
                    title: category.name,
                    progress: Float(category.completedTime / category.targetTime),
                    goalText: "Goal: \(Int(category.targetTime))h"  // Convert TimeInterval to Int and then to String
                )
                ProgressGridView(items: [
                    ProgressItem(title: "Python", color: .green, progress: 0.6, icon: "laptopcomputer"),
                    ProgressItem(title: "Java", color: .blue, progress: 0.6, icon: "laptopcomputer"),
                    ProgressItem(title: "Security", color: .blue, progress: 0.3, hours: 15, icon: "lock.shield"),
                    ProgressItem(title: "CPU", color: .green, progress: 0.6, icon: "cpu"),
                    ProgressItem(title: "OS", color: .orange, progress: 0.6, icon: "desktopcomputer"),
                    ProgressItem(title: "Frontend", color: .blue, progress: 0.6, icon: "paintbrush.pointed")
                ])
                Spacer()
                BottomNavigationBar()
            }
        }
    }
}

struct GoalProgressView: View {
    var title: String
    var progress: Float
    var goalText: String
    @State private var navigateToAddTask = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("💻") // Laptop emoji
                    .font(.system(size: 33))
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                
                Text(title)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize * 1.5)) // 1.1 times the current size
                                    .foregroundColor(.black)
                                
                                Spacer()
                
                Image("check-circle--check") // Your custom checkmark image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                // Percentage display added here, on the right side
                Text("\(Int(progress * 100))%") // Converts the progress to a percentage
                    .font(.system(size: 30 * 1.05, weight: .bold)) // 20% larger and bold font
                    .foregroundColor(Color.blue) // Use the color of the progress bar
            }
            
            ZStack {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 45)
                        .frame(height: 10)
                        .foregroundColor(Color.progressGray)
                    RoundedRectangle(cornerRadius: 45)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 10)
                        .foregroundColor(Color.blue)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 10)
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 1)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5]))
                        .foregroundColor(Color("mygray")) // Custom color from asset catalog
                )
                .padding(.vertical)
            
            HStack {
                Image(systemName: "books.vertical")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.textGray)
                
                Text(goalText)
                    .font(.footnote)
                    .foregroundColor(Color.textGray)
                
                Spacer()
                
                Button(action: {
                    navigateToAddTask = true
                }) {
                    Text("Add Task")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .shadow(radius: 1)
                .background(
                    NavigationLink(
                        destination: AddTaskView(),
                        isActive: $navigateToAddTask
                    ) { EmptyView() }
                    .hidden()
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .scaleEffect(0.8)
    }
}





struct ProgressGridView: View {
    var items: [ProgressItem]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            ForEach(items, id: \.title) { item in
                ProgressCell(item: item)
            }
        }
        .padding()
    }
}

struct ProgressItem {
    var title: String
    var color: Color
    var progress: Float
    var hours: Int? = nil
    var icon: String
}

struct ProgressCell: View {
    var item: ProgressItem

    var body: some View {
        VStack {
            // Icon and Text at the top
            HStack {
                Text("💻") // Icon on the left
                    .font(.headline)
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 1)

                Spacer()

                Text(item.title) // Text on the right
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 5)

            // Dotted line
            Rectangle()
                .fill(Color.clear)
                .frame(height: 1)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5]))
                        .foregroundColor(Color("mygray")) // Custom color from asset catalog
                )

            // Progress ring with percentage in the middle
            ZStack {
                Circle()
                    .stroke(Color.progressGray, lineWidth: 6)
                    .frame(width: 70, height: 70)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.item.progress, 1.0)))
                    .stroke(item.color, lineWidth: 6)
                    .frame(width: 70, height: 70)
                    .rotationEffect(Angle(degrees: 270.0))

                Text("\(Int(item.progress * 100))%") // Percentage
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .padding(.top, 5)

            // Hours (if available)
            if let hours = item.hours {
                Text("\(hours)h")
                    .font(.caption)
                    .foregroundColor(Color.textGray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct Bside_Previews: PreviewProvider {
    static var previews: some View {
        let mockCategory = Category(id: "1", emoji: "S", name: "Sample Category", targetTime: 10000, completedTime: 3000, tasks: [])
        CategoryPage(category: mockCategory)
    }
}
