import SwiftUI

struct ScoringView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var showingScoreInput = false
    @State private var selectedHole: Hole?
    
    var body: some View {
        NavigationView {
            VStack {
                if let course = viewModel.currentCourse {
                    // Course Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.name)
                            .font(.title)
                            .bold()
                        
                        HStack {
                            Text("Total Score: \(viewModel.getTotalScore())")
                            Text("•")
                            Text("To Par: \(formatScoreToPar(viewModel.getScoreToPar()))")
                                .foregroundColor(scoreColor(viewModel.getScoreToPar()))
                        }
                        .font(.headline)
                    }
                    .padding()
                    
                    // Scorecard
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Text("Hole")
                                    .frame(width: 60, alignment: .leading)
                                Text("Par")
                                    .frame(width: 60, alignment: .center)
                                Text("Score")
                                    .frame(width: 60, alignment: .center)
                                Text("+/-")
                                    .frame(width: 60, alignment: .center)
                            }
                            .font(.headline)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            
                            // Front Nine
                            ForEach(course.holes.prefix(9)) { hole in
                                ScorecardRow(
                                    hole: hole,
                                    score: viewModel.getScore(for: hole),
                                    onTap: {
                                        selectedHole = hole
                                        showingScoreInput = true
                                    }
                                )
                            }
                            
                            // Front Nine Totals
                            HStack {
                                Text("Front")
                                    .frame(width: 60, alignment: .leading)
                                Text("\(course.frontNinePar)")
                                    .frame(width: 60, alignment: .center)
                                Text("\(viewModel.getTotalScore(frontNine: true))")
                                    .frame(width: 60, alignment: .center)
                                Text(formatScoreToPar(viewModel.getScoreToPar(frontNine: true)))
                                    .frame(width: 60, alignment: .center)
                                    .foregroundColor(scoreColor(viewModel.getScoreToPar(frontNine: true)))
                            }
                            .font(.headline)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            
                            // Back Nine
                            ForEach(course.holes.suffix(9)) { hole in
                                ScorecardRow(
                                    hole: hole,
                                    score: viewModel.getScore(for: hole),
                                    onTap: {
                                        selectedHole = hole
                                        showingScoreInput = true
                                    }
                                )
                            }
                            
                            // Back Nine Totals
                            HStack {
                                Text("Back")
                                    .frame(width: 60, alignment: .leading)
                                Text("\(course.backNinePar)")
                                    .frame(width: 60, alignment: .center)
                                Text("\(viewModel.getTotalScore(backNine: true))")
                                    .frame(width: 60, alignment: .center)
                                Text(formatScoreToPar(viewModel.getScoreToPar(backNine: true)))
                                    .frame(width: 60, alignment: .center)
                                    .foregroundColor(scoreColor(viewModel.getScoreToPar(backNine: true)))
                            }
                            .font(.headline)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            
                            // Total
                            HStack {
                                Text("Total")
                                    .frame(width: 60, alignment: .leading)
                                Text("\(course.totalPar)")
                                    .frame(width: 60, alignment: .center)
                                Text("\(viewModel.getTotalScore())")
                                    .frame(width: 60, alignment: .center)
                                Text(formatScoreToPar(viewModel.getScoreToPar()))
                                    .frame(width: 60, alignment: .center)
                                    .foregroundColor(scoreColor(viewModel.getScoreToPar()))
                            }
                            .font(.headline)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                        }
                        .padding()
                    }
                } else {
                    Text("Select a course to view scorecard")
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingScoreInput) {
                if let hole = selectedHole {
                    ScoreInputView(viewModel: viewModel, hole: hole)
                }
            }
        }
    }
    
    private func formatScoreToPar(_ score: Int) -> String {
        if score > 0 {
            return "+\(score)"
        } else {
            return "\(score)"
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score < 0 {
            return .red
        } else if score > 0 {
            return .blue
        } else {
            return .primary
        }
    }
}

struct ScorecardRow: View {
    let hole: Hole
    let score: Int?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("\(hole.number)")
                    .frame(width: 60, alignment: .leading)
                Text("\(hole.par)")
                    .frame(width: 60, alignment: .center)
                Text(score.map { "\($0)" } ?? "-")
                    .frame(width: 60, alignment: .center)
                if let score = score {
                    Text(formatScoreToPar(score - hole.par))
                        .frame(width: 60, alignment: .center)
                        .foregroundColor(scoreColor(score - hole.par))
                } else {
                    Text("-")
                        .frame(width: 60, alignment: .center)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatScoreToPar(_ score: Int) -> String {
        if score > 0 {
            return "+\(score)"
        } else {
            return "\(score)"
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score < 0 {
            return .red
        } else if score > 0 {
            return .blue
        } else {
            return .primary
        }
    }
}

#Preview {
    ScoringView()
        .environmentObject(CourseViewModel())
} 