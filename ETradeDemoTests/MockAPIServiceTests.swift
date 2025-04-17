import XCTest
@testable import ETradeDemo

final class MockAPIServiceTests: XCTestCase {
    func testFetchTradesPublisherReturnsSampleData() {
        let service = MockAPIService()
        let expectation = XCTestExpectation(description: "Publisher emits sample trades")
        var received: [Trade] = []

        let cancellable = service.fetchTradesPublisher()
            .sink(receiveCompletion: { _ in }, receiveValue: { trades in
                received = trades
                expectation.fulfill()
            })

        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received.first?.symbol, "AAPL")
        cancellable.cancel()
    }

    func testGetLatestTradesAsyncReturnsSampleData() async throws {
        let service = MockAPIService()
        let trades = try await service.getLatestTrades()
        XCTAssertEqual(trades.count, 2)
        XCTAssertEqual(trades.last?.symbol, "GOOG")
    }
}
