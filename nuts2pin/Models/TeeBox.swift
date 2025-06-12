import Foundation

enum TeeBox: String, CaseIterable {
    case black = "black"
    case blue = "blue"
    case white = "white"
    case gold = "gold"
    case red = "red"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: String {
        switch self {
        case .black: return "Black"
        case .blue: return "Blue"
        case .white: return "White"
        case .gold: return "Gold"
        case .red: return "Red"
        }
    }
    
    var order: Int {
        switch self {
        case .black: return 0
        case .blue: return 1
        case .white: return 2
        case .gold: return 3
        case .red: return 4
        }
    }
} 