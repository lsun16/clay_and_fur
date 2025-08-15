import Foundation
import SwiftData

@Model
final class Media {
    @Attribute(.unique) var id: UUID
    var fileName: String
    var createdAt: Date
    var pieceId: UUID?
    var glazeId: UUID?
    var firingId: UUID?
    var caption: String?
    
    init(
        fileName: String,
        pieceId: UUID? = nil,
        glazeId: UUID? = nil,
        firingId: UUID? = nil,
        caption: String? = nil
    ) {
        self.id = UUID()
        self.fileName = fileName
        self.pieceId = pieceId
        self.glazeId = glazeId
        self.firingId = firingId
        self.caption = caption
        self.createdAt = Date()
    }
}
