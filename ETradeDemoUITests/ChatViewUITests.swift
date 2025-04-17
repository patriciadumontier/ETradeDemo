import XCTest

class ChatViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSendMessageAppearsInList() {
        // 1. Switch to Chat tab
        app.tabBars.buttons["Chat"].tap()

        // 2. Find the text field and type
        let chatField = app.textFields["ChatTextField"]
        XCTAssertTrue(chatField.waitForExistence(timeout: 1))
        chatField.tap()
        chatField.typeText("Hello UI Test")

        // 3. Tap the Send button
        let sendButton = app.buttons["ChatSendButton"]
        XCTAssertTrue(sendButton.exists)
        sendButton.tap()

        // 4. Verify the message shows up
        let sentCell = app.staticTexts["Hello UI Test"]
        XCTAssertTrue(sentCell.waitForExistence(timeout: 1),
                      "The sent message should appear in the chat list")
    }
}
