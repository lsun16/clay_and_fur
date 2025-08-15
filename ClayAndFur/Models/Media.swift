import Foundation
import SwiftData
import UIKit

@Model
final class Media {
    @Attribute(.unique) var id: UUID
    var fileName: String
    var createdAt: Date
    var pieceId: UUID?
    var glazeId: UUID?
    var firingId: UUID?
    var caption: String?
    var stageAtCapture: String? // Stage when photo was taken
    
    init(
        fileName: String,
        pieceId: UUID? = nil,
        glazeId: UUID? = nil,
        firingId: UUID? = nil,
        caption: String? = nil,
        stageAtCapture: String? = nil
    ) {
        self.id = UUID()
        self.fileName = fileName
        self.pieceId = pieceId
        self.glazeId = glazeId
        self.firingId = firingId
        self.caption = caption
        self.stageAtCapture = stageAtCapture
        self.createdAt = Date()
    }
    
    // Computed property to get the full file URL
    var fileURL: URL? {
        PhotoManager.shared.getPhotoURL(for: fileName)
    }
    
    // Load the image from storage
    func loadImage() -> UIImage? {
        guard let url = fileURL else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}
