import Foundation
import CoreLocation
import Combine
import SwiftUI
import MapKit

class CourseViewModel: ObservableObject {
    @Published var currentCourse: Course?
    @Published var currentHole: Hole?
    @Published var selectedTeeBox: TeeBox = .blue
    @Published var customPinLocation: CLLocationCoordinate2D?
    @Published var userLocation: CLLocation?
    @Published var isMapRealistic: Bool = true
    @Published var totalScore: Int = 0
    @Published var frontNineScore: Int = 0
    @Published var backNineScore: Int = 0
    @Published var selectedHazard: Hazard?
    @Published var distanceToPin: Double?
    @Published var distanceToHazard: Double?
    @Published var isPracticeMode: Bool = false
    @Published var practiceLocation: Coordinate?
    
    private var locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var scores: [Int: Int] = [:]
    private var putts: [Int: Int] = [:]
    private var fairwayHits: [Int: Bool] = [:]
    private var greenInRegulations: [Int: Bool] = [:]
    private var notes: [Int: String] = [:]
    
    var scoreToPar: Int {
        guard let course = currentCourse else { return 0 }
        return totalScore - course.totalPar
    }
    
    var averageScore: Double {
        guard let course = currentCourse else { return 0 }
        return Double(totalScore) / Double(course.holes.count)
    }
    
    var holesInProgress: Int {
        guard let course = currentCourse else { return 0 }
        return course.holes.filter { $0.score != nil }.count
    }
    
    init() {
        setupLocationManager()
        
        // Subscribe to location updates
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.updateDistances(with: location)
            }
            .store(in: &cancellables)
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadCourse(_ course: Course) {
        currentCourse = course
        currentHole = course.holes.first
        updateScores()
    }
    
    func nextHole() {
        guard let course = currentCourse,
              let currentHole = currentHole,
              let currentIndex = course.holes.firstIndex(where: { $0.id == currentHole.id }),
              currentIndex + 1 < course.holes.count else { return }
        
        self.currentHole = course.holes[currentIndex + 1]
    }
    
    func previousHole() {
        guard let course = currentCourse,
              let currentHole = currentHole,
              let currentIndex = course.holes.firstIndex(where: { $0.id == currentHole.id }),
              currentIndex > 0 else { return }
        
        self.currentHole = course.holes[currentIndex - 1]
    }
    
    func recordShot(club: String, distance: Double, notes: String? = nil) {
        guard var hole = currentHole else { return }
        let shot = Shot(club: club, distance: distance, notes: notes)
        hole.shots.append(shot)
        currentHole = hole
        
        if let course = currentCourse,
           let index = course.holes.firstIndex(where: { $0.id == hole.id }) {
            currentCourse?.holes[index] = hole
        }
    }
    
    func getScore(for hole: Hole) -> Int? {
        return scores[hole.number]
    }
    
    func getPutts(for hole: Hole) -> Int? {
        return putts[hole.number]
    }
    
    func getFairwayHit(for hole: Hole) -> Bool? {
        return fairwayHits[hole.number]
    }
    
    func getGreenInRegulation(for hole: Hole) -> Bool? {
        return greenInRegulations[hole.number]
    }
    
    func getNotes(for hole: Hole) -> String? {
        return notes[hole.number]
    }
    
    func updateScore(for hole: Hole, score: Int) {
        scores[hole.number] = score
        objectWillChange.send()
    }
    
    func updatePutts(for hole: Hole, putts: Int) {
        self.putts[hole.number] = putts
        objectWillChange.send()
    }
    
    func updateFairwayHit(for hole: Hole, hit: Bool) {
        fairwayHits[hole.number] = hit
        objectWillChange.send()
    }
    
    func updateGreenInRegulation(for hole: Hole, hit: Bool) {
        greenInRegulations[hole.number] = hit
        objectWillChange.send()
    }
    
    func updateNotes(for hole: Hole, notes: String) {
        self.notes[hole.number] = notes
        objectWillChange.send()
    }
    
    func getTotalScore(frontNine: Bool = false, backNine: Bool = false) -> Int {
        guard let course = currentCourse else { return 0 }
        
        if frontNine {
            return course.holes.prefix(9).compactMap { scores[$0.number] }.reduce(0, +)
        } else if backNine {
            return course.holes.suffix(9).compactMap { scores[$0.number] }.reduce(0, +)
        } else {
            return scores.values.reduce(0, +)
        }
    }
    
    func getTotalPar(frontNine: Bool = false, backNine: Bool = false) -> Int {
        guard let course = currentCourse else { return 0 }
        
        if frontNine {
            return course.frontNinePar
        } else if backNine {
            return course.backNinePar
        } else {
            return course.totalPar
        }
    }
    
    func getScoreToPar(frontNine: Bool = false, backNine: Bool = false) -> Int {
        getTotalScore(frontNine: frontNine, backNine: backNine) - getTotalPar(frontNine: frontNine, backNine: backNine)
    }
    
    func getTotalPutts(frontNine: Bool = false, backNine: Bool = false) -> Int {
        guard let course = currentCourse else { return 0 }
        
        if frontNine {
            return course.holes.prefix(9).compactMap { putts[$0.number] }.reduce(0, +)
        } else if backNine {
            return course.holes.suffix(9).compactMap { putts[$0.number] }.reduce(0, +)
        } else {
            return putts.values.reduce(0, +)
        }
    }
    
