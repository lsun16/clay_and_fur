import SwiftUI
import SwiftData

struct GlazesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var glazes: [Glaze]
    
    var body: some View {
        NavigationStack {
            List {
                if glazes.isEmpty {
                    Text("No glazes yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(glazes, id: \.id) { glaze in
                        VStack(alignment: .leading) {
                            Text(glaze.name)
                                .font(.headline)
                            Text("Cone \(glaze.cone) • \(glaze.finish)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Glazes")
        }
    }
}

#Preview {
    GlazesListView()
        .modelContainer(for: [Piece.self, StageEvent.self, Glaze.self, RecipeLine.self, Firing.self, Media.self])
}
