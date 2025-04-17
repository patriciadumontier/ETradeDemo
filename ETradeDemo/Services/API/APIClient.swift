import Foundation
import Combine

public final class APIClient: APIService {
    private let session: URLSession
    private let baseURL = URL(string: "https://api.etrade.com/v1")!

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchTradesPublisher() -> AnyPublisher<[Trade], Error> {
        let url = baseURL.appendingPathComponent("market/trades")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // TODO: Add E*TRADE auth headers: e.g. Consumer Key, OAuth token
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
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ... add auth headers
        let (data, _) = try await session.data(for: request)
        return try Self.jsonDecoder.decode([Trade].self, from: data)
    }

    private static var jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}
