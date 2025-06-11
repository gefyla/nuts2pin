# Nuts2Pin Golf App

A personalized golf enhancement application for iOS, similar to 18 Birdies but with custom features and offline-first functionality.

## Features

### Core Functionality
- GPS Distance Tracking
  - Real-time distance to green/hole
  - Custom point-to-point distance measurement
  - Shot distance tracking with club statistics
- Course Visualization
  - Realistic mode (natural colors)
  - Cartoon mode (exaggerated colors for water/grass)
  - Aerial course view with offline capability
- Scoring & Statistics
  - Score tracking
  - Shot tracking with club selection
  - Club distance statistics
  - Advanced statistical analysis

### Technical Details
- iOS native app built with Swift/SwiftUI
- Offline-first architecture
- Local database storage
- Built using GitHub Actions with Mac runners
- Designed for sideloading via Sideloadly

## Development Setup

### Requirements
- iOS device for testing
- Sideloadly for app installation

### Building the Project
The app is automatically built using GitHub Actions whenever changes are pushed to the main branch. The build process:
1. Uses Mac runners with Xcode 16+
2. Builds the app without code signing (for sideloading)
3. Generates an IPA file
4. Uploads the IPA as a build artifact

To get the latest build:
1. Go to the Actions tab in this repository
2. Find the latest successful build
3. Download the nuts2pin.ipa artifact
4. Use Sideloadly to install on your iOS device

## Project Structure
```
nuts2pin/
├── Sources/
│   ├── App/
│   ├── Features/
│   │   ├── CourseView/
│   │   ├── DistanceTracking/
│   │   ├── Scoring/
│   │   └── Statistics/
│   ├── Core/
│   │   ├── Location/
│   │   ├── Database/
│   │   └── Maps/
│   └── UI/
│       ├── Components/
│       └── Styles/
├── Resources/
│   ├── Maps/
│   └── Assets/
└── Tests/
```

## License
MIT License - See LICENSE file for details