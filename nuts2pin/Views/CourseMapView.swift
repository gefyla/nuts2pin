import SwiftUI
import MapKit

struct CourseMapView: View {
    let currentHole: Hole
    let userLocation: CLLocation?
    let isMapRealistic: Bool
    
    @State private var region: MKCoordinateRegion
    
    init(currentHole: Hole, userLocation: CLLocation?, isMapRealistic: Bool) {
        self.currentHole = currentHole
        self.userLocation = userLocation
        self.isMapRealistic = isMapRealistic
        
        // Initialize region to center on the tee box
        _region = State(initialValue: MKCoordinateRegion(
            center: currentHole.teeLocation.clCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                annotation.view
            }
        }
        .mapStyle(isMapRealistic ? .standard : .hybrid)
        .onAppear {
            updateRegion()
        }
    }
    
    private var annotations: [MapAnnotation] {
        var annotations: [MapAnnotation] = []
        
        // Add tee box
        annotations.append(MapAnnotation(
            coordinate: currentHole.teeLocation.clCoordinate,
            view: AnyView(
                Image(systemName: "flag.fill")
                    .foregroundColor(.blue)
                    .font(.title)
            )
        ))
        
        // Add pin
        annotations.append(MapAnnotation(
            coordinate: currentHole.pinLocation.clCoordinate,
            view: AnyView(
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .font(.title)
            )
        ))
        
        // Add hazards
        for hazard in currentHole.hazards {
            annotations.append(MapAnnotation(
                coordinate: hazard.location.clCoordinate,
                view: AnyView(
                    Image(systemName: hazardIcon(for: hazard.type))
                        .foregroundColor(hazardColor(for: hazard.type))
                        .font(.title2)
                )
            ))
        }
        
        return annotations
    }
    
    private func updateRegion() {
        var coordinates: [CLLocationCoordinate2D] = [
            currentHole.teeLocation.clCoordinate,
            currentHole.pinLocation.clCoordinate
        ]
        
        // Add hazard locations
        coordinates.append(contentsOf: currentHole.hazards.map { $0.location.clCoordinate })
        
        // Add user location if available
        if let userLocation = userLocation {
            coordinates.append(userLocation.coordinate)
        }
        
        // Calculate the center and span
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        region = MKCoordinateRegion(center: center, span: span)
    }
    
    private func hazardIcon(for type: HazardType) -> String {
        switch type {
        case .bunker:
            return "circle.fill"
        case .water:
            return "drop.fill"
        case .outOfBounds:
            return "xmark.circle.fill"
        case .rough:
            return "leaf.fill"
        case .fairway:
            return "arrow.up.circle.fill"
        case .green:
            return "circle.circle.fill"
        }
    }
    
    private func hazardColor(for type: HazardType) -> Color {
        switch type {
        case .bunker:
            return .brown
        case .water:
            return .blue
        case .outOfBounds:
            return .red
        case .rough:
            return .green
        case .fairway:
            return .green
        case .green:
            return .green
        }
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let view: AnyView
}

#Preview {
    CourseMapView(
        currentHole: Hole(
            number: 1,
            par: 4,
            distance: 380,
            teeLocation: Coordinate(latitude: 36.5683, longitude: -121.9497),
            pinLocation: Coordinate(latitude: 36.5685, longitude: -121.9490),
            hazards: [
                Hazard(type: .bunker, location: Coordinate(latitude: 36.5684, longitude: -121.9493), description: "Fairway bunker"),
                Hazard(type: .water, location: Coordinate(latitude: 36.5686, longitude: -121.9488), description: "Ocean")
            ]
        ),
        userLocation: nil,
        isMapRealistic: true
    )
} 