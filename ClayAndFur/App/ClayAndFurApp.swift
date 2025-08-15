import SwiftUI
import SwiftData

@main
struct ClayAndFurApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Piece.self,
            StageEvent.self,
            Glaze.self,
            RecipeLine.self,
            Firing.self,
            Media.self,
            ClayBody.self,
            FiringMethod.self
        ])
        
        do {
            // Use CloudKit for sync across devices
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Seed default data on first launch
                    DataSeeder.seedDefaultData(modelContext: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}