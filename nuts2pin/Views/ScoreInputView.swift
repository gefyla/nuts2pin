import SwiftUI

struct ScoreInputView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CourseViewModel
    let hole: Hole
    
    @State private var score: Int
    @State private var putts: Int
    @State private var fairwayHit: Bool = true
    @State private var greenInRegulation: Bool = true
    @State private var notes: String = ""
    
    init(viewModel: CourseViewModel, hole: Hole) {
        self.viewModel = viewModel
        self.hole = hole
        _score = State(initialValue: viewModel.getScore(for: hole) ?? hole.par)
        _putts = State(initialValue: viewModel.getPutts(for: hole) ?? 2)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Score")) {
                    Stepper("Score: \(score)", value: $score, in: 1...20)
                    Stepper("Putts: \(putts)", value: $putts, in: 0...10)
                }
                
                Section(header: Text("Statistics")) {
                    Toggle("Fairway Hit", isOn: $fairwayHit)
                    Toggle("Green in Regulation", isOn: $greenInRegulation)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Hole \(hole.number)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateScore(for: hole, score: score)
                        viewModel.updatePutts(for: hole, putts: putts)
                        viewModel.updateFairwayHit(for: hole, hit: fairwayHit)
                        viewModel.updateGreenInRegulation(for: hole, hit: greenInRegulation)
                        viewModel.updateNotes(for: hole, notes: notes)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ScoreInputView(
        viewModel: CourseViewModel(),
        hole: Hole(
            number: 1,
            par: 4,
            distance: 380,
            teeLocation: Coordinate(latitude: 36.5683, longitude: -121.9497),
            pinLocation: Coordinate(latitude: 36.5685, longitude: -121.9490),
            hazards: []
        )
    )
} 