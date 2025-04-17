import Combine

public protocol APIService {
    // Combine version
    func fetchTradesPublisher() -> AnyPublisher<[Trade], Error>
    // Async/Await version
    func getLatestTrades() async throws -> [Trade]
}
