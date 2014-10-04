//
//  SwiftHelpers.swift
//  Lumberjack
//
//  Created by C.W. Betts on 9/25/14.
//
//

import Foundation

extension DDLogFlag {
    public static func fromLogLevel(logLevel: DDLogLevel) -> DDLogFlag {
        return DDLogFlag(logLevel.rawValue)
    }
    
    public func toLogLevel() -> DDLogLevel? {
        return DDLogLevel(rawValue: self.rawValue)
    }
}

extension DDLog {
    public class var registeredClassesArray: [AnyClass] {
        return registeredClasses() as [AnyClass]
    }
    
    public class var registeredClassNamesArray: [String] {
        return registeredClassNames() as [String]
    }
}

extension DDASLLogCapture {
    class var captureLogLevels: DDLogLevel {
        get {
            return captureLogLevel()
        }
        set {
            setCaptureLogLevel(newValue)
        }
    }
}

extension DDContextWhitelistFilterLogFormatter {
    var whitelistArray: [Int32] {
        let ourWhitelist = self.whitelist as [Int]
        var toRet = [Int32]()
        for i in ourWhitelist {
            toRet.append(Int32(i))
        }
        return toRet
    }
}

extension DDContextBlacklistFilterLogFormatter {
    var blacklistArray: [Int32] {
        let ourBlacklist = self.blacklist as [Int]
        var toRet = [Int32]()
        for i in ourBlacklist {
            toRet.append(Int32(i))
        }
        return toRet
    }
}

extension DDMultiFormatter {
    var formatterArray: [DDLogFormatter] {
        return self.formatters as [DDLogFormatter]
    }
}

private var debugLevel = DDLogLevel.Warning

public func setDefaultDebugLevel(level: DDLogLevel) {
    debugLevel = level
}

public func SwiftLogMacro(isAsynchronous: Bool, level lvl: DDLogLevel, flag flg: DDLogFlag, context: Int32 = 0, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, #format: String, #args: CVaListPointer) {
    let string = NSString(format: format, arguments: args) as String
    SwiftLogMacro(isAsynchronous, level: lvl, flag: flg, context: context, file: file, function: function, line: line, tag: tag, string)
}
public func SwiftLogMacro(isAsynchronous: Bool, level lvl: DDLogLevel, flag flg: DDLogFlag, context: Int32 = 0, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, string: String) {
    // I'm not certain how Swift strings to NSStrings to C Strings, and if they are kept in memory.
    // So tell the DDLogMessage constructor to copy the C strings that get passed to it.
	let logMessage = DDLogMessage(logMsg: string, level: lvl, flag: flg, context: context, file: file.fileSystemRepresentation(), function: (function as NSString).UTF8String, line: Int32(line), tag: tag, options: .CopyFile | .CopyFunction)
    DDLog.log(isAsynchronous, message: logMessage)
}

public func DDLogDebug(logText: String, level: DDLogLevel = debugLevel, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true, #args: CVarArgType...) {
    SwiftLogMacro(async, level: level, flag: .Debug, file: file, function: function, line: line, format: logText, args: getVaList(args))
}

public func DDLogInfo(logText: String, level: DDLogLevel = debugLevel, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true, #args: CVarArgType...) {
    SwiftLogMacro(async, level: level, flag: .Info, file: file, function: function, line: line, format: logText, args: getVaList(args))
}

public func DDLogWarn(logText: String, level: DDLogLevel = debugLevel, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true, #args: CVarArgType...) {
    SwiftLogMacro(async, level: level, flag: .Warning, file: file, function: function, line: line, format: logText, args: getVaList(args))
}

public func DDLogVerbose(logText: String, level: DDLogLevel = debugLevel, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true, #args: CVarArgType...) {
    SwiftLogMacro(async, level: level, flag: .Verbose, file: file, function: function, line: line, format: logText, args: getVaList(args))
}

public func DDLogError(logText: String, level: DDLogLevel = debugLevel, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = false, #args: CVarArgType...) {
    SwiftLogMacro(async, level: level, flag: .Error, file: file, function: function, line: line, format: logText, args: getVaList(args))
}

public func CurrentFileName(fileName: String = __FILE__) -> String {
    return fileName.lastPathComponent.stringByDeletingPathExtension
}
