import Foundation
import SwiftUI

class GratitudeManager: ObservableObject {
    static let shared = GratitudeManager()
    
    @Published var gratitudeEntries: [GratitudeEntry] = []
    @Published var flowerPositions: [CGPoint] = [] // Add flowerPositions here
    
    private init() {
        loadEntries()
    }

    func addEntry(gratitude: String, position: CGPoint) {
        let newEntry = GratitudeEntry(gratitude: gratitude, date: Date(), position: position)
        gratitudeEntries.append(newEntry)
        flowerPositions.append(position) // Store the new flower position
        saveEntries()
    }

    func deleteEntry(at index: Int) {
        guard index >= 0 && index < gratitudeEntries.count else { return }
        gratitudeEntries.remove(at: index)
        flowerPositions.remove(at: index) // Remove the corresponding position
        saveEntries()
    }
    
    private let userDefaultsKey = "gratitudeEntries"

    private func saveEntries() {
        let encodedEntries = gratitudeEntries
        UserDefaults.standard.set(try? PropertyListEncoder().encode(encodedEntries), forKey: userDefaultsKey)
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.value(forKey: userDefaultsKey) as? Data {
            if let decodedEntries = try? PropertyListDecoder().decode([GratitudeEntry].self, from: data) {
                gratitudeEntries = decodedEntries
                flowerPositions = decodedEntries.map { $0.position } // Assign positions here
            }
        }
    }
}
