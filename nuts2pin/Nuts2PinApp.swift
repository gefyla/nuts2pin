import SwiftUI

@main
struct Nuts2PinApp: App {
    @StateObject private var viewModel = CourseViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewModel)
                .preferredColorScheme(.light)
        }
    }
} 