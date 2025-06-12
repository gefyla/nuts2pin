import SwiftUI
import MapKit

struct CourseView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var showingTeeBoxSelection = false
    @State private var showingScoreInput = false
    
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
                            Text("Par \(course.totalPar)")
                            Text("•")
                            Text("\(course.totalDistance) yards")
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Current Hole Info
                    if let currentHole = viewModel.currentHole {
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Hole \(currentHole.number)")
                                        .font(.title2)
                                        .bold()
                                    Text("Par \(currentHole.par) • \(currentHole.distance) yards")
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showingScoreInput = true
                                }) {
                                    Text("Enter Score")
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }
                            
                            // Map View
                            CourseMapView(
                                currentHole: currentHole,
                                userLocation: viewModel.userLocation,
                                isMapRealistic: viewModel.isMapRealistic
                            )
                            .frame(height: 300)
                            .cornerRadius(12)
                            
                            // Hazards
                            if !currentHole.hazards.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Hazards")
                                        .font(.headline)
                                    
                                    ForEach(currentHole.hazards) { hazard in
                                        HStack {
                                            Image(systemName: hazard.type == .water ? "drop.fill" : "circle.fill")
                                                .foregroundColor(hazard.type == .water ? .blue : .brown)
                                            Text(hazard.description)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            // Navigation Buttons
                            HStack {
                                Button(action: {
                                    viewModel.moveToPreviousHole()
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Previous")
                                    }
                                    .foregroundColor(.blue)
                                }
                                .disabled(viewModel.currentHole?.number == 1)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingTeeBoxSelection = true
                                }) {
                                    HStack {
                                        Image(systemName: "flag.fill")
                                        Text(viewModel.selectedTeeBox.displayName)
                                    }
                                    .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.moveToNextHole()
                                }) {
                                    HStack {
                                        Text("Next")
                                        Image(systemName: "chevron.right")
                                    }
                                    .foregroundColor(.blue)
                                }
                                .disabled(viewModel.currentHole?.number == course.holes.count)
                            }
                            .padding()
                        }
                        .padding()
                    } else {
                        Text("Select a hole to begin")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("No course selected")
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingTeeBoxSelection) {
                TeeBoxSelectionView(
                    selectedTeeBox: $viewModel.selectedTeeBox,
                    teeBoxes: TeeBox.allCases
                )
            }
            .sheet(isPresented: $showingScoreInput) {
                if let currentHole = viewModel.currentHole {
                    ScoreInputView(viewModel: viewModel, hole: currentHole)
                }
            }
        }
    }
}

struct TeeBoxSelectionView: View {
    @Binding var selectedTeeBox: TeeBox
    let teeBoxes: [TeeBox]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(teeBoxes, id: \.self) { teeBox in
                Button(action: {
                    selectedTeeBox = teeBox
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(teeBox.displayName)
                        Spacer()
                        if selectedTeeBox == teeBox {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Tee Box")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ScoreInputView: View {
    @StateObject private var viewModel: CourseViewModel
    let hole: Hole
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedScore: Int
    
    init(viewModel: CourseViewModel, hole: Hole) {
        self.viewModel = viewModel
        self.hole = hole
        _selectedScore = State(initialValue: hole.score ?? hole.par)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Hole \(hole.number)")
                    .font(.title)
                
                Text("Par \(hole.par)")
                    .font(.title2)
                
                HStack(spacing: 20) {
                    ForEach(hole.par-2...hole.par+4, id: \.self) { score in
                        Button(action: {
                            selectedScore = score
                        }) {
                            Text("\(score)")
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .background(selectedScore == score ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedScore == score ? .white : .primary)
                                .cornerRadius(25)
                        }
                    }
                }
                
                Button(action: {
                    viewModel.updateScore(for: hole, score: selectedScore)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Score")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    CourseView()
        .environmentObject(CourseViewModel())
} 