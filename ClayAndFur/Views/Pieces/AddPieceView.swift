import SwiftUI
import SwiftData

struct AddPieceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var clayBodies: [ClayBody]
    @Query private var glazes: [Glaze]
    @Query private var firingMethods: [FiringMethod]
    
    @State private var name = ""
    @State private var selectedClayBody: ClayBody?
    @State private var selectedGlaze: Glaze?
    @State private var selectedFiringMethod: FiringMethod?
    @State private var notes = ""
    @State private var showingNewClayBody = false
    @State private var showingNewGlaze = false
    @State private var showingNewFiringMethod = false
    
    // Photo capture states
    @State private var showingCamera = false
    @State private var showingPhotoLibrary = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Piece Name", text: $name)
                    
                    // Clay Body Selector
                    HStack {
                        Text("Clay Body")
                        Spacer()
                        Menu {
                            Button("None") {
                                selectedClayBody = nil
                            }
                            ForEach(clayBodies, id: \.id) { clayBody in
                                Button(clayBody.name) {
                                    selectedClayBody = clayBody
                                }
                            }
                            Divider()
                            Button("Add New Clay Body...") {
                                showingNewClayBody = true
                            }
                        } label: {
                            Text(selectedClayBody?.name ?? "Select Clay Body")
                                .foregroundColor(selectedClayBody == nil ? .secondary : .primary)
                        }
                    }
                    
                    // Glaze Selector
                    HStack {
                        Text("Glaze")
                        Spacer()
                        Menu {
                            Button("None") {
                                selectedGlaze = nil
                            }
                            ForEach(glazes, id: \.id) { glaze in
                                Button(glaze.name) {
                                    selectedGlaze = glaze
                                }
                            }
                            Divider()
                            Button("Add New Glaze...") {
                                showingNewGlaze = true
                            }
                        } label: {
                            Text(selectedGlaze?.name ?? "Select Glaze")
                                .foregroundColor(selectedGlaze == nil ? .secondary : .primary)
                        }
                    }
                    
                    // Firing Method Selector
                    HStack {
                        Text("Firing Method")
                        Spacer()
                        Menu {
                            Button("None") {
                                selectedFiringMethod = nil
                            }
                            ForEach(firingMethods, id: \.id) { method in
                                Button(method.name) {
                                    selectedFiringMethod = method
                                }
                            }
                            Divider()
                            Button("Add New Method...") {
                                showingNewFiringMethod = true
                            }
                        } label: {
                            Text(selectedFiringMethod?.name ?? "Select Firing Method")
                                .foregroundColor(selectedFiringMethod == nil ? .secondary : .primary)
                        }
                    }
                }
                
                Section("Photo (Optional)") {
                    if let currentImage = capturedImage {
                        HStack {
                            Image(uiImage: currentImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading) {
                                Text("Photo captured")
                                    .font(.subheadline)
                                Button("Change Photo") {
                                    showingCamera = true
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            Button("Remove") {
                                self.capturedImage = nil
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    } else {
                        HStack {
                            Button(action: {
                                showingCamera = true
                            }) {
                                Label("Take Photo", systemImage: "camera")
                            }
                            .buttonStyle(.bordered)
                            
                            Button(action: {
                                showingPhotoLibrary = true
                            }) {
                                Label("Choose Photo", systemImage: "photo")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Piece")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePiece()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(selectedImage: $capturedImage, sourceType: .camera)
            }
            .sheet(isPresented: $showingPhotoLibrary) {
                ImagePicker(selectedImage: $capturedImage, sourceType: .photoLibrary)
            }
        }
    }
    
    private func savePiece() {
        let piece = Piece(
            name: name,
            clayBodyName: selectedClayBody?.name,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Set relationships
        piece.clayBody = selectedClayBody
        piece.glaze = selectedGlaze
        
        modelContext.insert(piece)
        
        // Add initial "thrown" stage event
        piece.addStageEvent(.thrown, date: Date(), note: "Piece created")
        
        // Save the photo if one was captured
        if let capturedImage = capturedImage {
            let _ = PhotoManager.shared.createMediaFromImage(
                capturedImage,
                for: piece,
                caption: "Initial photo",
                stage: Stage.thrown.rawValue,
                modelContext: modelContext
            )
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save piece: \(error)")
        }
    }
}

#Preview {
    AddPieceView()
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self, ClayBody.self, FiringMethod.self])
}
