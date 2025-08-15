import SwiftUI
import SwiftData

struct PieceDetailView: View {
    @Bindable var piece: Piece
    @State private var showingStageSheet = false
    @State private var showingPhotoCapture = false
    @State private var showingPhotoGallery = false
    
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
                
                // Photos Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Photos")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 12) {
                            Button("Add Photo") {
                                showingPhotoCapture = true
                            }
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            
                            if !piece.media.isEmpty {
                                Button("View All") {
                                    showingPhotoGallery = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    if piece.media.isEmpty {
                        Text("No photos yet")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(piece.media.prefix(5), id: \.id) { media in
                                    Button(action: {
                                        showingPhotoGallery = true
                                    }) {
                                        Group {
                                            if let image = media.loadImage() {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } else {
                                                Image(systemName: "photo")
                                                    .font(.title2)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                                if piece.media.count > 5 {
                                    Button(action: {
                                        showingPhotoGallery = true
                                    }) {
                                        VStack {
                                            Text("+\(piece.media.count - 5)")
                                                .font(.headline)
                                            Text("more")
                                                .font(.caption)
                                        }
                                        .frame(width: 80, height: 80)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
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
                                    
                                    // Show relevant materials for each stage
                                    Group {
                                        if stageEvent.stage == .thrown, let clayBody = piece.clayBody {
                                            Text("Clay: \(clayBody.name)")
                                                .font(.caption)
                                                .foregroundColor(.orange)
                                                .fontWeight(.medium)
                                        } else if stageEvent.stage == .thrown, let clayBodyName = piece.clayBodyName {
                                            Text("Clay: \(clayBodyName)")
                                                .font(.caption)
                                                .foregroundColor(.orange)
                                                .fontWeight(.medium)
                                        }
                                        
                                        if stageEvent.stage == .glazed, let glaze = piece.glaze {
                                            Text("Glaze: \(glaze.name) (Cone \(glaze.cone))")
                                                .font(.caption)
                                                .foregroundColor(.purple)
                                                .fontWeight(.medium)
                                        }
                                        
                                        // Show if photos were taken at this stage
                                        if piece.media.contains(where: { $0.stageAtCapture == stageEvent.stage.rawValue }) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "camera.fill")
                                                    .font(.caption2)
                                                Text("Photo captured")
                                                    .font(.caption2)
                                            }
                                            .foregroundColor(.blue)
                                        }
                                    }
                                    
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
        .sheet(isPresented: $showingPhotoCapture) {
            PhotoCaptureView(piece: piece)
        }
        .sheet(isPresented: $showingPhotoGallery) {
            PhotoGalleryView(piece: piece)
        }
    }
}

#Preview {
    NavigationStack {
        PieceDetailView(piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"))
    }
    .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
