import SwiftUI
import SwiftData

struct AddGlazeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var cone = ""
    @State private var finish = ""
    @State private var recipeLines: [RecipeLineInput] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Glaze Name", text: $name)
                    TextField("Cone (e.g., 04, 6, 10)", text: $cone)
                    TextField("Finish (e.g., Glossy, Matte, Satin)", text: $finish)
                }
                
                Section("Recipe") {
                    ForEach(recipeLines.indices, id: \.self) { index in
                        HStack {
                            TextField("Ingredient", text: $recipeLines[index].ingredient)
                            TextField("Percentage", value: $recipeLines[index].percentage, format: .number)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                            Button(action: {
                                recipeLines.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button(action: {
                        recipeLines.append(RecipeLineInput())
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Ingredient")
                        }
                    }
                }
            }
            .navigationTitle("New Glaze")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGlaze()
                    }
                    .disabled(name.isEmpty || cone.isEmpty || finish.isEmpty)
                }
            }
        }
    }
    
    private func saveGlaze() {
        let newGlaze = Glaze(name: name, cone: cone, finish: finish)
        
        // Add recipe lines
        for recipeInput in recipeLines where !recipeInput.ingredient.isEmpty {
            let recipeLine = RecipeLine(ingredient: recipeInput.ingredient, percentage: recipeInput.percentage)
            newGlaze.recipe.append(recipeLine)
        }
        
        modelContext.insert(newGlaze)
        dismiss()
    }
}

struct RecipeLineInput {
    var ingredient: String = ""
    var percentage: Double = 0.0
}

#Preview {
    AddGlazeView()
        .modelContainer(for: [Glaze.self], inMemory: true)
}
