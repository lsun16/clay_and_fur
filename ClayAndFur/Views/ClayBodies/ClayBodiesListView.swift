import SwiftUI
import SwiftData

struct ClayBodiesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ClayBody.name) private var clayBodies: [ClayBody]
    @State private var showingAddClayBody = false
    @State private var searchText = ""
    
    var filteredClayBodies: [ClayBody] {
        if searchText.isEmpty {
            return clayBodies
        } else {
            return clayBodies.filter { clayBody in
                clayBody.name.localizedCaseInsensitiveContains(searchText) ||
                (clayBody.clayDescription?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredClayBodies) { clayBody in
                    NavigationLink(destination: ClayBodyDetailView(clayBody: clayBody)) {
                        ClayBodyRowView(clayBody: clayBody)
                    }
                }
                .onDelete(perform: deleteClayBodies)
            }
            .searchable(text: $searchText, prompt: "Search clay bodies...")
            .navigationTitle("Clay Bodies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddClayBody = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddClayBody) {
                AddClayBodyView()
            }
        }
    }
    
    private func deleteClayBodies(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredClayBodies[index])
            }
        }
    }
}

struct ClayBodyRowView: View {
    let clayBody: ClayBody
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(clayBody.name)
                    .font(.headline)
                Spacer()
                if let cone = clayBody.cone {
                    Text("Cone \(cone)")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            if let description = clayBody.clayDescription {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                if let color = clayBody.color {
                    Label(color, systemImage: "paintpalette")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(clayBody.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ClayBodiesListView()
        .modelContainer(for: [ClayBody.self], inMemory: true)
}
