//
//  EALogFormattingVariables.swift
//  EALog-iOS
//
//  Created by 李二狗 on 2018/6/6.
//

import Foundation

/// The set of substitution "variables" that can be used when formatting the
/// messages to be logged.
public enum EALogFormattingVariables: String {
    /// The message being logged.
    case message = "(%msg)"
    /// The name of the function invoking the formatter API.
    case function = "(%func)"
    /// The line in the source code of the function invoking the formatter API.
    case line = "(%line)"
    /// The file containing the source code of the function invoking the formatter API.
    case file = "(%file)"
    /// The type of the logged message (i.e. error, warning, etc.).
    case logType = "(%type)"
    /// The time and date at which the message was logged.
    case date = "(%date)"
    
    static let all: [EALogFormattingVariables] = [
        .message, .function, .line, .file, .logType, .date
    ]
}
