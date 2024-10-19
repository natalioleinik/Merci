import SwiftUI

struct CoquetteFlowerView: View {
    var entryIndex: Int

    var body: some View {
        ZStack {
            // Stem with a soft golden color
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.green.opacity(0.3)) // Soft gold
                .frame(width: 12, height: 40)
                .offset(y: 35)
                .shadow(radius: 5)

            // Flower petals with pastel colors
            ForEach(0..<6) { i in
                Ellipse()
                    .fill(pickColor(for: entryIndex))
                    .frame(width: 60, height: 30)
                    .rotationEffect(.degrees(Double(i) * 60))
                    .shadow(color: Color.pink.opacity(0.3), radius: 5)
            }

            // Flower center with a soft cream tone
            Circle()
                .fill(Color(red: 1.0, green: 1.0, blue: 0.8))
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(Color.yellow.opacity(0.5), lineWidth: 2))
                .shadow(color: Color.pink.opacity(0.3), radius: 5)
        }
    }

    func pickColor(for index: Int) -> Color {
        // Soft pastel colors for a dreamy aesthetic
        let colors: [Color] = [
            Color(red: 1.0, green: 0.8, blue: 0.9), // Soft Pink
            Color(red: 0.95, green: 0.75, blue: 0.8), // Blush Pink
            Color(red: 0.87, green: 0.62, blue: 0.67).opacity(0.6), // Dusty Rose
            Color(red: 1.0, green: 0.85, blue: 0.87).opacity(0.5), // Baby Pink
            Color(red: 0.98, green: 0.9, blue: 0.95).opacity(0.4), // Lavender Blush
            Color(red: 1.0, green: 0.85, blue: 0.75).opacity(0.3), // Peach Pink
            Color(red: 0.94, green: 0.87, blue: 0.96).opacity(0.3), // Pale Lilac
            Color(red: 1.0, green: 0.9, blue: 0.8).opacity(0.2) // Pale Peach
        ]
        return colors[index % colors.count]
    }
}

struct ContentView: View {
    @State private var gratitudeResponse: String = ""
    @ObservedObject var gratitudeManager = GratitudeManager.shared // Use shared instance

    // Store flower positions
    @State private var flowerPositions: [CGPoint] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title with soft pink color and vintage font style, slightly bigger
                Text("Merci")
                    .font(.custom("SnellRoundhand", size: 60)) // Bigger font size
                    .foregroundColor(Color.pink.opacity(0.8)) // Softer pink
                    .shadow(color: Color.pink.opacity(0.3), radius: 5)
                    .fontWeight(.bold)
                    .padding()

                // Gratitude prompt area with classy design
                VStack(spacing: 15) {
                    Text("What are you grateful for today?")
                        .font(.custom("Georgia", size: 20)) // Unified fonts after Merci
                        .foregroundColor(Color.pink.opacity(0.8))

                    // Classy royal-style text field with decorative borders and left padding
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.pink.opacity(0.3), lineWidth: 3)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.8))
                            )
                            .shadow(color: Color.pink.opacity(0.3), radius: 5)
                            .padding(.horizontal)
                        
                        TextField("Enter your gratitude message...", text: $gratitudeResponse)
                            .padding(.horizontal, 35) // Add space on the left
                            .padding(.vertical, 10) // Add vertical padding for text field
                            .font(.custom("Georgia", size: 18))
                        
                            .foregroundColor(Color.pink.opacity(0.7))
                    }
                }

                // Submit button with a soft pink tone
                Button("Submit") {
                    
                    if !gratitudeResponse.isEmpty {
                        let newPosition = randomPosition()
                        gratitudeManager.addEntry(gratitude: gratitudeResponse, position: newPosition)
                        flowerPositions.append(newPosition)
                        gratitudeResponse = ""
                    }
                }
                .padding()
                .background(Color(red: 1.0, green: 0.7, blue: 0.8)) // Coquette cool-tone pink
                .cornerRadius(15)
                .foregroundColor(.white)
                .shadow(color: Color.pink.opacity(0.3), radius: 5)
                .padding()


                // Display the garden with no flowers below the rectangle
                VStack {

                    // Light background for the garden, rectangle adjusted for flower positions
                    ZStack {
                        // Garden background rectangle
                        Rectangle()
                            .fill(Color(red: 0.9, green: 1.0, blue: 0.9).opacity(0.7))
                            .frame(height: 250) // Adjusted height for fitting view
                            .cornerRadius(20)
                            .shadow(color: Color.pink.opacity(0.3), radius: 5)

                        // Flowers inside the rectangle
                        ForEach(gratitudeManager.gratitudeEntries.indices, id: \.self) { index in
                            if index < gratitudeManager.flowerPositions.count {
                                CoquetteFlowerView(entryIndex: index)
                                    .frame(width: 120, height: 120)
                                    .position(gratitudeManager.flowerPositions[index])
                                    .clipped() // Ensure flowers are clipped within bounds
                            }
                        }
                    }
                    .padding()
                }

                // Navigation to Journal Archive
                NavigationLink(destination: JournalArchiveView()) {
                    Text("Your Journal Archive")
                        .padding()
                        .background(Color(red: 1.0, green: 0.7, blue: 0.8)) // Coquette cool-tone pink
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .shadow(color: Color.pink.opacity(0.3), radius: 5)
                }

                Spacer()
            }
            .padding()
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Light background
        }
    }

    // Function to generate random positions for flowers, constrained within the rectangle
    private func randomPosition() -> CGPoint {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 220 // Height of the garden rectangle
        let flowerSize: CGFloat = 120
        let padding: CGFloat = 20

        let x = CGFloat.random(in: padding...(width - flowerSize - padding))
        let y = CGFloat.random(in: flowerSize / 2...(height - flowerSize / 2))

        return CGPoint(x: x, y: y)
    }
}

#Preview {
    ContentView()
}
