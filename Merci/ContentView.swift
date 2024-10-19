import SwiftUI

struct FlowerView: View {
    var entryIndex: Int

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: 10, height: 50)
                .offset(y: 25)
            ForEach(0..<6) { i in
                Ellipse()
                    .fill(pickColor(for: entryIndex))
                    .frame(width: 40, height: 20)
                    .rotationEffect(.degrees(Double(i) * 60))
            }
            Circle()
                .fill(Color.yellow)
                .frame(width: 20, height: 20)
        }
    }

    func pickColor(for index: Int) -> Color {
        let colors: [Color] = [.pink, .blue, .purple, .orange, .red, .yellow]
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
            VStack(spacing: 30) {
                Text("Merci")
                    .font(.largeTitle)
                    .foregroundColor(.pink)

                VStack {
                    Text("What are you grateful for today?")
                        .font(.headline)
                        .foregroundColor(.pink)

                    TextField("Enter gratitude...", text: $gratitudeResponse)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }

                Button("Submit Gratitude") {
                    if !gratitudeResponse.isEmpty {
                        // Generate a random position for the new flower
                        let newPosition = randomPosition()
                        
                        // Add the gratitude response to the garden
                        gratitudeManager.addEntry(gratitude: gratitudeResponse, position: newPosition)

                        // Store the new position
                        flowerPositions.append(newPosition) // Add new position to the array

                        // Clear input
                        gratitudeResponse = ""
                    }
                }

                .padding()
                .background(Color(hue: 0.95, saturation: 0.4, brightness: 0.9))
                .cornerRadius(12)
                .foregroundColor(.white)

                // Display the garden as flowers based on gratitude entries
                VStack {
                    Text("Your Gratitude Garden")
                        .font(.title2)
                        .foregroundColor(.pink)
                        .padding(.top)

                    // Dynamic garden of flowers
                    ScrollView {
                        ZStack { // Use ZStack to allow overlapping flowers
                            // Ensure the garden has a minimum height even when empty
                            Rectangle()
                                .fill(Color.green.opacity(0.3)) // Background
                                .frame(height: 300) // Fixed height for the garden area
                                .cornerRadius(12)

                            ForEach(gratitudeManager.gratitudeEntries.indices, id: \.self) { index in
                                if index < gratitudeManager.flowerPositions.count { // Use flowerPositions from gratitudeManager
                                    FlowerView(entryIndex: index)
                                        .frame(width: 100, height: 100)
                                        .position(gratitudeManager.flowerPositions[index]) // Use stored positions
                                }
                            }


                        }
                        .padding()
                    }
                }

                // Navigation to Journal Archive View
                NavigationLink(destination: JournalArchiveView()) {
                    Text("View Journal Archive")
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
            .background(Color(hue: 0.1, saturation: 0.1, brightness: 0.98).edgesIgnoringSafeArea(.all))
        }
    }

    // Function to generate random positions for the flowers
    private func randomPosition() -> CGPoint {
        let width = UIScreen.main.bounds.width // Get the width of the screen
        let height: CGFloat = 300 // Height of the garden area

        let flowerSize: CGFloat = 100 // Size of the flower
        let padding: CGFloat = 20 // Padding from the edges

        // Generate random x position within the bounds of the rectangle
        let x = CGFloat.random(in: padding...(width - flowerSize - padding))
        // Generate random y position within the height of the garden area
        let y = CGFloat.random(in: flowerSize / 2...(height - flowerSize / 2))

        return CGPoint(x: x, y: y)
    }
}

#Preview {
    ContentView()
}
