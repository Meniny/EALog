//
//  EALogger.swift
//  EALog-iOS
//
//  Created by 李二狗 on 2018/6/6.
//

import Foundation

/// A class of static members used by anyone who wants to log messages.
public class EALogger {
    
    /// An instance of the formatter. It should usually be the one and only reference
    /// of the `EALogFormatter` protocol implementation in the system.
    public static var formatter: EALogFormatter = EADefaultLogFormatter.init()
    
    /// Log a message for use when in verbose logging mode.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public static func verbose(_ msg: Any?..., functionName: String = #function,
                               lineNum: Int = #line, fileName: String = #file ) {
        if formatter.isLogging(.verbose) {
            formatter.log( .verbose, msg: msg,
                        functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log an informational message.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func info(_ msg: Any?..., functionName: String = #function,
                           lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.info) {
            formatter.log( .info, msg: msg,
                        functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log an informational message. Same as `EALogger.info(...)`
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func log(_ msg: Any?..., functionName: String = #function,
                           lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.info) {
            formatter.log( .info, msg: msg,
                           functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log a warning message.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func warning(_ msg: Any?..., functionName: String = #function,
                              lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.warning) {
            formatter.log( .warning, msg: msg,
                        functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log an error message.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func error(_ msg: Any?..., functionName: String = #function,
                            lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.error) {
            formatter.log( .error, msg: msg,
                        functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log a debugging message.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func debug(_ msg: Any?..., functionName: String = #function,
                            lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.debug) {
            formatter.log( .debug, msg: msg,
                        functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log a message when entering a function.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func entry(_ msg: Any?..., functionName: String = #function,
                            lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.entry) {
            formatter.log(.entry, msg: msg,
                       functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Log a message when exiting a function.
    ///
    /// - Parameter msg: The messages to be logged.
    /// - Parameter functionName: The name of the function invoking the formatter API.
    ///                          Defaults to the name of the function invoking
    ///                          this function.
    /// - Parameter lineNum: The line in the source code of the function invoking the
    ///                     formatter API. Defaults to the line of the
    ///                     function invoking this function.
    /// - Parameter fileName: The file containing the source code of the function invoking the
    ///                      formatter API. Defaults to the name of the file containing the function
    ///                      which invokes this function.
    public class func exit(_ msg: Any?..., functionName: String = #function,
                           lineNum: Int = #line, fileName: String = #file) {
        if formatter.isLogging(.exit) {
            formatter.log(.exit, msg: msg,
                       functionName: functionName, lineNum: lineNum, fileName: fileName)
        }
    }
    
    /// Indicates if a message with a specified type (`EALoggingLevel`) will be in the formatter
    /// output (i.e. will not be filtered out).
    ///
    /// - Parameter type: The type of message (`EALoggingLevel`).
    ///
    /// - Returns: A Boolean indicating whether a message of the specified type
    ///           (`EALoggingLevel`) will be in the formatter output.
    public class func isLogging(_ level: EALoggingLevel) -> Bool {
        return formatter.isLogging(level)
    }
}

public typealias EALog = EALogger
public typealias Logger = EALogger
