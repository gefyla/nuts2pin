import SwiftUI

@main
struct Nuts2PinApp: App {
    @StateObject private var viewModel = CourseViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(locationManager)
        }
    }
} 