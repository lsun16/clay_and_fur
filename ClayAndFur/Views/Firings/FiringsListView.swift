import SwiftUI
import SwiftData

struct FiringsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var firings: [Firing]
    
    var body: some View {
        NavigationStack {
            List {
                if firings.isEmpty {
                    Text("No firings yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(firings, id: \.id) { firing in
                        VStack(alignment: .leading) {
                            Text(firing.kilnName)
                                .font(.headline)
                            Text("\(firing.type) • Cone \(firing.cone)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Firings")
        }
    }
}

#Preview {
    FiringsListView()
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
