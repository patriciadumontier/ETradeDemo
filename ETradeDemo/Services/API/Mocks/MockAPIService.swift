import Foundation
import Combine


public final class MockAPIService: APIService {
    private let sampleTrades: [Trade] = [
        .init(id: "1", symbol: "AAPL", price: 150.0, quantity: 10, timestamp: Date()),
        .init(id: "2", symbol: "GOOG", price: 2750.0, quantity: 2, timestamp: Date())
    ]

    public init() {}

    public func fetchTradesPublisher() -> AnyPublisher<[Trade], Error> {
        Just(sampleTrades)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func getLatestTrades() async throws -> [Trade] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return sampleTrades
    }
}
