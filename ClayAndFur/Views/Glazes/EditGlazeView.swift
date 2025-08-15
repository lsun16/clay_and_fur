import SwiftUI
import SwiftData

struct EditGlazeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let glaze: Glaze
    
    @State private var name: String
    @State private var cone: String
    @State private var finish: String
    @State private var recipeLines: [RecipeLineInput]
    
    init(glaze: Glaze) {
        self.glaze = glaze
        self._name = State(initialValue: glaze.name)
        self._cone = State(initialValue: glaze.cone)
        self._finish = State(initialValue: glaze.finish)
        self._recipeLines = State(initialValue: glaze.recipe.map { 
            RecipeLineInput(ingredient: $0.ingredient, percentage: $0.percentage)
        })
    }
    
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
            .navigationTitle("Edit Glaze")
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
                    .disabled(name.isEmpty || cone.isEmpty || finish.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        glaze.name = name
        glaze.cone = cone
        glaze.finish = finish
        
        // Clear existing recipe and add updated ones
        glaze.recipe.removeAll()
        for recipeInput in recipeLines where !recipeInput.ingredient.isEmpty {
            let recipeLine = RecipeLine(ingredient: recipeInput.ingredient, percentage: recipeInput.percentage)
            glaze.recipe.append(recipeLine)
        }
        
        dismiss()
    }
}

#Preview {
    EditGlazeView(glaze: Glaze(name: "Celadon", cone: "6", finish: "Glossy"))
        .modelContainer(for: [Glaze.self], inMemory: true)
}
