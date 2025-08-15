import Foundation
import SwiftData

@Model
final class StageEvent {
    @Attribute(.unique) var id: UUID
    var stage: Stage
    var date: Date
    var note: String?
    
    init(stage: Stage, date: Date = Date(), note: String? = nil) {
        self.id = UUID()
        self.stage = stage
        self.date = date
        self.note = note
    }
}
