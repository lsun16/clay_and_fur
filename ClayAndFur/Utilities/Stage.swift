import SwiftUI

enum Stage: String, Codable, CaseIterable, Identifiable {
    case thrown = "thrown"
    case trimmed = "trimmed"
    case leatherHard = "leatherHard"
    case boneDry = "boneDry"
    case bisque = "bisque"
    case glazed = "glazed"
    case glazeFired = "glazeFired"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .thrown: return "Thrown"
        case .trimmed: return "Trimmed"
        case .leatherHard: return "Leather Hard"
        case .boneDry: return "Bone Dry"
        case .bisque: return "Bisque"
        case .glazed: return "Glazed"
        case .glazeFired: return "Glaze Fired"
        }
    }
    
    var color: Color {
        switch self {
        case .thrown: return .blue
        case .trimmed: return .teal
        case .leatherHard: return .orange
        case .boneDry: return .yellow
        case .bisque: return .red
        case .glazed: return .purple
        case .glazeFired: return .green
        }
    }
    
    var systemImage: String {
        switch self {
        case .thrown: return "hands.sparkles"
        case .trimmed: return "scissors"
        case .leatherHard: return "drop"
        case .boneDry: return "sun.max"
        case .bisque: return "flame"
        case .glazed: return "paintbrush"
        case .glazeFired: return "checkmark.seal"
        }
    }
    
    var nextStage: Stage? {
        let allCases = Stage.allCases
        guard let currentIndex = allCases.firstIndex(of: self),
              currentIndex < allCases.count - 1 else {
            return nil
        }
        return allCases[currentIndex + 1]
    }
}
