import Foundation
import SocketIO

public final class SocketService {
    private let manager: SocketManager
    public private(set) var socket: SocketIOClient

    public init() {
        let url = URL(string: "https://stream.etrade.com")!
        manager = SocketManager(
            socketURL: url,
            config: [.log(true), .compress, .forceWebsockets(true)]
        )
        socket = manager.defaultSocket
    }

    public func connect() {
        Logger.log("[DEBUG] SocketService connecting to \(manager.socketURL)")
        socket.connect()
    }

    public func subscribeTo(symbol: String, handler: @escaping (Trade) -> Void) {
        let event = "trade_\(symbol)"
        Logger.log("[DEBUG] subscribing to event: \(event)")
        socket.on(event) { data, ack in
            Logger.log("[DEBUG] socket event \(event) data: \(data)")
            guard let dict = data.first as? [String: Any],
                  let json = try? JSONSerialization.data(withJSONObject: dict),
                  let trade = try? JSONDecoder().decode(Trade.self, from: json) else {
                Logger.log("[DEBUG] socket payload parse failed")
                return
            }
            Logger.log("[DEBUG] parsed trade: \(trade)")
            handler(trade)
        }
    }
}

