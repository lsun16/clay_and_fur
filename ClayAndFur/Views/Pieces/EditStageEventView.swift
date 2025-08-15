import SwiftUI
import SwiftData

struct EditStageEventView: View {
    @Bindable var piece: Piece
    let stageEvent: StageEvent
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var clayBodies: [ClayBody]
    @Query private var glazes: [Glaze]
    @Query private var firingMethods: [FiringMethod]
    
    @State private var selectedStage: Stage
    @State private var date: Date
    @State private var note: String
    
    // Contextual selections
    @State private var selectedClayBody: ClayBody?
    @State private var selectedGlaze: Glaze?
    @State private var selectedFiringMethod: FiringMethod?
    
    init(piece: Piece, stageEvent: StageEvent) {
        self.piece = piece
        self.stageEvent = stageEvent
        self._selectedStage = State(initialValue: stageEvent.stage)
        self._date = State(initialValue: stageEvent.date)
        self._note = State(initialValue: stageEvent.note ?? "")
        
        // Initialize contextual selections based on current piece state
        self._selectedClayBody = State(initialValue: piece.clayBody)
        self._selectedGlaze = State(initialValue: piece.glaze)
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
                
                // Contextual selections based on stage
                if selectedStage == .thrown {
                    Section("Clay Body") {
                        Menu {
                            ForEach(clayBodies) { clayBody in
                                Button(clayBody.name) {
                                    selectedClayBody = clayBody
                                }
                            }
                        } label: {
                            HStack {
                                Text("Clay Body")
                                Spacer()
                                Text(selectedClayBody?.name ?? "Select Clay Body")
                                    .foregroundColor(selectedClayBody == nil ? .secondary : .primary)
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                } else if selectedStage == .glazed {
                    Section("Glaze") {
                        Menu {
                            ForEach(glazes) { glaze in
                                Button("\(glaze.name) (Cone \(glaze.cone))") {
                                    selectedGlaze = glaze
                                }
                            }
                        } label: {
                            HStack {
                                Text("Glaze")
                                Spacer()
                                Text(selectedGlaze?.name ?? "Select Glaze")
                                    .foregroundColor(selectedGlaze == nil ? .secondary : .primary)
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                } else if selectedStage == .glazeFired {
                    Section("Firing Method") {
                        Menu {
                            ForEach(firingMethods) { firingMethod in
                                Button("\(firingMethod.name) (\(firingMethod.type))") {
                                    selectedFiringMethod = firingMethod
                                }
                            }
                        } label: {
                            HStack {
                                Text("Firing Method")
                                Spacer()
                                Text(selectedFiringMethod?.name ?? "Select Firing Method")
                                    .foregroundColor(selectedFiringMethod == nil ? .secondary : .primary)
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Stage notes (optional)", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Edit Stage Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        // Update the stage event
        stageEvent.stage = selectedStage
        stageEvent.date = date
        stageEvent.note = note.isEmpty ? nil : note
        
        // Update piece relationships based on stage
        if selectedStage == .thrown, let clayBody = selectedClayBody {
            piece.clayBody = clayBody
            piece.clayBodyName = clayBody.name
        } else if selectedStage == .glazed, let glaze = selectedGlaze {
            piece.glaze = glaze
        }
        
        piece.updatedAt = Date()
        
        dismiss()
    }
}

#Preview {
    EditStageEventView(
        piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"),
        stageEvent: StageEvent(stage: .thrown, date: Date(), note: "Initial throwing")
    )
    .modelContainer(for: [Piece.self, StageEvent.self, ClayBody.self, Glaze.self, FiringMethod.self], inMemory: true)
}
