import Foundation
import Combine

@MainActor
class ChatVM: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published var currentText: String = ""
    @Published var isConnected: Bool = false

    private let chatManager = ChatSocketManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        chatManager.messagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.messages.append(message)
            }
            .store(in: &cancellables)
    }

    func connect() {
        chatManager.connect()
        isConnected = true
    }

    func disconnect() {
        chatManager.disconnect()
        isConnected = false
    }

    func sendMessage() {
      guard isConnected else {
        // Optionally show an alert or queue the message
        print("⚠️ Not connected yet, dropping message")
        return
      }
      let msg = Message(text: currentText)
      messages.append(msg)
        chatManager.send(message: msg)
      currentText = ""
    }
}
