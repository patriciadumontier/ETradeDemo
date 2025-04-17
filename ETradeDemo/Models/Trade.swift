import Foundation

public struct Trade: Codable, Identifiable {
    public let id: String
    public let symbol: String
    public let price: Double
    public let quantity: Double
    public let timestamp: Date
}
