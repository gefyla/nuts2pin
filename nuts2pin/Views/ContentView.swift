import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CourseView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Course")
                }
                .tag(0)
            
            ScoringView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Scorecard")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: CourseViewModel
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App Settings")) {
                    Toggle("Practice Mode", isOn: $viewModel.isPracticeMode)
                    
                    NavigationLink(destination: TeeBoxSelectionView(viewModel: viewModel)) {
                        HStack {
                            Text("Default Tee Box")
                            Spacer()
                            Text(viewModel.currentCourse?.selectedTeeBox.rawValue ?? "White")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    Button("About Nuts2Pin") {
                        showingAbout = true
                    }
                    
                    Link("Rate the App", destination: URL(string: "https://apps.apple.com")!)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "figure.golf")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Nuts2Pin")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Version 1.0")
                    .foregroundColor(.gray)
                
                Text("Your Personal Golf Companion")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Nuts2Pin helps you track your golf game with precision. Measure distances, record scores, and improve your game with our comprehensive golf companion app.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the sheet
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CourseViewModel())
    }
} 