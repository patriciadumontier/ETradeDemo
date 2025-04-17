import Foundation

public protocol StreamingService {
    func connect()
    func subscribeTo(symbol: String, handler: @escaping (Trade) -> Void)
}
