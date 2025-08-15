import SwiftUI
import SwiftData

struct PieceDetailView: View {
    @Bindable var piece: Piece
    @State private var showingStageSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(piece.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(piece.currentStage.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(piece.currentStage.color.opacity(0.2))
                            .foregroundColor(piece.currentStage.color)
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                // Details
                if let clayBodyName = piece.clayBodyName ?? piece.clayBody?.name {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Clay Body")
                            .font(.headline)
                        Text(clayBodyName)
                            .font(.body)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                
                // Stage Timeline
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Stage Timeline")
                            .font(.headline)
                        Spacer()
                        Button("Add Stage") {
                            showingStageSheet = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    
                    LazyVStack(spacing: 12) {
                        ForEach(piece.stages.sorted(by: { $0.date > $1.date }), id: \.id) { stageEvent in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(stageEvent.stage.color)
                                    .frame(width: 12, height: 12)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(stageEvent.stage.displayName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text(stageEvent.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    if let note = stageEvent.note, !note.isEmpty {
                                        Text(note)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                // Notes
                if let notes = piece.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingStageSheet) {
            AddStageEventView(piece: piece)
        }
    }
}

#Preview {
    NavigationStack {
        PieceDetailView(piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"))
    }
    .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
