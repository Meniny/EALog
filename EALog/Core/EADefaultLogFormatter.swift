
import Foundation

/// A lightweight implementation of the `EALogFormatter` protocol.
public class EADefaultLogFormatter {
    
    /// The set of colors used when logging with colorized lines.
    public enum TerminalColor: String {
        /// Log text in white.
        case white = "\u{001B}[0;37m" // white
        /// Log text in red, used for error messages.
        case red = "\u{001B}[0;31m" // red
        /// Log text in yellow, used for warning messages.
        case yellow = "\u{001B}[0;33m" // yellow
        /// Log text in the terminal's default foreground color.
        case foreground = "\u{001B}[0;39m" // default foreground color
        /// Log text in the terminal's default background color.
        case background = "\u{001B}[0;49m" // default background color
    }

    /// A Boolean value that indicates whether the formatter output should be colorized.
    ///
    ///### Usage Example: ###
    /// The formatter is set up to log `verbose` level messages (this is the default) and all levels below,
    /// that is, it will show messages of type `verbose`, `info`, `warning` and `error`.
    ///```swift
    ///let formatter = EADefaultLogFormatter()
    ///formatter.colored = true
    ///EALogger.formatter = formatter
    ///EALogger.error("This message will be red when your application is run in the terminal.")
    ///```
    public var colored: Bool = false
    
    /// A Boolean value indicating whether to use the emojis for the detailed logging format when a user logging format is not specified.
    public var useEmojis: Bool = false

    /// A Boolean value indicating whether to use the detailed logging format when a user logging format is not
    /// specified.
    public var details: Bool = true

    /// A Boolean value indicating whether to use the full file path, or just the filename.
    public var fullFilePath: Bool = false

    /// The user specified logging format, if `format` is not `nil`.
    ///
    /// For example: "[(%date)] [(%type)] [(%file):(%line) (%func)] (%msg)".
    public var format: String? {
        didSet {
            if let format = self.format {
                customFormatter = EADefaultLogFormatter.parseFormat(format)
            } else {
                customFormatter = nil
            }
        }
    }

    /// The format used when adding the date and time to logged messages, if `dateFormat` is not `nil`.
    public var dateFormat: String? {
        didSet {
            dateFormatter = EADefaultLogFormatter.getDateFormatter(format: dateFormat, timeZone: timeZone)
        }
    }

    /// The timezone used in the date time format, if `timeZone` is not `nil`.
    public var timeZone: TimeZone? {
        didSet {
            dateFormatter = EADefaultLogFormatter.getDateFormatter(format: dateFormat, timeZone: timeZone)
        }
    }

    /// Default date format - ISO 8601.
    public static let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

    fileprivate var dateFormatter: DateFormatter = EADefaultLogFormatter.getDateFormatter()

    internal static func getDateFormatter(format: String? = nil, timeZone: TimeZone? = nil) -> DateFormatter {
        let formatter = DateFormatter()

        if let dateFormat = format {
            formatter.dateFormat = dateFormat
        } else {
            formatter.dateFormat = defaultDateFormat
        }

        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }

        return formatter
    }

    #if os(Linux) && !swift(>=3.1)
    typealias NSRegularExpression = RegularExpression
    #endif

    private static var tokenRegex: NSRegularExpression? = {
        do {
            return try NSRegularExpression(pattern: "\\(%\\w+\\)", options: [])
        } catch {
            print("Error creating EADefaultLogFormatter tokenRegex: \(error)")
            return nil
        }
    }()

    fileprivate var customFormatter: [LogSegment]?

    public enum LogSegment: Equatable {
        case token(EALogFormattingVariables)
        case literal(String)

        public static func == (lhs: LogSegment, rhs: LogSegment) -> Bool {
            switch (lhs, rhs) {
            case (.token(let lhsToken), .token(let rhsToken)) where lhsToken == rhsToken:
                return true
            case (.literal(let lhsLiteral), .literal(let rhsLiteral)) where lhsLiteral == rhsLiteral:
                return true
            default:
                return false
            }
        }
    }

    internal static func parseFormat(_ format: String) -> [LogSegment] {
        var logSegments = [LogSegment]()

        let nsFormat = NSString(string: format)
        let matches = tokenRegex!.matches(in: format, options: [], range: NSMakeRange(0, nsFormat.length))

        guard !matches.isEmpty else {
            // entire format is a literal, probably a typo in the format
            logSegments.append(LogSegment.literal(format))
            return logSegments
        }

        var loc = 0
        for (index, match) in matches.enumerated() {
            // possible literal segment before token match
            if loc < match.range.location {
                let segment = nsFormat.substring(with: NSMakeRange(loc, match.range.location - loc))
                if !segment.isEmpty {
                    logSegments.append(LogSegment.literal(segment))
                }
            }

            // token regex match, may not be a valid formatValue
            let segment = nsFormat.substring(with: match.range)
            loc = match.range.location + match.range.length
            if let formatValue = EALogFormattingVariables(rawValue: segment) {
                logSegments.append(LogSegment.token(formatValue))
            } else {
                logSegments.append(LogSegment.literal(segment))
            }

            // possible literal segment after LAST token match
            let nextIndex = index + 1
            if nextIndex >= matches.count {
                let segment = nsFormat.substring(from: loc)
                if !segment.isEmpty {
                    logSegments.append(LogSegment.literal(segment))
                }
            }
        }

        return logSegments
    }

    /// Create a `EADefaultLogFormatter` instance and set it up as the formatter used by the `EALogFormatter`
    /// protocol.
    ///
    ///### Usage Example: ###
    /// In the default case, the formatter is set up to log `verbose` level messages and all levels below,
    /// that is, it will show messages of type `verbose`, `info`, `warning` and `error`.
    ///```swift
    ///EADefaultLogFormatter.use()
    ///```
    /// In the following example, the formatter is set up to log `warning` level messages and all levels below, i.e.
    /// it will show messages of type `warning` and `error`.
    ///```swift
    ///EADefaultLogFormatter.use(.warning)
    ///```
    /// - Parameter type: The most detailed message type (`EALoggingLevel`) to see in the
    ///                  output of the formatter. Defaults to `verbose`.
    public class func use(_ type: EALoggingLevel = .verbose) {
        EALogger.formatter = EADefaultLogFormatter(type)
        setbuf(stdout, nil)
    }

    fileprivate let type: EALoggingLevel

    /// Create a `EADefaultLogFormatter` instance.
    ///
    /// - Parameter type: The most detailed message type (`EALoggingLevel`) to see in the
    ///                  output of the formatter. Defaults to `verbose`.
    public init (_ type: EALoggingLevel = .verbose) {
        self.type = type
    }

    internal func doPrint(_ message: String) {
        print(message)
    }
}

