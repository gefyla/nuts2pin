import SwiftUI
import MapKit

struct CourseMapView: View {
    @ObservedObject var viewModel: CourseViewModel
    @State private var region = MKCoordinateRegion()
    @State private var mapStyle: MapStyle = .realistic
    @State private var selectedPoint: Coordinate?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    switch annotation.type {
                    case .pin:
                        PinView()
                    case .hazard:
                        HazardView(type: annotation.hazardType)
                    case .tee:
                        TeeView()
                    case .shot:
                        ShotView()
                    }
                }
            }
            .mapStyle(mapStyle == .realistic ? .standard : .hybrid)
            
            VStack {
                Spacer()
                
                // Distance overlay
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
            }
            .padding()
        }
        .onAppear {
            updateRegion()
        }
        .onChange(of: viewModel.currentHole) { _ in
            updateRegion()
        }
    }
    
    private var annotations: [MapAnnotation] {
        var annotations: [MapAnnotation] = []
        
        if let hole = viewModel.currentHole {
            // Add pin
            annotations.append(MapAnnotation(
                coordinate: hole.pinLocation.clLocation,
                type: .pin
            ))
            
            // Add tee
            annotations.append(MapAnnotation(
                coordinate: hole.teeLocation.clLocation,
                type: .tee
            ))
            
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
        }
        
        return annotations
    }
    
    private func updateRegion() {
        guard let hole = viewModel.currentHole else { return }
        
        // Calculate the center point between tee and pin
        let centerLat = (hole.teeLocation.latitude + hole.pinLocation.latitude) / 2
        let centerLon = (hole.teeLocation.longitude + hole.pinLocation.longitude) / 2
        
        // Calculate the span to show the entire hole with some padding
        let latDelta = abs(hole.teeLocation.latitude - hole.pinLocation.latitude) * 1.5
        let lonDelta = abs(hole.teeLocation.longitude - hole.pinLocation.longitude) * 1.5
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }
}

// MARK: - Supporting Views

struct PinView: View {
    var body: some View {
        Image(systemName: "flag.fill")
            .foregroundColor(.red)
            .font(.title)
    }
}

struct TeeView: View {
    var body: some View {
        Image(systemName: "circle.fill")
            .foregroundColor(.blue)
            .font(.title2)
    }
}

struct HazardView: View {
    let type: HazardType
    
    var body: some View {
        Image(systemName: hazardIcon)
            .foregroundColor(hazardColor)
            .font(.title2)
    }
    
    private var hazardIcon: String {
        switch type {
        case .water: return "drop.fill"
        case .bunker: return "circle.fill"
        case .outOfBounds: return "xmark.circle.fill"
        case .tree: return "leaf.fill"
        }
    }
    
    private var hazardColor: Color {
        switch type {
        case .water: return .blue
        case .bunker: return .yellow
        case .outOfBounds: return .red
        case .tree: return .green
        }
    }
}

struct ShotView: View {
    var body: some View {
        Image(systemName: "circle.fill")
            .foregroundColor(.gray)
            .font(.caption)
    }
}

struct DistanceOverlay: View {
    let distance: Double
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
            Text(String(format: "%.0f yards", distance))
                .font(.headline)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
}

// MARK: - Supporting Types

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType
    var hazardType: HazardType?
    
    init(coordinate: CLLocationCoordinate2D, type: AnnotationType, hazardType: HazardType? = nil) {
        self.coordinate = coordinate
        self.type = type
        self.hazardType = hazardType
    }
}

enum AnnotationType {
    case pin
    case hazard
    case tee
    case shot
} 