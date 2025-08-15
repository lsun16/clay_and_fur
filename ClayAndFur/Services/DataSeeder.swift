import Foundation
import SwiftData

class DataSeeder {
    static func seedDefaultData(modelContext: ModelContext) {
        // Check if data already exists
        let clayBodies = try? modelContext.fetch(FetchDescriptor<ClayBody>())
        let glazes = try? modelContext.fetch(FetchDescriptor<Glaze>())
        let firingMethods = try? modelContext.fetch(FetchDescriptor<FiringMethod>())
        
        // Seed Clay Bodies if none exist
        if clayBodies?.isEmpty == true {
            let defaultClayBodies = [
                ClayBody(name: "Stoneware", description: "High-fire clay body", cone: "10", color: "Gray"),
                ClayBody(name: "Porcelain", description: "White high-fire clay", cone: "10", color: "White"),
                ClayBody(name: "Earthenware", description: "Low-fire clay body", cone: "04", color: "Red/Brown"),
                ClayBody(name: "B-Mix", description: "Popular cone 10 clay", cone: "10", color: "Buff"),
                ClayBody(name: "Raku Clay", description: "Clay for raku firing", cone: "010", color: "Groggy")
            ]
            
            for clayBody in defaultClayBodies {
                modelContext.insert(clayBody)
            }
        }
        
        // Seed Glazes if none exist
        if glazes?.isEmpty == true {
            let defaultGlazes = [
                Glaze(name: "Clear", cone: "10", finish: "Glossy"),
                Glaze(name: "Celadon", cone: "10", finish: "Satin"),
                Glaze(name: "Tenmoku", cone: "10", finish: "Glossy"),
                Glaze(name: "White Satin", cone: "10", finish: "Satin"),
                Glaze(name: "Blue Green", cone: "10", finish: "Glossy"),
                Glaze(name: "Copper Red", cone: "10", finish: "Glossy"),
                Glaze(name: "Ash Glaze", cone: "10", finish: "Matte")
            ]
            
            for glaze in defaultGlazes {
                modelContext.insert(glaze)
            }
        }
        
        // Seed Firing Methods if none exist
        if firingMethods?.isEmpty == true {
            let defaultFiringMethods = [
                FiringMethod(name: "Electric Bisque", type: "Bisque", atmosphere: "Oxidation", defaultCone: "04", description: "Standard electric bisque firing"),
                FiringMethod(name: "Electric Glaze", type: "Glaze", atmosphere: "Oxidation", defaultCone: "10", description: "Standard electric glaze firing"),
                FiringMethod(name: "Gas Reduction", type: "Glaze", atmosphere: "Reduction", defaultCone: "10", description: "Gas kiln reduction firing"),
                FiringMethod(name: "Raku", type: "Glaze", atmosphere: "Reduction", defaultCone: "010", description: "Raku firing process"),
                FiringMethod(name: "Wood Firing", type: "Glaze", atmosphere: "Reduction", defaultCone: "12", description: "Traditional wood firing"),
                FiringMethod(name: "Soda Firing", type: "Glaze", atmosphere: "Reduction", defaultCone: "10", description: "Soda ash atmospheric firing")
            ]
            
            for method in defaultFiringMethods {
                modelContext.insert(method)
            }
        }
        
        // Save all the seeded data
        do {
            try modelContext.save()
        } catch {
            print("Failed to seed default data: \(error)")
        }
    }
}
