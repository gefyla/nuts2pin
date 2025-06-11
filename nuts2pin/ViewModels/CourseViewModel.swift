import Foundation
import CoreLocation
import Combine
import SwiftUI
import MapKit

class CourseViewModel: ObservableObject {
    @Published var currentCourse: Course?
    @Published var currentHoleIndex: Int = 0
    @Published var totalScore: Int = 0
    @Published var frontNineScore: Int = 0
    @Published var backNineScore: Int = 0
    @Published var selectedHazard: Hazard?
    @Published var distanceToPin: Double?
    @Published var distanceToHazard: Double?
    @Published var isPracticeMode: Bool = false
    @Published var practiceLocation: Coordinate?
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var cancellables = Set<AnyCancellable>()
    
    var currentHole: Hole? {
        guard let course = currentCourse,
              currentHoleIndex < course.holes.count else { return nil }
        return course.holes[currentHoleIndex]
    }
    
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
        return course.holes.filter { !$0.shots.isEmpty }.count
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
        currentHoleIndex = 0
        updateScores()
    }
    
    func nextHole() {
        guard let course = currentCourse,
              currentHoleIndex < course.holes.count - 1 else { return }
        currentHoleIndex += 1
        updateDistances()
    }
    
    func previousHole() {
        guard currentHoleIndex > 0 else { return }
        currentHoleIndex -= 1
        updateDistances()
    }
    
    func recordShot(_ shot: Shot) {
        guard var hole = currentHole else { return }
        hole.shots.append(shot)
        currentCourse?.holes[currentHoleIndex] = hole
        updateScores()
        updateDistances()
    }
    
    func updateScores() {
        guard let course = currentCourse else { return }
        
        totalScore = course.holes.reduce(0) { $0 + $1.shots.count }
        frontNineScore = course.holes.prefix(9).reduce(0) { $0 + $1.shots.count }
        backNineScore = course.holes.suffix(9).reduce(0) { $0 + $1.shots.count }
    }
    
    func selectTeeBox(_ teeBox: TeeBox) {
        currentCourse?.selectedTeeBox = teeBox
        updateDistances()
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
    
    // MARK: - Score Statistics
    
    var holesInProgress: Int {
        guard let course = currentCourse else { return 0 }
        return course.holes.filter { !$0.shots.isEmpty }.count
    }
} 