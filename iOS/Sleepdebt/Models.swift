import Foundation

struct Entry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var value: Double
}
