import SwiftUI
import SwiftData

struct GlazeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let glaze: Glaze
    @State private var showingEditView = false
    
    @Query private var pieces: [Piece]
    
    var piecesUsingThisGlaze: [Piece] {
        pieces.filter { piece in
            piece.glaze?.id == glaze.id
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(glaze.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("Cone \(glaze.cone)")
                            .font(.title3)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(8)
                        
                        Text(glaze.finish)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Recipe
                if !glaze.recipe.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recipe")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            ForEach(glaze.recipe, id: \.ingredient) { recipeLine in
                                HStack {
                                    Text(recipeLine.ingredient)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("\(recipeLine.percentage, specifier: "%.1f")%")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray6))
                                .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Properties
                VStack(alignment: .leading, spacing: 12) {
                    Text("Properties")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        PropertyRow(label: "Firing Cone", value: glaze.cone, icon: "flame")
                        PropertyRow(label: "Finish", value: glaze.finish, icon: "sparkles")
                        PropertyRow(
                            label: "Created",
                            value: glaze.createdAt.formatted(date: .abbreviated, time: .omitted),
                            icon: "calendar"
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Pieces using this glaze
                if !piecesUsingThisGlaze.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pieces Using This Glaze (\(piecesUsingThisGlaze.count))")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(piecesUsingThisGlaze) { piece in
                                NavigationLink(destination: PieceDetailView(piece: piece)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(piece.name)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text("Stage: \(piece.currentStage.displayName)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditView = true
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditGlazeView(glaze: glaze)
        }
    }
}

#Preview {
    NavigationStack {
        GlazeDetailView(glaze: Glaze(name: "Celadon", cone: "6", finish: "Glossy"))
    }
    .modelContainer(for: [Glaze.self, Piece.self], inMemory: true)
}
