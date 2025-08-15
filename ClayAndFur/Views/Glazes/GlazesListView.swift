import SwiftUI
import SwiftData

struct GlazesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Glaze.name) private var glazes: [Glaze]
    @State private var showingAddGlaze = false
    @State private var searchText = ""
    
    var filteredGlazes: [Glaze] {
        if searchText.isEmpty {
            return glazes
        } else {
            return glazes.filter { glaze in
                glaze.name.localizedCaseInsensitiveContains(searchText) ||
                glaze.finish.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredGlazes) { glaze in
                    NavigationLink(destination: GlazeDetailView(glaze: glaze)) {
                        GlazeRowView(glaze: glaze)
                    }
                }
                .onDelete(perform: deleteGlazes)
            }
            .searchable(text: $searchText, prompt: "Search glazes...")
            .navigationTitle("Glazes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddGlaze = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGlaze) {
                AddGlazeView()
            }
        }
    }
    
    private func deleteGlazes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredGlazes[index])
            }
        }
    }
}

struct GlazeRowView: View {
    let glaze: Glaze
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(glaze.name)
                    .font(.headline)
                Spacer()
                Text("Cone \(glaze.cone)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Text(glaze.finish)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !glaze.recipe.isEmpty {
                Text("\(glaze.recipe.count) ingredients")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(glaze.createdAt, style: .date)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    GlazesListView()
        .modelContainer(for: [Glaze.self], inMemory: true)
}