    func getFairwayHitPercentage(frontNine: Bool = false, backNine: Bool = false) -> Double {
        guard let course = currentCourse else { return 0 }
        
        let holes = frontNine ? course.holes.prefix(9) : backNine ? course.holes.suffix(9) : course.holes
        let hits = holes.compactMap { fairwayHits[$0.number] }.filter { $0 }.count
        let total = holes.compactMap { fairwayHits[$0.number] }.count
        return total > 0 ? Double(hits) / Double(total) * 100 : 0
    }
    
    func getGreenInRegulationPercentage(frontNine: Bool = false, backNine: Bool = false) -> Double {
        guard let course = currentCourse else { return 0 }
        
        let holes = frontNine ? course.holes.prefix(9) : backNine ? course.holes.suffix(9) : course.holes
        let hits = holes.compactMap { greenInRegulations[$0.number] }.filter { $0 }.count
        let total = holes.compactMap { greenInRegulations[$0.number] }.count
        return total > 0 ? Double(hits) / Double(total) * 100 : 0
    }
    
    func moveToNextHole() {
        guard let course = currentCourse,
              let currentHole = currentHole,
              let currentIndex = course.holes.firstIndex(where: { $0.number == currentHole.number }),
              currentIndex + 1 < course.holes.count else {
            return
        }
        self.currentHole = course.holes[currentIndex + 1]
    }
    
    func moveToPreviousHole() {
        guard let course = currentCourse,
              let currentHole = currentHole,
              let currentIndex = course.holes.firstIndex(where: { $0.number == currentHole.number }),
              currentIndex > 0 else {
            return
        }
        self.currentHole = course.holes[currentIndex - 1]
    }
    
    func updateUserLocation(_ location: CLLocation) {
        userLocation = location
    }
    
    func toggleMapRealism() {
        isMapRealistic.toggle()
    }
    
    func selectTeeBox(_ teeBox: TeeBox) {
        selectedTeeBox = teeBox
    }
    
    func updatePinLocation(hole: Hole, newLocation: CLLocationCoordinate2D) {
        guard var course = currentCourse,
              let holeIndex = course.holes.firstIndex(where: { $0.number == hole.number }) else { return }
        
        course.holes[holeIndex].customPinLocation = Coordinate(
            latitude: newLocation.latitude,
            longitude: newLocation.longitude
        )
        
        currentCourse = course
        updateDistances()
    }
    
    func updateTeeLocation(hole: Hole, newLocation: CLLocationCoordinate2D) {
        guard var course = currentCourse,
              let holeIndex = course.holes.firstIndex(where: { $0.number == hole.number }),
              let teeBox = course.selectedTeeBox else { return }
        
        var updatedTeeInfo = course.holes[holeIndex].teeBoxes[teeBox] ?? TeeBoxInfo(
            name: teeBox.rawValue,
            distance: 0,
            location: Coordinate(latitude: 0, longitude: 0),
            rating: 0,
            slope: 0
        )
        
        updatedTeeInfo.location = Coordinate(
            latitude: newLocation.latitude,
            longitude: newLocation.longitude
        )
        
        course.holes[holeIndex].teeBoxes[teeBox] = updatedTeeInfo
        currentCourse = course
        updateDistances()
    }
    
    func togglePracticeMode() {
        isPracticeMode.toggle()
        if isPracticeMode {
            // Set practice location to the current tee box
            if let hole = currentHole,
               let teeBox = hole.teeBoxes[currentCourse?.selectedTeeBox ?? .white] {
                practiceLocation = teeBox.location
            }
        } else {
            practiceLocation = nil
        }
        updateDistances()
    }
    
    func updatePracticeLocation(_ location: CLLocationCoordinate2D) {
        practiceLocation = Coordinate(latitude: location.latitude, longitude: location.longitude)
        updateDistances()
    }
    
    private func updateDistances() {
        guard let hole = currentHole,
              let teeBox = hole.teeBoxes[currentCourse?.selectedTeeBox ?? .white] else {
            distanceToPin = nil
            distanceToHazard = nil
            return
        }
        
        // Use practice location if in practice mode, otherwise use actual GPS location
        let currentLocation: Coordinate
        if isPracticeMode {
            currentLocation = practiceLocation ?? teeBox.location
        } else if let userLocation = userLocation {
            currentLocation = Coordinate(
                latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude
            )
        } else {
            currentLocation = teeBox.location
        }
        
        // Calculate distance to pin
        let pinLocation = hole.customPinLocation ?? hole.pinLocation
        distanceToPin = Coordinate.distance(from: currentLocation, to: pinLocation)
        
        // Calculate distance to selected hazard
        if let hazard = selectedHazard {
            distanceToHazard = Coordinate.distance(from: currentLocation, to: hazard.location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        if !isPracticeMode {
            updateDistances()
        }
    }
    
    func selectHazard(_ hazard: Hazard?) {
        selectedHazard = hazard
        if let location = locationManager.location {
            updateDistances(with: location)
        }
    }
} 