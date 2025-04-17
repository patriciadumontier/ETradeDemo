import XCTest
import Combine
@testable import ETradeDemo

@MainActor
final class ChatViewModelTests: XCTestCase {
    private var viewModel: ChatVM!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = ChatVM()
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testConnectAndDisconnectToggleState() {
        XCTAssertFalse(viewModel.isConnected)
        viewModel.connect()
        XCTAssertTrue(viewModel.isConnected)
        viewModel.disconnect()
        XCTAssertFalse(viewModel.isConnected)
    }

    func testSendMessageAppendsMessageAndClearsInput() {
        // Prepare
        viewModel.currentText = "Hello"
        let exp = expectation(description: "Message sent")

        // Observe messages
        viewModel.$messages
            .dropFirst()
            .sink { messages in
                XCTAssertEqual(messages.count, 1)
                XCTAssertEqual(messages.first?.text, "Hello")
                exp.fulfill()
            }
            .store(in: &cancellables)

        // Act
        viewModel.connect()
        viewModel.sendMessage()

        // Assert messages
        waitForExpectations(timeout: 1.0)

        // Assert input cleared
        XCTAssertEqual(viewModel.currentText, "", "Input should be cleared after send")
    }
}
