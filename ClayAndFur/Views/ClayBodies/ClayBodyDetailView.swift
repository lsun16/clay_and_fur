import SwiftUI
import SwiftData

struct ClayBodyDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let clayBody: ClayBody
    @State private var showingEditView = false
    
    @Query private var pieces: [Piece]
    
    var piecesUsingThisClayBody: [Piece] {
        pieces.filter { piece in
            piece.clayBody?.id == clayBody.id || piece.clayBodyName == clayBody.name
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(clayBody.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let description = clayBody.clayDescription {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Properties
                VStack(alignment: .leading, spacing: 12) {
                    Text("Properties")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        if let cone = clayBody.cone {
                            PropertyRow(label: "Firing Cone", value: cone, icon: "flame")
                        }
                        
                        if let color = clayBody.color {
                            PropertyRow(label: "Color", value: color, icon: "paintpalette")
                        }
                        
                        PropertyRow(
                            label: "Created",
                            value: clayBody.createdAt.formatted(date: .abbreviated, time: .omitted),
                            icon: "calendar"
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Pieces using this clay body
                if !piecesUsingThisClayBody.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pieces Using This Clay Body (\(piecesUsingThisClayBody.count))")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(piecesUsingThisClayBody) { piece in
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
            EditClayBodyView(clayBody: clayBody)
        }
    }
}

struct PropertyRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        ClayBodyDetailView(clayBody: ClayBody(name: "B-Mix", clayDescription: "Smooth throwing clay", cone: "6", color: "Buff"))
    }
    .modelContainer(for: [ClayBody.self, Piece.self], inMemory: true)
}
