
import Foundation

/// The type of a particular log message. It is passed with the message to be logged to the
/// actual formatter implementation. It is also used to enable filtering of the log based
/// on the minimal type to log.
public enum EALoggingLevel: Int {
    /// Log message type for logging when entering into a function.
    case entry = 1
    /// Log message type for logging when exiting from a function.
    case exit = 2
    /// Log message type for logging a debugging message.
    case debug = 3
    /// Log message type for logging messages in verbose mode.
    case verbose = 4
    /// Log message type for logging an informational message.
    case info = 5
    /// Log message type for logging a warning message.
    case warning = 6
    /// Log message type for logging an error message.
    case error = 7
}

/// Implement the `CustomStringConvertible` protocol for the `EALoggingLevel` enum
extension EALoggingLevel: CustomStringConvertible {
    /// Convert a `EALoggingLevel` into a printable format.
    public var description: String {
        switch self {
        case .entry:
            return "Entry"
        case .exit:
            return "Exit"
        case .debug:
            return "Debug"
        case .verbose:
            return "Verbose"
        case .info:
            return "Information"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        }
    }
    
    public var emoji: String {
        switch self {
        case .entry:
            return "▶️"
        case .exit:
            return "⏏️"
        case .debug:
            return "🔵"
        case .verbose:
            return "💬"
        case .info:
            return "❇️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        }
    }
}
