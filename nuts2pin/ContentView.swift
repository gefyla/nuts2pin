import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CourseView()
                .tabItem {
                    Label("Course", systemImage: "map")
                }
                .tag(0)
            
            ScoringView()
                .tabItem {
                    Label("Score", systemImage: "list.bullet")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .environmentObject(locationManager)
    }
}

// Location Manager for handling GPS
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}

// Placeholder Views
struct CourseView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var mapStyle: MapStyle = .realistic
    
    var body: some View {
        NavigationView {
            VStack {
                // Map will go here
                Text("Course View")
                    .font(.title)
                
                Picker("Map Style", selection: $mapStyle) {
                    Text("Realistic").tag(MapStyle.realistic)
                    Text("Cartoon").tag(MapStyle.cartoon)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            .navigationTitle("Course")
        }
    }
}

struct ScoringView: View {
    var body: some View {
        NavigationView {
            Text("Scoring View")
                .navigationTitle("Score")
        }
    }
}

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            Text("Statistics View")
                .navigationTitle("Stats")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings View")
                .navigationTitle("Settings")
        }
    }
}

enum MapStyle {
    case realistic
    case cartoon
}

#Preview {
    ContentView()
} 