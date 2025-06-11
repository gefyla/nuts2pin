import SwiftUI

struct CourseSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CourseViewModel
    @State private var searchText = ""
    
    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return SampleCourses.allCourses
        } else {
            return SampleCourses.allCourses.filter { course in
                course.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCourses) { course in
                Button(action: {
                    viewModel.loadCourse(course)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.name)
                            .font(.headline)
                        
                        HStack {
                            Text("\(course.holes.count) holes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("Par \(course.holes.reduce(0) { $0 + $1.par })")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Search courses")
            .navigationTitle("Select Course")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
} 