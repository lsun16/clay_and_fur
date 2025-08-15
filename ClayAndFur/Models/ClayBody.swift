import Foundation
import SwiftData

@Model
final class ClayBody {
    @Attribute(.unique) var id: UUID
    var name: String
    var description: String?
    var cone: String?
    var color: String?
    var createdAt: Date
    
    init(name: String, description: String? = nil, cone: String? = nil, color: String? = nil) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.cone = cone
        self.color = color
        self.createdAt = Date()
    }
}

@Model
final class FiringMethod {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: String // "Bisque", "Glaze", "Raku", etc.
    var atmosphere: String? // "Oxidation", "Reduction", "Neutral"
    var defaultCone: String?
    var description: String?
    var createdAt: Date
    
    init(name: String, type: String, atmosphere: String? = nil, defaultCone: String? = nil, description: String? = nil) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.atmosphere = atmosphere
        self.defaultCone = defaultCone
        self.description = description
        self.createdAt = Date()
    }
}