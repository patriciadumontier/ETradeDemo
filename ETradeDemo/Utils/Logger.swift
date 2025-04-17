import Foundation

public final class Logger {
    public static func log(_ message: String) {
        #if DEBUG
        print("[ETradeDemo] \(message)")
        #endif
    }
}
