import SwiftUI
import SwiftData

struct EditClayBodyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let clayBody: ClayBody
    
    @State private var name: String
    @State private var clayDescription: String
    @State private var cone: String
    @State private var color: String
    
    init(clayBody: ClayBody) {
        self.clayBody = clayBody
        self._name = State(initialValue: clayBody.name)
        self._clayDescription = State(initialValue: clayBody.clayDescription ?? "")
        self._cone = State(initialValue: clayBody.cone ?? "")
        self._color = State(initialValue: clayBody.color ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Clay Body Name", text: $name)
                    TextField("Description", text: $clayDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Properties") {
                    TextField("Cone (e.g., 04, 6, 10)", text: $cone)
                    TextField("Color (e.g., White, Buff, Red)", text: $color)
                }
            }
            .navigationTitle("Edit Clay Body")
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
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        clayBody.name = name
        clayBody.clayDescription = clayDescription.isEmpty ? nil : clayDescription
        clayBody.cone = cone.isEmpty ? nil : cone
        clayBody.color = color.isEmpty ? nil : color
        
        dismiss()
    }
}

#Preview {
    EditClayBodyView(clayBody: ClayBody(name: "B-Mix", clayDescription: "Smooth throwing clay", cone: "6", color: "Buff"))
        .modelContainer(for: [ClayBody.self], inMemory: true)
}
