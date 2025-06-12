import SwiftUI
import MapKit

struct CourseView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var showingCourseSelection = false
    @State private var showingTeeBoxSelection = false
    @State private var showingScoreInput = false
    
    var body: some View {
        NavigationView {
            Group {
                if let course = viewModel.currentCourse {
                    VStack {
                        // Map View
                        CourseMapView(
                            hole: viewModel.currentHole,
                            userLocation: viewModel.userLocation,
                            isRealistic: viewModel.isMapRealistic
                        )
                        .frame(height: 300)
                        
                        // Hole Information
                        VStack(spacing: 10) {
                            HStack {
                                Text("Hole \(viewModel.currentHole?.number ?? 0)")
                                    .font(.title)
                                Spacer()
                                Text("Par \(viewModel.currentHole?.par ?? 0)")
                                    .font(.title2)
                            }
                            
                            HStack {
                                Text("\(viewModel.currentHole?.distance ?? 0) yards")
                                    .font(.title3)
                                Spacer()
                                Button(action: { showingTeeBoxSelection = true }) {
                                    Text(viewModel.selectedTeeBox)
                                        .font(.title3)
                                }
                            }
                        }
                        .padding()
                        
                        // Navigation Buttons
                        HStack {
                            Button(action: viewModel.previousHole) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                            }
                            .disabled(viewModel.currentHole?.number == 1)
                            
                            Spacer()
                            
                            Button(action: { showingScoreInput = true }) {
                                Text("Enter Score")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                            
                            Button(action: viewModel.nextHole) {
                                Image(systemName: "chevron.right")
                                    .font(.title)
                            }
                            .disabled(viewModel.currentHole?.number == viewModel.currentCourse?.holes.count)
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .navigationTitle(course.name)
                    .navigationBarItems(trailing: Button("Change Course") {
                        showingCourseSelection = true
                    })
                } else {
                    // No Course Selected View
                    VStack(spacing: 20) {
                        Image(systemName: "figure.golf")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("No Course Selected")
                            .font(.title)
                        
                        Text("Select a course to start playing")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button(action: { showingCourseSelection = true }) {
                            Text("Select Course")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .navigationTitle("Select Course")
                }
            }
        }
        .sheet(isPresented: $showingCourseSelection) {
            CourseSelectionView()
        }
        .sheet(isPresented: $showingTeeBoxSelection) {
            TeeBoxSelectionView(selectedTeeBox: $viewModel.selectedTeeBox)
        }
        .sheet(isPresented: $showingScoreInput) {
            if let hole = viewModel.currentHole {
                ScoreInputView(hole: hole) { score in
                    viewModel.updateScore(for: hole, score: score)
                }
            }
        }
    }
}

struct TeeBoxSelectionView: View {
    @Binding var selectedTeeBox: String
    @Environment(\.presentationMode) var presentationMode
    
    let teeBoxes = ["Black", "Blue", "White", "Red"]
    
    var body: some View {
        NavigationView {
            List(teeBoxes, id: \.self) { teeBox in
                Button(action: {
                    selectedTeeBox = teeBox
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(teeBox)
                        Spacer()
                        if teeBox == selectedTeeBox {
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
    let hole: Hole
    let onScoreEntered: (Int) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedScore: Int
    
    init(hole: Hole, onScoreEntered: @escaping (Int) -> Void) {
        self.hole = hole
        self.onScoreEntered = onScoreEntered
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
                    onScoreEntered(selectedScore)
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
        .environmentObject(LocationManager())
} 