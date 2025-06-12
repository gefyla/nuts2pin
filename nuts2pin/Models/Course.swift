import Foundation
import CoreLocation
import SwiftUI
import MapKit

struct Course: Identifiable {
    let id = UUID()
    let name: String
    let holes: [Hole]
    var selectedTeeBox: String = "White"
    
    var totalPar: Int {
        holes.reduce(0) { $0 + $1.par }
    }
    
    var totalDistance: Int {
        holes.reduce(0) { $0 + $1.distance }
    }
}

struct Hole: Identifiable {
    let id = UUID()
    let number: Int
    let par: Int
    let distance: Int
    let teeLocation: Coordinate
    let pinLocation: Coordinate
    let hazards: [Hazard]
    var score: Int?
    var shots: [Shot] = []
    var customPinLocation: Coordinate?
    
    var teeBoxes: [String: TeeBoxInfo] = [:]
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
    
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func distance(from: Coordinate, to: Coordinate) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

struct Hazard: Identifiable {
    let id = UUID()
    let type: HazardType
    let location: Coordinate
    let description: String
}

enum HazardType: String {
    case water = "Water"
    case bunker = "Bunker"
    case outOfBounds = "Out of Bounds"
    case tree = "Tree"
}

struct Shot {
    let id = UUID()
    let timestamp = Date()
    var distance: Double?
    var club: String?
    var notes: String?
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