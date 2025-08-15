import Foundation
import SwiftData

@Model
final class Piece {
    @Attribute(.unique) var id: UUID
    var name: String
    var clayBodyName: String? // Keep for backward compatibility
    var clayBody: ClayBody? // New relationship
    var intendedForm: String?
    var widthCM: Double?
    var heightCM: Double?
    var weightG: Double?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date
    
    // Relationships
    var glaze: Glaze?
    @Relationship(deleteRule: .cascade) var stages: [StageEvent] = []
    @Relationship(deleteRule: .cascade) var media: [Media] = []
    @Relationship(deleteRule: .nullify, inverse: \Firing.pieces) var firings: [Firing] = []
    
    // Computed properties
    var currentStage: Stage {
        guard let latestStage = stages.sorted(by: { $0.date > $1.date }).first else {
            return .thrown
        }
        return latestStage.stage
    }
    
    var stageColor: String {
        return currentStage.color.description
    }
    
    init(
        name: String,
        clayBodyName: String? = nil,
        intendedForm: String? = nil,
        widthCM: Double? = nil,
        heightCM: Double? = nil,
        weightG: Double? = nil,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.clayBodyName = clayBodyName
        self.intendedForm = intendedForm
        self.widthCM = widthCM
        self.heightCM = heightCM
        self.weightG = weightG
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
        
        // Add initial "thrown" stage
        let initialStage = StageEvent(stage: .thrown, date: Date())
        self.stages.append(initialStage)
    }
    
    func addStageEvent(_ stage: Stage, date: Date = Date(), note: String? = nil) {
        let event = StageEvent(stage: stage, date: date, note: note)
        stages.append(event)
        updatedAt = Date()
    }
    
    func updateDetails(
        name: String? = nil,
        clayBodyName: String? = nil,
        intendedForm: String? = nil,
        widthCM: Double? = nil,
        heightCM: Double? = nil,
        weightG: Double? = nil,
        notes: String? = nil
    ) {
        if let name = name { self.name = name }
        if let clayBodyName = clayBodyName { self.clayBodyName = clayBodyName }
        if let intendedForm = intendedForm { self.intendedForm = intendedForm }
        if let widthCM = widthCM { self.widthCM = widthCM }
        if let heightCM = heightCM { self.heightCM = heightCM }
        if let weightG = weightG { self.weightG = weightG }
        if let notes = notes { self.notes = notes }
        self.updatedAt = Date()
    }
}