/// Implement the `EALogFormatter` protocol in the `EADefaultLogFormatter` class.
extension EADefaultLogFormatter: EALogFormatter {
    
    /// Output a logged message.
    ///
    /// - Parameter type: The type of the message (`EALoggingLevel`) being logged.
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API.
    public func log(_ type: EALoggingLevel, msg: [Any?],
                    functionName: String, lineNum: Int, fileName: String ) {

        guard isLogging(type) else {
            return
        }

        let message = formatEntry(type: type, msg: msg, functionName: functionName, lineNum: lineNum, fileName: fileName)
        doPrint(message)
    }
    
    internal static let separatorBegin = "-----------------------"
    internal static let separatorStop  = "-----------------------"

    internal func formatEntry(type: EALoggingLevel, msg: [Any?],
                     functionName: String, lineNum: Int, fileName: String) -> String {

        let message: String
        if let formatter = customFormatter {
            var line = ""
            for logSegment in formatter {
                let value: String

                switch logSegment {
                case .literal(let literal):
                    value = literal
                case .token(let token):
                    switch token {
                    case .date:
                        value = formatDate()
                    case .logType:
                        value = type.description
                    case .file:
                        value = getFile(fileName)
                    case .line:
                        value = "\(lineNum)"
                    case .function:
                        value = functionName
                    case .message:
                        value = formatAnyArray(msg)
                    }
                }

                line.append(value)
            }
            message = line
        } else if details {
            message = [
                EADefaultLogFormatter.separatorBegin,
                "[DATE: \(formatDate())]",
                "[TYPE: \(useEmojis ? type.emoji : type.description)]",
                "[FILE: \(getFile(fileName)): \(lineNum)]",
                "[FUNC: \(functionName)]",
                formatAnyArray(msg),
                EADefaultLogFormatter.separatorStop].joined(separator: "\n")
        } else {
            message = [
                "[\(formatDate())] [\(type)]",
                formatAnyArray(msg)].joined(separator: "\n")
        }

        guard colored else {
            return message
        }

        let color: TerminalColor
        switch type {
        case .warning:
            color = .yellow
        case .error:
            color = .red
        default:
            color = .foreground
        }

        return color.rawValue + message + TerminalColor.foreground.rawValue
    }
    
    internal func formatAnyArray(_ array: [Any?], separator: String = "\n\n") -> String {
        return array.map({ (oi) -> String in
            if let i = oi {
                if let s = i as? String {
                    return s
                }
                return String.init(describing: i)
            }
            return String.init(describing: oi)
        }).joined(separator: separator)
    }

    internal func formatDate(_ date: Date = Date()) -> String {
        return dateFormatter.string(from: date)
    }

    internal func getFile(_ path: String) -> String {
        if self.fullFilePath {
            return path
        }
        guard let range = path.range(of: "/", options: .backwards) else {
            return path
        }

        #if swift(>=3.2)
            return String(path[range.upperBound...])
        #else
            return path.substring(from: range.upperBound)
        #endif
    }

    /// Indicates if a message with a specified type (`EALoggingLevel`) will be in the formatter
    /// output (i.e. will not be filtered out).
    ///
    ///### Usage Example: ###
    /// The formatter is set up to log `warning` level messages and all levels below, that is, it will
    /// show messages of type `warning` and `error`. This means a `verbose` level message will not be displayed.
    ///```swift
    ///let formatter = EADefaultLogFormatter(.warning)
    ///EALogger.formatter = formatter
    ///formatter.isLogging(.warning) // Returns true
    ///formatter.isLogging(.verbose) // Returns false
    ///```
    /// - Parameter type: The type of message (`EALoggingLevel`).
    ///
    /// - Returns: A Boolean indicating whether a message of the specified type
    ///           (`EALoggingLevel`) will be in the formatter output.
    public func isLogging(_ type: EALoggingLevel) -> Bool {
        return type.rawValue >= self.type.rawValue
    }
}
