import Foundation

struct SampleCourses {
    static let pebbleBeach = Course(
        name: "Pebble Beach Golf Links",
        holes: [
            Hole(
                number: 1,
                par: 4,
                distance: 380,
                teeLocation: Coordinate(latitude: 36.5683, longitude: -121.9497),
                pinLocation: Coordinate(latitude: 36.5685, longitude: -121.9490),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5684, longitude: -121.9493), description: "Fairway bunker"),
                    Hazard(type: .water, location: Coordinate(latitude: 36.5686, longitude: -121.9488), description: "Ocean")
                ]
            ),
            Hole(
                number: 2,
                par: 5,
                distance: 516,
                teeLocation: Coordinate(latitude: 36.5680, longitude: -121.9485),
                pinLocation: Coordinate(latitude: 36.5675, longitude: -121.9475),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5678, longitude: -121.9480), description: "Fairway bunker"),
                    Hazard(type: .water, location: Coordinate(latitude: 36.5673, longitude: -121.9472), description: "Ocean")
                ]
            ),
            Hole(
                number: 3,
                par: 4,
                distance: 404,
                teeLocation: Coordinate(latitude: 36.5670, longitude: -121.9470),
                pinLocation: Coordinate(latitude: 36.5665, longitude: -121.9465),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5668, longitude: -121.9468), description: "Greenside bunker")
                ]
            ),
            Hole(
                number: 4,
                par: 4,
                distance: 331,
                teeLocation: Coordinate(latitude: 36.5660, longitude: -121.9460),
                pinLocation: Coordinate(latitude: 36.5655, longitude: -121.9455),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5658, longitude: -121.9458), description: "Ocean")
                ]
            ),
            Hole(
                number: 5,
                par: 3,
                distance: 195,
                teeLocation: Coordinate(latitude: 36.5650, longitude: -121.9450),
                pinLocation: Coordinate(latitude: 36.5645, longitude: -121.9445),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5648, longitude: -121.9448), description: "Greenside bunker")
                ]
            ),
            Hole(
                number: 6,
                par: 5,
                distance: 523,
                teeLocation: Coordinate(latitude: 36.5640, longitude: -121.9440),
                pinLocation: Coordinate(latitude: 36.5635, longitude: -121.9435),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5638, longitude: -121.9438), description: "Fairway bunker")
                ]
            ),
            Hole(
                number: 7,
                par: 3,
                distance: 106,
                teeLocation: Coordinate(latitude: 36.5630, longitude: -121.9430),
                pinLocation: Coordinate(latitude: 36.5625, longitude: -121.9425),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5628, longitude: -121.9428), description: "Ocean")
                ]
            ),
            Hole(
                number: 8,
                par: 4,
                distance: 428,
                teeLocation: Coordinate(latitude: 36.5620, longitude: -121.9420),
                pinLocation: Coordinate(latitude: 36.5615, longitude: -121.9415),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5618, longitude: -121.9418), description: "Fairway bunker")
                ]
            ),
            Hole(
                number: 9,
                par: 4,
                distance: 481,
                teeLocation: Coordinate(latitude: 36.5610, longitude: -121.9410),
                pinLocation: Coordinate(latitude: 36.5605, longitude: -121.9405),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5608, longitude: -121.9408), description: "Ocean")
                ]
            ),
            Hole(
                number: 10,
                par: 4,
                distance: 495,
                teeLocation: Coordinate(latitude: 36.5600, longitude: -121.9400),
                pinLocation: Coordinate(latitude: 36.5595, longitude: -121.9395),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5598, longitude: -121.9398), description: "Fairway bunker")
                ]
            ),
            Hole(
                number: 11,
                par: 4,
                distance: 390,
                teeLocation: Coordinate(latitude: 36.5590, longitude: -121.9390),
                pinLocation: Coordinate(latitude: 36.5585, longitude: -121.9385),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5588, longitude: -121.9388), description: "Ocean")
                ]
            ),
            Hole(
                number: 12,
                par: 3,
                distance: 202,
                teeLocation: Coordinate(latitude: 36.5580, longitude: -121.9380),
                pinLocation: Coordinate(latitude: 36.5575, longitude: -121.9375),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5578, longitude: -121.9378), description: "Greenside bunker")
                ]
            ),
            Hole(
                number: 13,
                par: 4,
                distance: 445,
                teeLocation: Coordinate(latitude: 36.5570, longitude: -121.9370),
                pinLocation: Coordinate(latitude: 36.5565, longitude: -121.9365),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5568, longitude: -121.9368), description: "Fairway bunker")
                ]
            ),
            Hole(
                number: 14,
                par: 5,
                distance: 580,
                teeLocation: Coordinate(latitude: 36.5560, longitude: -121.9360),
                pinLocation: Coordinate(latitude: 36.5555, longitude: -121.9355),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5558, longitude: -121.9358), description: "Ocean")
                ]
            ),
            Hole(
                number: 15,
                par: 4,
                distance: 397,
                teeLocation: Coordinate(latitude: 36.5550, longitude: -121.9350),
                pinLocation: Coordinate(latitude: 36.5545, longitude: -121.9345),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5548, longitude: -121.9348), description: "Fairway bunker")
                ]
            ),
            Hole(
                number: 16,
                par: 4,
                distance: 403,
                teeLocation: Coordinate(latitude: 36.5540, longitude: -121.9340),
                pinLocation: Coordinate(latitude: 36.5535, longitude: -121.9335),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5538, longitude: -121.9338), description: "Ocean")
                ]
            ),
            Hole(
                number: 17,
                par: 3,
                distance: 178,
                teeLocation: Coordinate(latitude: 36.5530, longitude: -121.9330),
                pinLocation: Coordinate(latitude: 36.5525, longitude: -121.9325),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5528, longitude: -121.9328), description: "Greenside bunker")
                ]
            ),
            Hole(
                number: 18,
                par: 5,
                distance: 543,
                teeLocation: Coordinate(latitude: 36.5520, longitude: -121.9320),
                pinLocation: Coordinate(latitude: 36.5515, longitude: -121.9315),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5518, longitude: -121.9318), description: "Ocean")
                ]
            )
        ]
    )
    
    static let allCourses = [pebbleBeach]
} 