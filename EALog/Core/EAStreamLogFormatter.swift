
import Foundation

/// A `EADefaultLogFormatter`, that prints to a TextOutputStream.
public class EAStreamLogFormatter<OutputStream: TextOutputStream>: EADefaultLogFormatter {

    // stream to output the log to
    private var outputStream: OutputStream

    /// Create a `EAStreamLogFormatter` instance and set it up as the formatter used by the `LoggerAPI`
    /// protocol.
    /// ### Usage Example: ###
    /// This example shows logging to stderr.
    /// ```swift
    /// struct StandardError: TextOutputStream {
    ///     func write(_ text: String) {
    ///         guard let data = text.data(using: String.Encoding.utf8) else {
    ///           return
    ///         }
    ///         FileHandle.standardError.write(data)
    ///     }
    /// }
    ///
    /// let se = StandardError()
    /// EAStreamLogFormatter.use(outputStream: se)
    /// ```
    /// - Parameter type: The most detailed message type (`EALoggingLevel`) to see in the
    ///                  output of the formatter. Defaults to `verbose`.
    /// - Parameter outputStream: The stream to send the output of the formatter to.
    public static func use(_ type: EALoggingLevel = .verbose, outputStream: OutputStream) {
        EALogger.formatter = EAStreamLogFormatter(type, outputStream: outputStream)
    }

    /// Prevent the user accidentally invoking the use() function of the superclass.
    /// Prints an error message, stating that you should call `use(_:outputStream:)`,
    /// no logging is enabled.
    ///
    /// - Parameter type: The most detailed message type (`EALoggingLevel`) to see in the
    ///                  output of the formatter. Default to `verbose`.
    override public class func use(_ type: EALoggingLevel = .verbose) {
        print("Unable to instantiate EAStreamLogFormatter. " +
              "Use EAStreamLogFormatter.use(:EALoggingLevel:OutputStream) function.")
    }

    /// Create a `EAStreamLogFormatter` instance.
    ///
    /// - Parameter type: The most detailed message type (`EALoggingLevel`) to see in the
    ///                  output of the formatter. Defaults to `verbose`.
    /// - Parameter outputStream: The stream to send the output of the formatter to.
    public init (_ type: EALoggingLevel = .verbose, outputStream: OutputStream) {
        self.outputStream = outputStream
        super.init(type)
    }

    internal override func doPrint(_ message: String) {
        print(message, to: &outputStream)
    }
}
