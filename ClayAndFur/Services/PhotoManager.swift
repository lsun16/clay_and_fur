import Foundation
import UIKit
import SwiftData

class PhotoManager: ObservableObject {
    static let shared = PhotoManager()
    
    private let documentsDirectory: URL
    private let photosDirectory: URL
    
    private init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        photosDirectory = documentsDirectory.appendingPathComponent("Photos", isDirectory: true)
        
        // Create photos directory if it doesn't exist
        createPhotosDirectoryIfNeeded()
    }
    
    private func createPhotosDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: photosDirectory.path) {
            try? FileManager.default.createDirectory(at: photosDirectory, withIntermediateDirectories: true)
        }
    }
    
    // Save photo and return filename
    func savePhoto(_ image: UIImage) -> String? {
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = photosDirectory.appendingPathComponent(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving photo: \(error)")
            return nil
        }
    }
    
    // Get photo URL for filename
    func getPhotoURL(for fileName: String) -> URL {
        return photosDirectory.appendingPathComponent(fileName)
    }
    
    // Load photo from filename
    func loadPhoto(fileName: String) -> UIImage? {
        let fileURL = getPhotoURL(for: fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    // Delete photo
    func deletePhoto(fileName: String) -> Bool {
        let fileURL = getPhotoURL(for: fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("Error deleting photo: \(error)")
            return false
        }
    }
    
    // Create Media object and save photo
    func createMediaFromImage(_ image: UIImage, for piece: Piece, caption: String? = nil, stage: String? = nil, modelContext: ModelContext) -> Media? {
        guard let fileName = savePhoto(image) else {
            return nil
        }
        
        let media = Media(
            fileName: fileName,
            pieceId: piece.id,
            caption: caption,
            stageAtCapture: stage
        )
        
        modelContext.insert(media)
        piece.media.append(media)
        
        return media
    }
}
