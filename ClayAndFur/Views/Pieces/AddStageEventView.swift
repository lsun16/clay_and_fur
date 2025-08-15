import SwiftUI
import SwiftData

struct AddStageEventView: View {
    @Bindable var piece: Piece
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedStage: Stage
    @State private var date = Date()
    @State private var note = ""
    
    init(piece: Piece) {
        self.piece = piece
        // Default to the next stage in the sequence
        _selectedStage = State(initialValue: piece.currentStage.nextStage ?? piece.currentStage)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Stage Information") {
                    Picker("Stage", selection: $selectedStage) {
                        ForEach(Stage.allCases) { stage in
                            HStack {
                                Circle()
                                    .fill(stage.color)
                                    .frame(width: 12, height: 12)
                                Text(stage.displayName)
                            }
                            .tag(stage)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Notes") {
                    TextField("Stage notes (optional)", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Add Stage Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveStageEvent()
                    }
                }
            }
        }
    }
    
    private func saveStageEvent() {
        piece.addStageEvent(
            selectedStage,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        dismiss()
    }
}

#Preview {
    AddStageEventView(piece: Piece(name: "Test Bowl", clayBody: "Stoneware"))
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
