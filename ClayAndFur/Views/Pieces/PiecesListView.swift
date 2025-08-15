import SwiftUI
import SwiftData

struct PiecesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pieces: [Piece]
    @State private var searchText = ""
    @State private var showingAddPiece = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pieces, id: \.id) { piece in
                    NavigationLink(destination: PieceDetailView(piece: piece)) {
                        VStack(alignment: .leading) {
                            Text(piece.name)
                                .font(.headline)
                            Text(piece.currentStage.displayName)
                                .font(.caption)
                                .foregroundColor(piece.currentStage.color)
                        }
                    }
                }
                .onDelete(perform: deletePieces)
            }
            .navigationTitle("Pieces")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPiece = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPiece) {
                AddPieceView()
            }
        }
    }
    
    private func deletePieces(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(pieces[index])
            }
        }
    }
}

#Preview {
    PiecesListView()
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
