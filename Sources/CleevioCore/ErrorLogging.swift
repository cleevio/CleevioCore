import Foundation

public protocol ErrorLogging {
    func log(_ error: Error, file: String, function: String, line: Int)
}

public extension ErrorLogging {
    func log(_ error: Error, file: String = #file, function: String = #function, errorLine: Int = #line) {
        log(error, file: file, function: function, line: errorLine)
    }
}
