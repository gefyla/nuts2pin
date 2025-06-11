import SwiftUI

struct ScoringView: View {
    @ObservedObject var viewModel: CourseViewModel
    @State private var showingScoreInput = false
    @State private var currentScore: Int?
    
    var body: some View {
        NavigationView {
            if let course = viewModel.currentCourse {
                VStack {
                    // Current Hole Score Input
                    if let hole = viewModel.currentHole {
                        VStack(spacing: 20) {
                            Text("Hole \(hole.number)")
                                .font(.title)
                            
                            HStack(spacing: 30) {
                                VStack {
                                    Text("Par")
                                        .font(.headline)
                                    Text("\(hole.par)")
                                        .font(.title)
                                }
                                
                                VStack {
                                    Text("Distance")
                                        .font(.headline)
                                    Text("\(hole.distance) yds")
                                        .font(.title)
                                }
                                
                                VStack {
                                    Text("Score")
                                        .font(.headline)
                                    if let score = hole.score {
                                        Text("\(score)")
                                            .font(.title)
                                    } else {
                                        Button(action: { showingScoreInput = true }) {
                                            Text("Enter")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding()
                    }
                    
                    // Scorecard
                    ScorecardView(course: course)
                        .padding()
                }
                .navigationTitle("Scorecard")
                .sheet(isPresented: $showingScoreInput) {
                    ScoreInputView(viewModel: viewModel)
                }
            } else {
                Text("Select a course to view scorecard")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ScorecardView: View {
    let course: Course
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Hole")
                        .frame(width: 40)
                    ForEach(1...9) { hole in
                        Text("\(hole)")
                            .frame(maxWidth: .infinity)
                    }
                }
                .font(.headline)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                
                // Par Row
                HStack {
                    Text("Par")
                        .frame(width: 40)
                    ForEach(1...9) { hole in
                        if let holeData = course.holes.first(where: { $0.number == hole }) {
                            Text("\(holeData.par)")
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("-")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.vertical, 8)
                
                // Distance Row
                HStack {
                    Text("Yards")
                        .frame(width: 40)
                    ForEach(1...9) { hole in
                        if let holeData = course.holes.first(where: { $0.number == hole }) {
                            Text("\(holeData.distance)")
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("-")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                
                // Score Row
                HStack {
                    Text("Score")
                        .frame(width: 40)
                    ForEach(1...9) { hole in
                        if let holeData = course.holes.first(where: { $0.number == hole }) {
                            if let score = holeData.score {
                                Text("\(score)")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(scoreColor(score: score, par: holeData.par))
                            } else {
                                Text("-")
                                    .frame(maxWidth: .infinity)
                            }
                        } else {
                            Text("-")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.vertical, 8)
                
                // Totals
                VStack(spacing: 0) {
                    Divider()
                    
                    // Front 9 Totals
                    HStack {
                        Text("Out")
                            .frame(width: 40)
                        ForEach(1...9) { hole in
                            if let holeData = course.holes.first(where: { $0.number == hole }) {
                                if let score = holeData.score {
                                    Text("\(score)")
                                        .frame(maxWidth: .infinity)
                                } else {
                                    Text("-")
                                        .frame(maxWidth: .infinity)
                                }
                            } else {
                                Text("-")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    
                    // Total Score
                    HStack {
                        Text("Total")
                            .frame(width: 40)
                            .font(.headline)
                        Text("\(totalScore)")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                    }
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
    
    private var totalScore: Int {
        course.holes.compactMap { $0.score }.reduce(0, +)
    }
    
    private func scoreColor(score: Int, par: Int) -> Color {
        if score < par {
            return .green
        } else if score > par {
            return .red
        } else {
            return .primary
        }
    }
}

struct ScoreInputView: View {
    @ObservedObject var viewModel: CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedScore: Int?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let hole = viewModel.currentHole {
                    Text("Hole \(hole.number)")
                        .font(.title)
                    
                    Text("Par \(hole.par)")
                        .font(.headline)
                    
                    // Score selection buttons
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(1...12, id: \.self) { score in
                            Button(action: {
                                selectedScore = score
                                if let index = viewModel.currentCourse?.holes.firstIndex(where: { $0.id == hole.id }) {
                                    viewModel.currentCourse?.holes[index].score = score
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("\(score)")
                                    .font(.title2)
                                    .frame(width: 60, height: 60)
                                    .background(selectedScore == score ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedScore == score ? .white : .primary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Enter Score")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    ScoringView(viewModel: CourseViewModel(locationManager: LocationManager()))
} 