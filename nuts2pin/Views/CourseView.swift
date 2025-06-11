import SwiftUI

struct CourseView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var viewModel: CourseViewModel
    @State private var mapStyle: MapStyle = .realistic
    @State private var showingClubSelection = false
    @State private var selectedClub: Club?
    @State private var showingCourseSelection = false
    
    init() {
        _viewModel = StateObject(wrappedValue: CourseViewModel(locationManager: LocationManager()))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.currentCourse == nil {
                    // Show course selection prompt
                    VStack(spacing: 20) {
                        Image(systemName: "map")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("No Course Selected")
                            .font(.title)
                        
                        Text("Select a course to begin playing")
                            .foregroundColor(.secondary)
                        
                        Button(action: { showingCourseSelection = true }) {
                            Text("Select Course")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    // Show course view
                    VStack {
                        // Map View
                        CourseMapView(viewModel: viewModel)
                            .frame(height: UIScreen.main.bounds.height * 0.6)
                        
                        // Hole Information
                        if let hole = viewModel.currentHole {
                            VStack(spacing: 10) {
                                HStack {
                                    Text("Hole \(hole.number)")
                                        .font(.title)
                                    Spacer()
                                    Text("Par \(hole.par)")
                                        .font(.title2)
                                }
                                .padding(.horizontal)
                                
                                // Distance to pin
                                if let distanceToPin = viewModel.distanceToPin {
                                    Text("\(Int(distanceToPin)) yards to pin")
                                        .font(.headline)
                                }
                                
                                // Shot recording
                                Button(action: { showingClubSelection = true }) {
                                    Text("Record Shot")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
                        }
                        
                        // Navigation buttons
                        HStack {
                            Button(action: viewModel.previousHole) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .padding()
                            }
                            .disabled(viewModel.currentHole?.number == 1)
                            
                            Spacer()
                            
                            Button(action: viewModel.nextHole) {
                                Image(systemName: "chevron.right")
                                    .font(.title)
                                    .padding()
                            }
                            .disabled(viewModel.currentHole?.number == viewModel.currentCourse?.holes.count)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(viewModel.currentCourse?.name ?? "Select Course")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.currentCourse != nil {
                        Picker("Map Style", selection: $mapStyle) {
                            Text("Realistic").tag(MapStyle.realistic)
                            Text("Cartoon").tag(MapStyle.cartoon)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.currentCourse != nil {
                        Button("Change Course") {
                            showingCourseSelection = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingClubSelection) {
                ClubSelectionView(selectedClub: $selectedClub) { club in
                    // Record the shot with the selected club
                    if let location = locationManager.location {
                        let coordinate = Coordinate(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        viewModel.recordShot(
                            club: club,
                            startLocation: coordinate,
                            endLocation: coordinate // This should be updated with actual shot end location
                        )
                    }
                }
            }
            .sheet(isPresented: $showingCourseSelection) {
                CourseSelectionView(viewModel: viewModel)
            }
        }
    }
}

struct ClubSelectionView: View {
    @Binding var selectedClub: Club?
    let onSelect: (Club) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(Club.allCases, id: \.self) { club in
                Button(action: {
                    selectedClub = club
                    onSelect(club)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(club.rawValue)
                }
            }
            .navigationTitle("Select Club")
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