import Foundation

struct SampleCourses {
    static let pebbleBeach = Course(
        name: "Pebble Beach Golf Links",
        holes: [
            // Front Nine
            Hole(
                number: 1,
                par: 4,
                distance: 380,
                teeBoxes: [
                    .black: TeeBoxInfo(name: "Black", distance: 380, location: Coordinate(latitude: 36.5682, longitude: -121.9497), rating: 74.7, slope: 145),
                    .blue: TeeBoxInfo(name: "Blue", distance: 360, location: Coordinate(latitude: 36.5683, longitude: -121.9498), rating: 72.8, slope: 140),
                    .white: TeeBoxInfo(name: "White", distance: 340, location: Coordinate(latitude: 36.5684, longitude: -121.9499), rating: 70.5, slope: 135),
                    .gold: TeeBoxInfo(name: "Gold", distance: 320, location: Coordinate(latitude: 36.5685, longitude: -121.9500), rating: 68.2, slope: 130),
                    .red: TeeBoxInfo(name: "Red", distance: 300, location: Coordinate(latitude: 36.5686, longitude: -121.9501), rating: 65.9, slope: 125)
                ],
                pinLocation: Coordinate(latitude: 36.5687, longitude: -121.9502),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5688, longitude: -121.9503), description: "Front right bunker"),
                    Hazard(type: .water, location: Coordinate(latitude: 36.5689, longitude: -121.9504), description: "Ocean on the right")
                ]
            ),
            Hole(
                number: 2,
                par: 5,
                distance: 516,
                teeBoxes: [
                    .black: TeeBoxInfo(name: "Black", distance: 516, location: Coordinate(latitude: 36.5690, longitude: -121.9505), rating: 75.2, slope: 146),
                    .blue: TeeBoxInfo(name: "Blue", distance: 496, location: Coordinate(latitude: 36.5691, longitude: -121.9506), rating: 73.3, slope: 141),
                    .white: TeeBoxInfo(name: "White", distance: 476, location: Coordinate(latitude: 36.5692, longitude: -121.9507), rating: 71.0, slope: 136),
                    .gold: TeeBoxInfo(name: "Gold", distance: 456, location: Coordinate(latitude: 36.5693, longitude: -121.9508), rating: 68.7, slope: 131),
                    .red: TeeBoxInfo(name: "Red", distance: 436, location: Coordinate(latitude: 36.5694, longitude: -121.9509), rating: 66.4, slope: 126)
                ],
                pinLocation: Coordinate(latitude: 36.5695, longitude: -121.9510),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5696, longitude: -121.9511), description: "Fairway bunker"),
                    Hazard(type: .water, location: Coordinate(latitude: 36.5697, longitude: -121.9512), description: "Ocean on the left")
                ]
            ),
            Hole(
                number: 3,
                par: 4,
                distance: 404,
                teeLocation: Coordinate(latitude: 36.5670, longitude: -121.9470),
                pinLocation: Coordinate(latitude: 36.5665, longitude: -121.9465),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5668, longitude: -121.9468), radius: 8)
                ]
            ),
            Hole(
                number: 4,
                par: 4,
                distance: 331,
                teeLocation: Coordinate(latitude: 36.5660, longitude: -121.9460),
                pinLocation: Coordinate(latitude: 36.5655, longitude: -121.9455),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5658, longitude: -121.9458), radius: 25)
                ]
            ),
            Hole(
                number: 5,
                par: 3,
                distance: 195,
                teeLocation: Coordinate(latitude: 36.5650, longitude: -121.9450),
                pinLocation: Coordinate(latitude: 36.5645, longitude: -121.9445),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5648, longitude: -121.9448), radius: 15)
                ]
            ),
            Hole(
                number: 6,
                par: 5,
                distance: 523,
                teeLocation: Coordinate(latitude: 36.5640, longitude: -121.9440),
                pinLocation: Coordinate(latitude: 36.5635, longitude: -121.9435),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5638, longitude: -121.9438), radius: 30)
                ]
            ),
            Hole(
                number: 7,
                par: 3,
                distance: 109,
                teeLocation: Coordinate(latitude: 36.5630, longitude: -121.9430),
                pinLocation: Coordinate(latitude: 36.5625, longitude: -121.9425),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5628, longitude: -121.9428), radius: 10)
                ]
            ),
            Hole(
                number: 8,
                par: 4,
                distance: 428,
                teeLocation: Coordinate(latitude: 36.5620, longitude: -121.9420),
                pinLocation: Coordinate(latitude: 36.5615, longitude: -121.9415),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5618, longitude: -121.9418), radius: 40)
                ]
            ),
            Hole(
                number: 9,
                par: 4,
                distance: 526,
                teeLocation: Coordinate(latitude: 36.5610, longitude: -121.9410),
                pinLocation: Coordinate(latitude: 36.5605, longitude: -121.9405),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5608, longitude: -121.9408), radius: 35)
                ]
            ),
            // Back Nine
            Hole(
                number: 10,
                par: 4,
                distance: 495,
                teeLocation: Coordinate(latitude: 36.5600, longitude: -121.9400),
                pinLocation: Coordinate(latitude: 36.5595, longitude: -121.9395),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5598, longitude: -121.9398), radius: 45)
                ]
            ),
            Hole(
                number: 11,
                par: 4,
                distance: 390,
                teeLocation: Coordinate(latitude: 36.5590, longitude: -121.9390),
                pinLocation: Coordinate(latitude: 36.5585, longitude: -121.9385),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5588, longitude: -121.9388), radius: 12)
                ]
            ),
            Hole(
                number: 12,
                par: 3,
                distance: 202,
                teeLocation: Coordinate(latitude: 36.5580, longitude: -121.9380),
                pinLocation: Coordinate(latitude: 36.5575, longitude: -121.9375),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5578, longitude: -121.9378), radius: 20)
                ]
            ),
            Hole(
                number: 13,
                par: 4,
                distance: 445,
                teeLocation: Coordinate(latitude: 36.5570, longitude: -121.9370),
                pinLocation: Coordinate(latitude: 36.5565, longitude: -121.9365),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5568, longitude: -121.9368), radius: 15)
                ]
            ),
            Hole(
                number: 14,
                par: 5,
                distance: 580,
                teeLocation: Coordinate(latitude: 36.5560, longitude: -121.9360),
                pinLocation: Coordinate(latitude: 36.5555, longitude: -121.9355),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5558, longitude: -121.9358), radius: 25)
                ]
            ),
            Hole(
                number: 15,
                par: 4,
                distance: 397,
                teeLocation: Coordinate(latitude: 36.5550, longitude: -121.9350),
                pinLocation: Coordinate(latitude: 36.5545, longitude: -121.9345),
                hazards: [
                    Hazard(type: .bunker, location: Coordinate(latitude: 36.5548, longitude: -121.9348), radius: 10)
                ]
            ),
            Hole(
                number: 16,
                par: 4,
                distance: 403,
                teeLocation: Coordinate(latitude: 36.5540, longitude: -121.9340),
                pinLocation: Coordinate(latitude: 36.5535, longitude: -121.9335),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5538, longitude: -121.9338), radius: 30)
                ]
            ),
            Hole(
                number: 17,
                par: 3,
                distance: 178,
                teeLocation: Coordinate(latitude: 36.5530, longitude: -121.9330),
                pinLocation: Coordinate(latitude: 36.5525, longitude: -121.9325),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5528, longitude: -121.9328), radius: 50)
                ]
            ),
            Hole(
                number: 18,
                par: 5,
                distance: 543,
                teeLocation: Coordinate(latitude: 36.5520, longitude: -121.9320),
                pinLocation: Coordinate(latitude: 36.5515, longitude: -121.9315),
                hazards: [
                    Hazard(type: .water, location: Coordinate(latitude: 36.5518, longitude: -121.9318), radius: 60)
                ]
            )
        ]
    )
    
    static let allCourses = [pebbleBeach]
} 