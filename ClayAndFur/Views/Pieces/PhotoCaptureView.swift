import SwiftUI
import SwiftData

struct PhotoCaptureView: View {
    @Bindable var piece: Piece
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var caption = ""
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let currentImage = selectedImage {
                    // Preview selected image
                    VStack(spacing: 16) {
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        
                        TextField("Add a caption (optional)", text: $caption, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(2...4)
                        
                        HStack(spacing: 16) {
                            Button("Retake") {
                                self.selectedImage = nil
                                showImagePicker()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Save Photo") {
                                savePhoto()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                } else {
                    // Photo capture options
                    VStack(spacing: 24) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("Add Photo to \(piece.name)")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Capture your pottery at any stage of the process")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                sourceType = .camera
                                showImagePicker()
                            }) {
                                Label("Take Photo", systemImage: "camera")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            
                            Button(action: {
                                sourceType = .photoLibrary
                                showImagePicker()
                            }) {
                                Label("Choose from Library", systemImage: "photo.on.rectangle")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Add Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
        }
    }
    
    private func showImagePicker() {
        showingImagePicker = true
    }
    
    private func savePhoto() {
        guard let image = selectedImage else { return }
        
        let _ = PhotoManager.shared.createMediaFromImage(
            image,
            for: piece,
            caption: caption.isEmpty ? nil : caption,
            stage: piece.currentStage.rawValue,
            modelContext: modelContext
        )
        
        dismiss()
    }
}

// UIImagePickerController wrapper for SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PhotoCaptureView(piece: Piece(name: "Test Bowl", clayBodyName: "Stoneware"))
        .modelContainer(for: [Piece.self, Media.self], inMemory: true)
}
