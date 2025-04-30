import Foundation
import Combine

public final class APIClient: APIService {
    private let session: URLSession
    private let baseURL = URL(string: "https://apisb.etrade.com/v1")!
    private let consumerKey: String = "" // TODO:
    private let accessToken: String = "" // TODO:
    private let signature: String = "" // TODO:

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchTradesPublisher() -> AnyPublisher<[Trade], Error> {
        let url = baseURL.appendingPathComponent("market/trades")
        let request = authorizedRequest(for: url)
        Logger.log("[DEBUG] fetchTradesPublisher - requesting URL: \(url.absoluteString)")
        Logger.log("[DEBUG] request headers: \(request.allHTTPHeaderFields ?? [:])")

        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
                if let httpResp = output.response as? HTTPURLResponse {
                    Logger.log("[DEBUG] HTTP status code: \(httpResp.statusCode)")
                }
            })
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                let jsonStr = String(data: data, encoding: .utf8) ?? "<non-UTF8 data>"
                Logger.log("[DEBUG] raw response data: \(jsonStr)")
            })
            .decode(type: [Trade].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .handleEvents(receiveOutput: { trades in
                Logger.log("[DEBUG] decoded trades: \(trades)")
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getLatestTrades() async throws -> [Trade] {
        let url = baseURL.appendingPathComponent("market/trades")
        let request = authorizedRequest(for: url)
        Logger.log("[DEBUG] getLatestTrades - requesting URL: \(url)")
        let (data, response) = try await session.data(for: request)
        if let httpResp = response as? HTTPURLResponse {
            Logger.log("[DEBUG] HTTP status code: \(httpResp.statusCode)")
        }
        let jsonStr = String(data: data, encoding: .utf8) ?? "<non-UTF8 data>"
        Logger.log("[DEBUG] raw response data: \(jsonStr)")
        let trades = try Self.jsonDecoder.decode([Trade].self, from: data)
        Logger.log("[DEBUG] decoded trades: \(trades)")
        return trades
    }

    private func authorizedRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let nonce = UUID().uuidString
        let authHeader = "OAuth oauth_consumer_key=\"\(consumerKey)\"," +
                         " oauth_token=\"\(accessToken)\"," +
                         " oauth_signature_method=\"HMAC-SHA1\"," +
                         " oauth_signature=\"\(signature)\"," +
                         " oauth_timestamp=\"\(timestamp)\"," +
                         " oauth_nonce=\"\(nonce)\""
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }

    private static var jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}
