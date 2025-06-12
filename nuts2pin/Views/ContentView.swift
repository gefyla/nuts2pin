import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CourseViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showingTeeBoxSelection = false
    
    var body: some View {
        TabView {
            CourseView()
                .tabItem {
                    Label("Course", systemImage: "figure.golf")
                }
            
            ScoringView()
                .tabItem {
                    Label("Scorecard", systemImage: "list.bullet.clipboard")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
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
                Section(header: Text("Course Settings")) {
                    Toggle("Realistic Map Style", isOn: $viewModel.isMapRealistic)
                    
                    Button(action: {
                        showingTeeBoxSelection = true
                    }) {
                        HStack {
                            Text("Default Tee Box")
                            Spacer()
                            Text(viewModel.selectedTeeBox.displayName)
                                .foregroundColor(.secondary)
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
            .sheet(isPresented: $showingTeeBoxSelection) {
                TeeBoxSelectionView(
                    selectedTeeBox: $viewModel.selectedTeeBox,
                    teeBoxes: TeeBox.allCases
                )
            }
        }
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Image(systemName: "figure.golf")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Nuts2Pin")
                        .font(.title)
                        .bold()
                    
                    Text("Version 1.0.0")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            Section(header: Text("Description")) {
                Text("Nuts2Pin is a golf course companion app that helps you track your game and navigate the course. Features include:")
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    FeatureRow(icon: "map", text: "Interactive course map")
                    FeatureRow(icon: "list.bullet.clipboard", text: "Digital scorecard")
                    FeatureRow(icon: "location.fill", text: "Real-time location tracking")
                    FeatureRow(icon: "flag.fill", text: "Multiple tee box options")
                }
            }
            
            Section(header: Text("Contact")) {
                Link(destination: URL(string: "mailto:support@nuts2pin.com")!) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Email Support")
                    }
                }
                
                Link(destination: URL(string: "https://nuts2pin.com")!) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Visit Website")
                    }
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
        }
    }
}

#Preview {
    ContentView()
} 