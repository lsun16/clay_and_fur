import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pieces: [Piece]
    @State private var showingAddPiece = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(Stage.allCases) { stage in
                        StageColumnView(
                            stage: stage,
                            pieces: pieces.filter { $0.currentStage == stage },
                            allPieces: pieces
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPiece = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPiece) {
                AddPieceView()
            }
        }
    }
}

struct StageColumnView: View {
    let stage: Stage
    let pieces: [Piece]
    let allPieces: [Piece]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Column Header
            HStack {
                Image(systemName: stage.systemImage)
                    .foregroundColor(stage.color)
                Text(stage.displayName)
                    .font(.headline)
                    .foregroundColor(stage.color)
                Spacer()
                Text("\(pieces.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(stage.color.opacity(0.2))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(stage.color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Pieces in this stage
            LazyVStack(spacing: 8) {
                                    ForEach(pieces, id: \.id) { piece in
                        NavigationLink(destination: PieceDetailView(piece: piece)) {
                            PieceCardView(piece: piece)
                        }
                        .buttonStyle(PlainButtonStyle())
                        // TODO: Re-enable drag and drop once Transferable conformance is resolved
                        // .draggable(piece) {
                        //     PieceCardView(piece: piece)
                        //         .opacity(0.8)
                        // }
                    }
            }
            
            Spacer()
        }
        .frame(width: 200)
        .padding(.vertical, 8)
        // TODO: Re-enable drop destination once drag and drop is working
        // .dropDestination(for: String.self) { droppedIDs, location in
        //     for idString in droppedIDs {
        //         if let uuid = UUID(uuidString: idString),
        //            let piece = allPieces.first(where: { $0.id == uuid }) {
        //             moveToStage(piece: piece, newStage: stage)
        //         }
        //     }
        //     return true
        // }
    }
    
    private func moveToStage(piece: Piece, newStage: Stage) {
        // Only add stage event if it's different from current stage
        guard piece.currentStage != newStage else { return }
        
        // Add the new stage event with current timestamp
        piece.addStageEvent(newStage, date: Date(), note: "Moved via drag and drop")
        
        // Save the context
        do {
            try modelContext.save()
        } catch {
            print("Failed to save stage change: \(error)")
        }
    }
}

struct PieceCardView: View {
    let piece: Piece
    
    var latestPhoto: UIImage? {
        // Get the most recent photo
        let sortedMedia = piece.media.sorted { $0.createdAt > $1.createdAt }
        return sortedMedia.first?.loadImage()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Photo thumbnail section
            if let photo = latestPhoto {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .clipped()
                    .overlay(
                        // Stage indicator overlay
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(piece.currentStage.color)
                                    .frame(width: 12, height: 12)
                                    .shadow(color: .black.opacity(0.3), radius: 1)
                            }
                            Spacer()
                        }
                        .padding(8)
                    )
            } else {
                // Placeholder when no photo
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            piece.currentStage.color.opacity(0.3),
                            piece.currentStage.color.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 80)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundColor(piece.currentStage.color.opacity(0.6))
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(piece.currentStage.color)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        .padding(8)
                    )
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 6) {
                Text(piece.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                if let clayBodyName = piece.clayBodyName {
                    Text(clayBodyName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else if let clayBody = piece.clayBody {
                    Text(clayBody.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                if let glaze = piece.glaze {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .font(.caption2)
                            .foregroundColor(.purple)
                        Text(glaze.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                HStack {
                    Text(piece.createdAt, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    if piece.media.count > 1 {
                        HStack(spacing: 2) {
                            Image(systemName: "photo.stack")
                                .font(.caption2)
                            Text("\(piece.media.count)")
                                .font(.caption2)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
