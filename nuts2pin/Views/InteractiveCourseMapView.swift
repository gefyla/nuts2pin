import SwiftUI
import MapKit

struct InteractiveCourseMapView: View {
    @ObservedObject var viewModel: CourseViewModel
    @State private var region = MKCoordinateRegion()
    @State private var mapStyle: MapStyle = .realistic
    @State private var selectedPoint: Coordinate?
    @State private var isDraggingPin = false
    @State private var isDraggingTee = false
    @State private var isDraggingPractice = false
    @State private var showingTeeBoxSelection = false
    @State private var measurementMode: MeasurementMode = .none
    @State private var measurementStart: Coordinate?
    @State private var measurementEnd: Coordinate?
    
    enum MeasurementMode {
        case none
        case toPin
        case toPoint
        case betweenPoints
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: !viewModel.isPracticeMode,
                annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    switch annotation.type {
                    case .pin:
                        DraggablePinView(isDragging: $isDraggingPin) {
                            if let hole = viewModel.currentHole {
                                viewModel.updatePinLocation(hole: hole, newLocation: annotation.coordinate)
                            }
                        }
                    case .tee:
                        DraggableTeeView(isDragging: $isDraggingTee) {
                            if let hole = viewModel.currentHole {
                                viewModel.updateTeeLocation(hole: hole, newLocation: annotation.coordinate)
                            }
                        }
                    case .hazard:
                        HazardView(type: annotation.hazardType)
                    case .shot:
                        ShotView()
                    case .measurement:
                        MeasurementPointView()
                    case .practice:
                        DraggablePracticeView(isDragging: $isDraggingPractice) {
                            viewModel.updatePracticeLocation(annotation.coordinate)
                        }
                    }
                }
            }
            .mapStyle(mapStyle == .realistic ? .standard : .hybrid)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if measurementMode != .none {
                            let coordinate = region.center
                            if measurementStart == nil {
                                measurementStart = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
                            }
                            measurementEnd = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        }
                    }
                    .onEnded { _ in
                        if measurementMode != .none {
                            measurementMode = .none
                        }
                    }
            )
            
            VStack {
                // Practice mode controls
                HStack {
                    Button(action: { viewModel.togglePracticeMode() }) {
                        Image(systemName: viewModel.isPracticeMode ? "figure.golf" : "location")
                            .padding()
                            .background(viewModel.isPracticeMode ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    if viewModel.isPracticeMode {
                        Text("Practice Mode")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                .padding()
                
                // Measurement controls
                HStack {
                    Button(action: { measurementMode = .toPin }) {
                        Image(systemName: "ruler")
                            .padding()
                            .background(measurementMode == .toPin ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { measurementMode = .betweenPoints }) {
                        Image(systemName: "line.diagonal")
                            .padding()
                            .background(measurementMode == .betweenPoints ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                Spacer()
                
                // Distance overlays
                if let distanceToPin = viewModel.distanceToPin {
                    DistanceOverlay(
                        distance: distanceToPin,
                        label: "To Pin"
                    )
                }
                
                if let distanceToHazard = viewModel.distanceToHazard,
                   let hazard = viewModel.selectedHazard {
                    DistanceOverlay(
                        distance: distanceToHazard,
                        label: "To \(hazard.type.rawValue.capitalized)"
                    )
                }
                
                if let start = measurementStart,
                   let end = measurementEnd {
                    DistanceOverlay(
                        distance: Coordinate.distance(from: start, to: end),
                        label: "Measurement"
                    )
                }
            }
            .padding()
        }
        .onAppear {
            updateRegion()
        }
        .onChange(of: viewModel.currentHole) { _ in
            updateRegion()
        }
        .sheet(isPresented: $showingTeeBoxSelection) {
            TeeBoxSelectionView(viewModel: viewModel)
        }
    }
    
    private var annotations: [MapAnnotation] {
        var annotations: [MapAnnotation] = []
        
        if let hole = viewModel.currentHole {
            // Add pin
            annotations.append(MapAnnotation(
                coordinate: (hole.customPinLocation ?? hole.pinLocation).clLocation,
                type: .pin
            ))
            
            // Add tee
            if let teeBox = hole.teeBoxes[viewModel.currentCourse?.selectedTeeBox ?? .white] {
                annotations.append(MapAnnotation(
                    coordinate: teeBox.location.clLocation,
                    type: .tee
                ))
            }
            
            // Add hazards
            for hazard in hole.hazards {
                annotations.append(MapAnnotation(
                    coordinate: hazard.location.clLocation,
                    type: .hazard,
                    hazardType: hazard.type
                ))
            }
            
            // Add shots
            for shot in hole.shots {
                annotations.append(MapAnnotation(
                    coordinate: shot.endLocation.clLocation,
                    type: .shot
                ))
            }
            
            // Add measurement points
            if let start = measurementStart {
                annotations.append(MapAnnotation(
                    coordinate: start.clLocation,
                    type: .measurement
                ))
            }
            if let end = measurementEnd {
                annotations.append(MapAnnotation(
                    coordinate: end.clLocation,
                    type: .measurement
                ))
            }
            
            // Add practice marker if in practice mode
            if viewModel.isPracticeMode,
               let practiceLocation = viewModel.practiceLocation {
                annotations.append(MapAnnotation(
                    coordinate: practiceLocation.clLocation,
                    type: .practice
                ))
            }
        }
        
        return annotations
    }
    
    private func updateRegion() {
        guard let hole = viewModel.currentHole,
              let teeBox = hole.teeBoxes[viewModel.currentCourse?.selectedTeeBox ?? .white] else { return }
        
        // Calculate the center point between tee and pin
        let centerLat = (teeBox.location.latitude + hole.pinLocation.latitude) / 2
        let centerLon = (teeBox.location.longitude + hole.pinLocation.longitude) / 2
        
        // Calculate the span to show the entire hole with some padding
        let latDelta = abs(teeBox.location.latitude - hole.pinLocation.latitude) * 1.5
        let lonDelta = abs(teeBox.location.longitude - hole.pinLocation.longitude) * 1.5
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }
}

// MARK: - Supporting Views

struct DraggablePinView: View {
    @Binding var isDragging: Bool
    let onDragEnd: () -> Void
    
    var body: some View {
        Image(systemName: "flag.fill")
            .foregroundColor(.red)
            .font(.title)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        isDragging = true
                    }
                    .onEnded { _ in
                        isDragging = false
                        onDragEnd()
                    }
            )
    }
}

struct DraggableTeeView: View {
    @Binding var isDragging: Bool
    let onDragEnd: () -> Void
    
    var body: some View {
        Image(systemName: "circle.fill")
            .foregroundColor(.blue)
            .font(.title2)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        isDragging = true
                    }
                    .onEnded { _ in
                        isDragging = false
                        onDragEnd()
                    }
            )
    }
}

struct DraggablePracticeView: View {
    @Binding var isDragging: Bool
    let onDragEnd: () -> Void
    
    var body: some View {
        Image(systemName: "figure.golf")
            .foregroundColor(.green)
            .font(.title2)
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        isDragging = true
                    }
                    .onEnded { _ in
                        isDragging = false
                        onDragEnd()
                    }
            )
    }
}

struct MeasurementPointView: View {
    var body: some View {
        Image(systemName: "circle.fill")
            .foregroundColor(.purple)
            .font(.caption)
    }
}

struct TeeBoxSelectionView: View {
    @ObservedObject var viewModel: CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(TeeBox.allCases, id: \.self) { teeBox in
                if let hole = viewModel.currentHole,
                   let teeInfo = hole.teeBoxes[teeBox] {
                    Button(action: {
                        viewModel.selectTeeBox(teeBox)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Circle()
                                .fill(teeBox.color)
                                .frame(width: 20, height: 20)
                            
                            VStack(alignment: .leading) {
                                Text(teeBox.rawValue)
                                    .font(.headline)
                                Text("\(teeInfo.distance) yards")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
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