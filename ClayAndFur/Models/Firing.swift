import Foundation
import SwiftData

@Model
final class Firing {
    @Attribute(.unique) var id: UUID
    var kilnName: String
    var type: String
    var cone: String
    var atmosphere: String?
    var startAt: Date?
    var endAt: Date?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date
    
    // Relationships
    @Relationship(deleteRule: .nullify) var pieces: [Piece] = []
    @Relationship(deleteRule: .cascade) var media: [Media] = []
    
    // Computed properties
    var isInProgress: Bool {
        guard let startAt = startAt else { return false }
        if let endAt = endAt {
            return startAt <= Date() && Date() <= endAt
        }
        return startAt <= Date()
    }
    
    var isCompleted: Bool {
        guard let endAt = endAt else { return false }
        return Date() > endAt
    }
    
    var duration: TimeInterval? {
        guard let startAt = startAt, let endAt = endAt else { return nil }
        return endAt.timeIntervalSince(startAt)
    }
    
    init(
        kilnName: String,
        type: String,
        cone: String,
        atmosphere: String? = nil,
        startAt: Date? = nil,
        endAt: Date? = nil,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.kilnName = kilnName
        self.type = type
        self.cone = cone
        self.atmosphere = atmosphere
        self.startAt = startAt
        self.endAt = endAt
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    func addPiece(_ piece: Piece) {
        if !pieces.contains(piece) {
            pieces.append(piece)
            updatedAt = Date()
        }
    }
    
    func removePiece(_ piece: Piece) {
        pieces.removeAll { $0.id == piece.id }
        updatedAt = Date()
    }
    
    func updateDetails(
        kilnName: String? = nil,
        type: String? = nil,
        cone: String? = nil,
        atmosphere: String? = nil,
        startAt: Date? = nil,
        endAt: Date? = nil,
        notes: String? = nil
    ) {
        if let kilnName = kilnName { self.kilnName = kilnName }
        if let type = type { self.type = type }
        if let cone = cone { self.cone = cone }
        if let atmosphere = atmosphere { self.atmosphere = atmosphere }
        if let startAt = startAt { self.startAt = startAt }
        if let endAt = endAt { self.endAt = endAt }
        if let notes = notes { self.notes = notes }
        self.updatedAt = Date()
    }
}
