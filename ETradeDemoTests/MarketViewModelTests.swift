import XCTest
import Combine
@testable import ETradeDemo

final class MarketViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testLoadTradesUpdatesTrades() {
        let viewModel = MarketViewModel(apiService: MockAPIService(), streamingService: MockSocketService())
        let exp = expectation(description: "loadTrades updates trades")

        viewModel.$trades
            .dropFirst() // ignore initial empty
            .sink { trades in
                if trades.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadTrades()
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(viewModel.trades.count, 2)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSubscribeStreamingInsertsNewTrades() {
        let viewModel = MarketViewModel(apiService: MockAPIService(), streamingService: MockSocketService(symbols: ["TEST"]))
        let exp = expectation(description: "Mock socket emits trade")

        viewModel.$trades
            .dropFirst() // ignore initial empty
            .sink { trades in
                if !trades.isEmpty {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        // subscription starts automatically in init
        wait(for: [exp], timeout: 6)
        XCTAssertFalse(viewModel.trades.isEmpty)
    }
}
