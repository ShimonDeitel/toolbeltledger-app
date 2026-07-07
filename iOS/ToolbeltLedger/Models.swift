import Foundation

struct BatteryEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var brand: String
    var capacity: String
    var cycleCount: String
    var notes: String = ""
    var createdAt: Date = Date()
}
