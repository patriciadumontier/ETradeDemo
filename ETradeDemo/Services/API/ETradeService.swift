import Foundation
import Combine

public final class ETradeService {
    private let baseURL = URL(string: "https://apisb.etrade.com/v1")!

    public init() {}

    public func getLatestTrades() async throws -> [Trade] {
        let url = baseURL.appendingPathComponent("market/trades")
        Logger.log("[DEBUG] getLatestTrades - fetching URL: \(url.absoluteString)")
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        if let httpResp = urlResponse as? HTTPURLResponse {
            print("Status code:", httpResp.statusCode)
        }
        Logger.log("[DEBUG] raw response data: \(String(data: data, encoding: .utf8) ?? "<invalid utf8>")")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let trades = try decoder.decode([Trade].self, from: data)
            Logger.log("[DEBUG] decoded trades: \(trades)")
            return trades
        } catch {
            Logger.log("[DEBUG] decode error: \(error)")
            throw error
        }
    }
}
