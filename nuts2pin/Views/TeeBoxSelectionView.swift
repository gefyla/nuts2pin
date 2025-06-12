import SwiftUI

struct TeeBoxSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTeeBox: TeeBox
    let teeBoxes: [TeeBox]
    
    var body: some View {
        NavigationView {
            List(teeBoxes, id: \.self) { teeBox in
                Button(action: {
                    selectedTeeBox = teeBox
                    dismiss()
                }) {
                    HStack {
                        Text(teeBox.rawValue.capitalized)
                            .foregroundColor(.primary)
                        Spacer()
                        if teeBox == selectedTeeBox {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Tee Box")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TeeBoxSelectionView(
        selectedTeeBox: .constant(.blue),
        teeBoxes: [.black, .blue, .white, .gold, .red]
    )
} 