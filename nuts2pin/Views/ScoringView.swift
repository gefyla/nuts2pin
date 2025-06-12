import SwiftUI

struct ScoringView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var showingScoreInput = false
    @State private var selectedHole: Hole?
    
    var body: some View {
        NavigationView {
            VStack {
                if let course = viewModel.currentCourse {
                    // Scorecard Header
                    HStack {
                        Text(course.name)
                            .font(.title)
                        Spacer()
                        Text("Total: \(viewModel.totalScore)")
                            .font(.title2)
                    }
                    .padding()
                    
                    // Scorecard
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header Row
                            HStack {
                                Text("Hole")
                                    .frame(width: 40)
                                Text("Par")
                                    .frame(width: 40)
                                Text("Score")
                                    .frame(width: 60)
                                Text("+/-")
                                    .frame(width: 40)
                            }
                            .font(.headline)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            
                            // Hole Rows
                            ForEach(course.holes) { hole in
                                Button(action: {
                                    selectedHole = hole
                                    showingScoreInput = true
                                }) {
                                    HStack {
                                        Text("\(hole.number)")
                                            .frame(width: 40)
                                        Text("\(hole.par)")
                                            .frame(width: 40)
                                        Text(hole.score.map(String.init) ?? "-")
                                            .frame(width: 60)
                                        Text(scoreToPar(hole))
                                            .frame(width: 40)
                                            .foregroundColor(scoreColor(hole))
                                    }
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if hole.number != course.holes.count {
                                    Divider()
                                }
                            }
                            
                            // Totals Row
                            Divider()
                                .padding(.vertical, 8)
                            
                            HStack {
                                Text("Total")
                                    .frame(width: 40)
                                Text("\(course.totalPar)")
                                    .frame(width: 40)
                                Text("\(viewModel.totalScore)")
                                    .frame(width: 60)
                                Text("\(viewModel.scoreToPar)")
                                    .frame(width: 40)
                                    .foregroundColor(scoreColor(viewModel.scoreToPar))
                            }
                            .font(.headline)
                            .padding(.vertical, 8)
                        }
                        .padding()
                    }
                } else {
                    // No Course Selected
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("No Course Selected")
                            .font(.title)
                        
                        Text("Select a course to view your scorecard")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Scorecard")
        }
        .sheet(isPresented: $showingScoreInput) {
            if let hole = selectedHole {
                ScoreInputView(hole: hole) { score in
                    viewModel.updateScore(for: hole, score: score)
                }
            }
        }
    }
    
    private func scoreToPar(_ hole: Hole) -> String {
        guard let score = hole.score else { return "-" }
        let diff = score - hole.par
        return diff > 0 ? "+\(diff)" : "\(diff)"
    }
    
    private func scoreColor(_ hole: Hole) -> Color {
        guard let score = hole.score else { return .primary }
        let diff = score - hole.par
        switch diff {
        case ..<0: return .green
        case 0: return .blue
        default: return .red
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case ..<0: return .green
        case 0: return .blue
        default: return .red
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