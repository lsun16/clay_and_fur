import SwiftUI
import SwiftData

struct PhotoGalleryView: View {
    let piece: Piece
    @Environment(\.modelContext) private var modelContext
    @State private var showingPhotoCapture = false
    @State private var selectedPhoto: Media?
    @State private var showingPhotoDetail = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    // Add photo button
                    Button(action: {
                        showingPhotoCapture = true
                    }) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("Add Photo")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                    
                    // Photo grid
                    ForEach(piece.media, id: \.id) { media in
                        PhotoThumbnailView(media: media) {
                            selectedPhoto = media
                            showingPhotoDetail = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingPhotoCapture) {
                PhotoCaptureView(piece: piece)
            }
            .sheet(isPresented: $showingPhotoDetail) {
                if let selectedPhoto = selectedPhoto {
                    PhotoDetailView(media: selectedPhoto, piece: piece)
                }
            }
        }
    }
}

struct PhotoThumbnailView: View {
    let media: Media
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Group {
                if let image = media.loadImage() {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(12)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        if let stage = media.stageAtCapture {
                            Text(Stage(rawValue: stage)?.displayName ?? stage)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                        Spacer()
                    }
                    .padding(6)
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PhotoDetailView: View {
    let media: Media
    let piece: Piece
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteAlert = false
    @State private var caption: String
    
    init(media: Media, piece: Piece) {
        self.media = media
        self.piece = piece
        self._caption = State(initialValue: media.caption ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Full size image
                    if let image = media.loadImage() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    
                    // Photo info
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Photo Details")
                                .font(.headline)
                            Spacer()
                        }
                        
                        if let stage = media.stageAtCapture,
                           let stageEnum = Stage(rawValue: stage) {
                            HStack {
                                Circle()
                                    .fill(stageEnum.color)
                                    .frame(width: 12, height: 12)
                                Text("Stage: \(stageEnum.displayName)")
                                    .font(.subheadline)
                            }
                        }
                        
                        Text("Taken: \(media.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Caption editing
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Caption")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Add a caption...", text: $caption, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(2...4)
                                .onChange(of: caption) { _, newValue in
                                    media.caption = newValue.isEmpty ? nil : newValue
                                }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        showingDeleteAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .alert("Delete Photo", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    deletePhoto()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This photo will be permanently deleted.")
            }
        }
    }
    
    private func deletePhoto() {
        // Delete file from storage
        let _ = PhotoManager.shared.deletePhoto(fileName: media.fileName)
        
        // Remove from piece's media array
        if let index = piece.media.firstIndex(where: { $0.id == media.id }) {
            piece.media.remove(at: index)
        }
        
        // Delete from SwiftData
        modelContext.delete(media)
        
        dismiss()
    }
}

#Preview {
    PhotoGalleryView(piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"))
        .modelContainer(for: [Piece.self, Media.self], inMemory: true)
}
