import SwiftUI
import MapKit

struct CourseMapView: View {
    let hole: Hole?
    let userLocation: CLLocationCoordinate2D?
    let isRealistic: Bool
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.5683, longitude: -121.9497), // Pebble Beach
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                annotation.view
            }
        }
        .mapStyle(isRealistic ? .standard : .hybrid)
        .onAppear {
            updateRegion()
        }
        .onChange(of: hole) { _ in
            updateRegion()
        }
    }
    
    private var annotations: [MapAnnotation] {
        var annotations: [MapAnnotation] = []
        
        if let hole = hole {
            // Add tee box
            annotations.append(MapAnnotation(
                coordinate: hole.teeLocation.clCoordinate,
                view: AnyView(
                    Image(systemName: "flag.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                )
            ))
            
            // Add pin
            annotations.append(MapAnnotation(
                coordinate: hole.pinLocation.clCoordinate,
                view: AnyView(
                    Image(systemName: "flag.fill")
                        .foregroundColor(.red)
                        .font(.title)
                )
            ))
            
            // Add hazards
            for hazard in hole.hazards {
                annotations.append(MapAnnotation(
                    coordinate: hazard.location.clCoordinate,
                    view: AnyView(
                        Image(systemName: hazardIcon(for: hazard.type))
                            .foregroundColor(.orange)
                            .font(.title2)
                    )
                ))
            }
        }
        
        return annotations
    }
    
    private func updateRegion() {
        guard let hole = hole else { return }
        
        let coordinates = [hole.teeLocation, hole.pinLocation] + hole.hazards.map { $0.location }
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0
        
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
        case .water: return "drop.fill"
        case .bunker: return "circle.fill"
        case .outOfBounds: return "exclamationmark.triangle.fill"
        case .tree: return "leaf.fill"
        }
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let view: AnyView
} 