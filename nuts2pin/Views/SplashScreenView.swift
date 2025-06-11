import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.7
    @State private var opacity = 0.3
    @State private var rotation: Double = 0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.45),  // Deep blue
                        Color(red: 0.2, green: 0.4, blue: 0.3)    // Forest green
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // App Icon
                    Image("AppIcon")  // Make sure to add your app icon to Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(radius: 10)
                        .rotationEffect(.degrees(rotation))
                    
                    // App Name
                    Text("Nuts2Pin")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    // Tagline
                    Text("Your Personal Golf Companion")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.size = 1.0
                        self.opacity = 1.0
                        self.rotation = 360
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
} 