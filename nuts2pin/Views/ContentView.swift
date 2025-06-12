import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CourseViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CourseView()
                .tabItem {
                    Label("Course", systemImage: "map")
                }
                .tag(0)
            
            ScoringView()
                .tabItem {
                    Label("Scorecard", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .environmentObject(viewModel)
        .environmentObject(locationManager)
    }
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var showingTeeBoxSelection = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App Settings")) {
                    Toggle("Realistic Map Style", isOn: $viewModel.isMapRealistic)
                    
                    Button(action: { showingTeeBoxSelection = true }) {
                        HStack {
                            Text("Default Tee Box")
                            Spacer()
                            Text(viewModel.selectedTeeBox)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Text("About Nuts2Pin")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showingTeeBoxSelection) {
            TeeBoxSelectionView(selectedTeeBox: $viewModel.selectedTeeBox)
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.golf")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Nuts2Pin")
                .font(.title)
            
            Text("Version 1.0")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Your personal golf companion")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CourseViewModel())
    }
} 