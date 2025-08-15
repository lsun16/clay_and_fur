import SwiftUI
import SwiftData

struct StageEventDetailView: View {
    @Bindable var piece: Piece
    let stageEvent: StageEvent
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var stagePhotos: [Media] {
        piece.media.filter { $0.stageAtCapture == stageEvent.stage.rawValue }
            .sorted { $0.createdAt < $1.createdAt }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(stageEvent.stage.color)
                            .frame(width: 20, height: 20)
                        Text(stageEvent.stage.displayName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text(stageEvent.date.formatted(date: .complete, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Context Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Stage Context")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        if stageEvent.stage == .thrown {
                            if let clayBody = piece.clayBody {
                                ContextRow(
                                    icon: "cube.fill",
                                    label: "Clay Body",
                                    value: clayBody.name,
                                    detail: clayBody.clayDescription,
                                    color: .orange
                                )
                            } else if let clayBodyName = piece.clayBodyName {
                                ContextRow(
                                    icon: "cube.fill",
                                    label: "Clay Body",
                                    value: clayBodyName,
                                    detail: nil,
                                    color: .orange
                                )
                            }
                        }
                        
                        if stageEvent.stage == .glazed, let glaze = piece.glaze {
                            ContextRow(
                                icon: "paintbrush.fill",
                                label: "Glaze",
                                value: glaze.name,
                                detail: "Cone \(glaze.cone) • \(glaze.finish)",
                                color: .purple
                            )
                        }
                        
                        if stageEvent.stage == .bisque || stageEvent.stage == .glazeFired {
                            ContextRow(
                                icon: "flame.fill",
                                label: "Firing Stage",
                                value: stageEvent.stage == .bisque ? "Bisque Firing" : "Glaze Firing",
                                detail: "High temperature firing",
                                color: .red
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Notes
                if let note = stageEvent.note, !note.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text(note)
                            .font(.body)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                
                // Photos from this stage
                if !stagePhotos.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Photos from this Stage (\(stagePhotos.count))")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(stagePhotos, id: \.id) { media in
                                NavigationLink(destination: PhotoDetailView(media: media, piece: piece)) {
                                    Group {
                                        if let image = media.loadImage() {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } else {
                                            Rectangle()
                                                .fill(Color(.systemGray5))
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.gray)
                                                )
                                        }
                                    }
                                    .frame(height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Timeline Position
                VStack(alignment: .leading, spacing: 12) {
                    Text("Timeline Position")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        let sortedEvents = piece.stages.sorted { $0.date < $1.date }
                        if let currentIndex = sortedEvents.firstIndex(where: { $0.id == stageEvent.id }) {
                            HStack {
                                Text("Stage \(currentIndex + 1) of \(sortedEvents.count)")
                                    .font(.subheadline)
                                Spacer()
                                if currentIndex > 0 {
                                    Text("Previous: \(sortedEvents[currentIndex - 1].stage.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            if currentIndex < sortedEvents.count - 1 {
                                HStack {
                                    Spacer()
                                    Text("Next: \(sortedEvents[currentIndex + 1].stage.displayName)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit Stage Event") {
                        showingEditView = true
                    }
                    Button("Delete Stage Event", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditStageEventView(piece: piece, stageEvent: stageEvent)
        }
        .alert("Delete Stage Event", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteStageEvent()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This stage event will be permanently deleted. This cannot be undone.")
        }
    }
    
    private func deleteStageEvent() {
        if let index = piece.stages.firstIndex(where: { $0.id == stageEvent.id }) {
            piece.stages.remove(at: index)
        }
        modelContext.delete(stageEvent)
        dismiss()
    }
}

struct ContextRow: View {
    let icon: String
    let label: String
    let value: String
    let detail: String?
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if let detail = detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        StageEventDetailView(
            piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"),
            stageEvent: StageEvent(stage: .thrown, date: Date(), note: "Initial throwing")
        )
    }
    .modelContainer(for: [Piece.self, StageEvent.self, Media.self], inMemory: true)
}
