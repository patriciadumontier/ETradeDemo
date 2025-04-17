import Foundation
import SocketIO
import Combine

final class ChatSocketManager {
    static let shared = ChatSocketManager()

    private let manager: SocketManager
    private var socket: SocketIOClient

    private let connectionSubject = PassthroughSubject<Bool, Never>()
    var connectionPublisher: AnyPublisher<Bool, Never> {
      connectionSubject.eraseToAnyPublisher()
    }

    private var reconnectionAttempts = 0
    private let maxReconnectionAttempts = 5

    /// Compile‑time switch for endpoint
    private static var endpointURL: URL {
        #if DEBUG
        // your local dev server
        return URL(string: "http://localhost:3000")!
        #else
        // your production Socket.IO server
        return URL(string: "https://api.yourdomain.com")!
        #endif
    }

    private init() {
        
        manager = SocketManager(
            socketURL: ChatSocketManager.endpointURL,
            config: [
                .log(true),
                .compress,
                .path("/socket.io"),
                .reconnects(false)
            ])
        socket = manager.defaultSocket

        // Connection events
        socket.on(clientEvent: .connect)    { [weak self] _,_ in
            print("ChatSocketManager: connected")
            self?.connectionSubject.send(true)
        }
        socket.on(clientEvent: .disconnect) { [weak self] _,_ in
            print("ChatSocketManager: disconnected")
            self?.connectionSubject.send(false)
        }

        // Incoming chat messages
        socket.on("message") { [weak self] data, _ in
            guard
                let payload = data.first as? [String: Any],
                let jsonData = try? JSONSerialization.data(withJSONObject: payload),
                let message = try? JSONDecoder().decode(Message.self, from: jsonData)
            else { return }
            self?.messageSubject.send(message)
        }
    }

    private func attemptReconnection() {
        guard reconnectionAttempts < maxReconnectionAttempts else {
            print("Max reconnection attempts reached")
            return
        }
        reconnectionAttempts += 1
        let delay = pow(2.0, Double(reconnectionAttempts))
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.socket.connect()
        }
    }

    // MARK: - Public API

    private let messageSubject = PassthroughSubject<Message, Never>()

    var messagesPublisher: AnyPublisher<Message, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: Message) {
        let payload: [String: Any] = ["id": message.id.uuidString,
                                      "text": message.text,
                                      "timestamp": ISO8601DateFormatter().string(from: message.timestamp)]
        socket.emit("message", payload)
    }
}
