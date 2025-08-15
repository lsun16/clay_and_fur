import Foundation
import SwiftData

@Model
final class Glaze {
    @Attribute(.unique) var id: UUID
    var name: String
    var cone: String
    var finish: String
    var notes: String?
    var createdAt: Date
    var updatedAt: Date
    
    // Relationships
    @Relationship(deleteRule: .cascade) var recipe: [RecipeLine] = []
    @Relationship(deleteRule: .nullify) var pieces: [Piece] = []
    @Relationship(deleteRule: .cascade) var media: [Media] = []
    
    init(name: String, cone: String, finish: String, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.cone = cone
        self.finish = finish
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    func addRecipeLine(ingredient: String, percentage: Double) {
        let recipeLine = RecipeLine(ingredient: ingredient, percentage: percentage)
        recipe.append(recipeLine)
        updatedAt = Date()
    }
    
    func updateDetails(
        name: String? = nil,
        cone: String? = nil,
        finish: String? = nil,
        notes: String? = nil
    ) {
        if let name = name { self.name = name }
        if let cone = cone { self.cone = cone }
        if let finish = finish { self.finish = finish }
        if let notes = notes { self.notes = notes }
        self.updatedAt = Date()
    }
}

@Model
final class RecipeLine {
    @Attribute(.unique) var id: UUID
    var ingredient: String
    var percentage: Double
    
    init(ingredient: String, percentage: Double) {
        self.id = UUID()
        self.ingredient = ingredient
        self.percentage = percentage
    }
}
