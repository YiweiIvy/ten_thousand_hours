import SwiftUI

// Define custom colors to match the design
extension Color {
    static let backgroundGray = Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255)
    static let progressGray = Color(red: 229 / 255, green: 229 / 255, blue: 234 / 255)
    static let textGray = Color(red: 142 / 255, green: 142 / 255, blue: 147 / 255)
}

struct CategoryPage: View {
    var categoryId: String
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            if let category = taskViewModel.currentCategory {
                CategoryContentView(category: category, taskViewModel: taskViewModel)
            } else {
                Text("Loading")
            }
        }
        .onAppear {
            taskViewModel.fetchCategory(withId: categoryId)
        }
        .onReceive(taskViewModel.$currentCategory) { currentCategory in
            if let category = currentCategory {
                Task {
                    await taskViewModel.fetchTasks(withIds: category.tasks)
                }
            }
        }
    }
}

struct CategoryContentView: View {
    var category: Category
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack {
            GoalProgressView(
                taskViewModel: taskViewModel
            )
            ProgressGridView(taskViewModel: taskViewModel)
            Spacer()
            BottomNavigationBar()
        }
    }
}


struct GoalProgressView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var navigateToAddTask = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let category = taskViewModel.currentCategory {
                HStack {
                    Text("💻") // Laptop emoji
                        .font(.system(size: 33))
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                    
                    Text(category.name)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize * 1.5))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image("check-circle--check") // Your custom checkmark image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("\(Int((category.completedTime / category.targetTime) * 100))%")
                        .font(.system(size: 30 * 1.05, weight: .bold))
                        .foregroundColor(Color.blue)
                }
                
                ZStack {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 45)
                            .frame(height: 10)
                            .foregroundColor(Color.progressGray)
                        RoundedRectangle(cornerRadius: 45)
                            .frame(width: geometry.size.width * CGFloat(category.completedTime / category.targetTime), height: 10)
                            .foregroundColor(Color.blue)
                            .animation(.easeInOut, value: category.completedTime / category.targetTime)
                    }
                }
                .frame(height: 10)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 1)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5]))
                            .foregroundColor(Color("mygray"))
                    )
                    .padding(.vertical)
                
                HStack {
                    Image(systemName: "books.vertical")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.textGray)
                    
                    Text("Goal: \(Int(category.targetTime))h")
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
                            destination: AddTaskView(categoryId: category.id, taskViewModel: taskViewModel, onDismiss: {
                                Task {
                                    await taskViewModel.fetchTasks(withIds: category.tasks)
                                }
                            }),
                            isActive: $navigateToAddTask
                        ) {
                            Text("Add Task")
                        }
                            .hidden()
                    )
                }
            } else {
                // Placeholder or loading indicator
                Text("Loading category data...")
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
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        let items = taskViewModel.tasks.map { task in
            ProgressItem(
                title: task.name,
                color: .green, // Dynamic setting can be applied
                progress: Float(task.completedTime / task.targetTime),
                icon: "laptopcomputer" // Default icon; modify as needed
            )
        }
        ScrollView(.vertical) { // Wrap in a ScrollView with vertical scrolling
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(items, id: \.title) { item in
                    ProgressCell(item: item)
                }
            }
            .padding()
        }
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
        CategoryPage(categoryId: "A156C7F3-32B8-4F25-9982-A723AA512FFA", taskViewModel: TaskViewModel())
    }
}
