import Foundation
import CoreLocation
import SwiftUI

struct Course: Identifiable {
    let id = UUID()
    let name: String
    let holes: [Hole]
    var selectedTeeBox: TeeBox = .white
    
    var totalPar: Int {
        holes.reduce(0) { $0 + $1.par }
    }
}

struct Hole: Identifiable {
    let id = UUID()
    let number: Int
    let par: Int
    let distance: Int
    let teeBoxes: [TeeBox: TeeBoxInfo]
    let pinLocation: Coordinate
    var customPinLocation: Coordinate?
    let hazards: [Hazard]
    var shots: [Shot] = []
}

struct TeeBoxInfo {
    let name: String
    let distance: Int
    let location: Coordinate
    let rating: Double
    let slope: Int
}

enum TeeBox: String, CaseIterable {
    case black = "Black"
    case blue = "Blue"
    case white = "White"
    case gold = "Gold"
    case red = "Red"
    
    var color: Color {
        switch self {
        case .black: return .black
        case .blue: return .blue
        case .white: return .white
        case .gold: return .yellow
        case .red: return .red
        }
    }
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func distance(from start: Coordinate, to end: Coordinate) -> Double {
        let startLocation = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let endLocation = CLLocation(latitude: end.latitude, longitude: end.longitude)
        return startLocation.distance(from: endLocation) * 1.09361 // Convert meters to yards
    }
}

struct Hazard: Identifiable {
    let id = UUID()
    let type: HazardType
    let location: Coordinate
    let description: String
}

enum HazardType: String {
    case bunker = "Bunker"
    case water = "Water"
    case outOfBounds = "Out of Bounds"
    case tree = "Tree"
    case rough = "Rough"
}

struct Shot: Identifiable {
    let id = UUID()
    let club: Club
    let startLocation: Coordinate
    let endLocation: Coordinate
    let distance: Double
    let timestamp: Date = Date()
}

enum Club: String, CaseIterable {
    case driver = "Driver"
    case threeWood = "3 Wood"
    case fiveWood = "5 Wood"
    case hybrid = "Hybrid"
    case fourIron = "4 Iron"
    case fiveIron = "5 Iron"
    case sixIron = "6 Iron"
    case sevenIron = "7 Iron"
    case eightIron = "8 Iron"
    case nineIron = "9 Iron"
    case pitchingWedge = "Pitching Wedge"
    case gapWedge = "Gap Wedge"
    case sandWedge = "Sand Wedge"
    case lobWedge = "Lob Wedge"
    case putter = "Putter"
} 