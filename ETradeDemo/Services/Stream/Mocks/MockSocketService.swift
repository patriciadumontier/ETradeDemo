import Foundation

public final class MockSocketService: StreamingService {
    private var timer: Timer?
    private let symbols: [String]

    public init(symbols: [String] = ["AAPL", "GOOG"]) {
        self.symbols = symbols
    }

    public func connect() {
        // no-op
    }

    public func subscribeTo(symbol: String, handler: @escaping (Trade) -> Void) {
        // simulate a trade update every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let trade = Trade(
                id: UUID().uuidString,
                symbol: symbol,
                price: Double.random(in: 100...3000),
                quantity: Double.random(in: 1...100),
                timestamp: Date()
            )
            handler(trade)
        }
    }
}
