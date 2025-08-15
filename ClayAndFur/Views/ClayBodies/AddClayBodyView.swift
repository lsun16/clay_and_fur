import SwiftUI
import SwiftData

struct AddClayBodyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var clayDescription = ""
    @State private var cone = ""
    @State private var color = ""
    
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
            .navigationTitle("New Clay Body")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveClayBody()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveClayBody() {
        let newClayBody = ClayBody(
            name: name,
            clayDescription: clayDescription.isEmpty ? nil : clayDescription,
            cone: cone.isEmpty ? nil : cone,
            color: color.isEmpty ? nil : color
        )
        
        modelContext.insert(newClayBody)
        dismiss()
    }
}

#Preview {
    AddClayBodyView()
        .modelContainer(for: [ClayBody.self], inMemory: true)
}
