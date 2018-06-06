
import Foundation

/// A formatter protocol implemented by EALogFormatter implementations. This API is used by Kitura
/// throughout its implementation when logging.
public protocol EALogFormatter {
    
    /// Output a logged message.
    ///
    /// - Parameter type: The type of the message (`EALoggingLevel`) being logged.
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API.
    func log(_ type: EALoggingLevel, msg: [Any?],
        functionName: String, lineNum: Int, fileName: String)
    
    /// Indicates if a message with a specified type (`EALoggingLevel`) will be in the formatter
    /// output (i.e. will not be filtered out).
    ///
    /// - Parameter type: The type of message (`EALoggingLevel`).
    ///
    /// - Returns: A Boolean indicating whether a message of the specified type
    ///           (`EALoggingLevel`) will be in the formatter output.
    func isLogging(_ level: EALoggingLevel) -> Bool

}


