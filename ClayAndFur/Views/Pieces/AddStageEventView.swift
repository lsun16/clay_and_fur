import SwiftUI
import SwiftData

struct AddStageEventView: View {
    @Bindable var piece: Piece
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var clayBodies: [ClayBody]
    @Query private var glazes: [Glaze]
    @Query private var firingMethods: [FiringMethod]
    
    @State private var selectedStage: Stage
    @State private var date = Date()
    @State private var note = ""
    
    // Contextual selections
    @State private var selectedClayBody: ClayBody?
    @State private var selectedGlaze: Glaze?
    @State private var selectedFiringMethod: FiringMethod?
    
    init(piece: Piece) {
        self.piece = piece
        // Default to the next stage in the sequence
        _selectedStage = State(initialValue: piece.currentStage.nextStage ?? piece.currentStage)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Current Stage Timeline
                Section("Current Progress") {
                    StageTimelineView(piece: piece)
                }
                
                Section("New Stage Information") {
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
                    Section("Clay Body Selection") {
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
                    Section("Glaze Selection") {
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
                    Section("Firing Method Selection") {
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
        // Update piece relationships based on stage
        if selectedStage == .thrown, let clayBody = selectedClayBody {
            piece.clayBody = clayBody
            piece.clayBodyName = clayBody.name // Keep for backward compatibility
        } else if selectedStage == .glazed, let glaze = selectedGlaze {
            piece.glaze = glaze
        }
        
        piece.addStageEvent(
            selectedStage,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        dismiss()
    }
}

struct StageTimelineView: View {
    let piece: Piece
    
    var sortedStageEvents: [StageEvent] {
        piece.stages.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Stage: \(piece.currentStage.displayName)")
                .font(.headline)
                .foregroundColor(piece.currentStage.color)
            
            if !sortedStageEvents.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(sortedStageEvents.suffix(3), id: \.id) { stageEvent in
                        HStack {
                            Circle()
                                .fill(stageEvent.stage.color)
                                .frame(width: 8, height: 8)
                            Text(stageEvent.stage.displayName)
                                .font(.caption)
                            Spacer()
                            Text(stageEvent.date, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if sortedStageEvents.count > 3 {
                        Text("... and \(sortedStageEvents.count - 3) more")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.leading, 16)
                    }
                }
            } else {
                Text("No stage events yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    AddStageEventView(piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"))
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self, ClayBody.self, FiringMethod.self], inMemory: true)
}