import Combine

public final class MarketViewModel: ObservableObject {
    @Published public var trades: [Trade] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let apiService: APIService
    private let streamingService: StreamingService

    public init(
        apiService: APIService = {
            #if DEBUG
            return MockAPIService()
            #else
            return APIClient()
            #endif
        }(),
        streamingService: StreamingService = {
            #if DEBUG
            return MockSocketService()
            #else
            return SocketService()
            #endif
        }()
    ) {
        self.apiService = apiService
        self.streamingService = streamingService
        subscribeStreaming()
    }

    public func loadTrades() {
        isLoading = true
        Task {
            do {
                let fetched = try await apiService.getLatestTrades()
                await MainActor.run {
                    self.trades = fetched
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    private func subscribeStreaming() {
        streamingService.connect()
        streamingService.subscribeTo(symbol: "AAPL") { [weak self] trade in
            Task { @MainActor in
                self?.trades.insert(trade, at: 0)
            }
        }
    }
}
