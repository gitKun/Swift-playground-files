import Foundation
//import UIKit

// 简单的正则表达式应该匹配 ^ $ . *
public struct Regex {
    private let regexp: String
    // 从一个正则表达式字符串构建
    public init(_ regexp: String) {
        self.regexp = regexp
    }
}

extension Regex {
    public func match(_ text: String) -> Bool {
        // 正则表达式以 ^ 起始
        if regexp.first == "^" {
            return Regex.matchHere(regexp: regexp.dropFirst(), text: text[...])
        }
        // 否则，在输入的每个部分进行搜索，直到发现匹配
        var idx = text.startIndex
        
        while true {
            if Regex.matchHere(regexp: regexp[...], text: text.suffix(from: idx)) {
                return true
            }
            guard idx != text.endIndex else { break }
            text.formIndex(after: &idx)
        }
        return false
    }
}


extension Regex {
    private static func matchHere(regexp: Substring, text: Substring) -> Bool {
        // l空的正则表达式可以匹配所有
        if regexp.isEmpty {
            return true
        }
        // 所有跟在 * 后面的字符都要调用 matchStar
        if let c = regexp.first, regexp.dropFirst().first == "*" {
            return matchStar(character: c, regexp: regexp.dropFirst(2), text: text)
        }
        // 如果已经是正则表达式的最后一个字符，而且这个字符是 $
        // 那么当且仅当剩余字符串为空时才匹配
        if regexp.first == "$" && regexp.dropFirst().isEmpty {
            return text.isEmpty
        }
        // 如果当前字符匹配了，那么就从输入的字符串和正则表达式中将其丢弃，
        // 然后继续进行接下来的匹配
        if let tc = text.first, let rc = regexp.first, rc == "." || tc == rc {
            return matchHere(regexp: regexp.dropFirst(), text: text.dropFirst())
        }
        
        // 以上都不成立则返回 false
        return false
    }
    
    /// 在文本开头查找零个或多个传入的 `c` 字符
    ///
    /// - Parameters:
    ///   - c: 需要被匹配的字符
    ///   - regexp: 正则表达式
    ///   - text: 被匹配的字符串
    /// - Returns: 返回结果
    private static func matchStar(character c: Character, regexp: Substring, text: Substring) -> Bool {
        var idx = text.startIndex
        while true {
            if matchHere(regexp: regexp, text: text.suffix(from: idx)) {
                return true
            }
            if idx == text.endIndex || (text[idx] != c && c != ".") {
                return false
            }
            text.formIndex(after: &idx)
        }
    }
}

// 使用匹配器

Regex("^h..lo*!$").match("helloooooo!")// true




/// MARK: ExpressibleByStringLiteral

/*
 "" 是 String 的字面量(ExpressibleByStringLiteral 协议)
 */


//ExpressibleByStringLiteral: ExpressibleByExtendedGraphemeClusterLiteral : ExpressibleByUnicodeScalarLiteral

extension Regex: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        regexp = value
    }
}

// 使用
let r: Regex = "^he..lo*!$"

func findMatches(in strings:[String], regex: Regex) -> [String] {
    return strings.filter { regex.match($0) }
}

findMatches(in: ["foo", "bar", "baz"], regex: "^b..")//["bar", "baz"]

/// MARK: CustomStringConvertible 和 CustomDebugStringConvertible

print(Regex("color?r"))// Regex(regexp: "color?r")

extension Regex: CustomStringConvertible {
    public var description: String {
        return "/\(regexp)/"
    }
}
print(Regex("color?r"))// /color?r/

/// MARK: 文本输出流

/*
 String 是标准库中唯一的输出流类型
 */

var s = ""
let numbers = [1, 2, 3, 4]

print(numbers, to: &s)
s//"[1, 2, 3, 4]\n"

struct ArrayStream: TextOutputStream {
    var buffer: [String] = []
    mutating func write(_ string: String) {
        buffer.append(string)
    }
}

var stream = ArrayStream()
print("Hello ", to: &stream)
print("world", to: &stream)

stream.buffer// ["", "Hello ", "\n", "", "world", "\n"]

extension Data: TextOutputStream {
    public mutating func write(_ string: String) {
        self.append(contentsOf: string.utf8)
    }
}

var utf8Data = Data()
var string = "café"
utf8Data.write(string)
utf8Data

struct SlowStreamer: TextOutputStreamable, ExpressibleByArrayLiteral {
    let contents: [String]
    
    init(arrayLiteral elements: String...) {
        contents = elements
    }
    
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        for x in contents {
            target.write(x)
            target.write("\n")
            sleep(1)
        }
    }
}

let slow: SlowStreamer = [
    "You'll see that this gets",
    "written slowly line by line",
    "to the standard output"
]
print(slow)

struct ReplacingStream: TextOutputStreamable, TextOutputStream {
    let toReplace: KeyValuePairs<String, String>
    private var output = ""
    init(replacing toReplace: KeyValuePairs<String, String>) {
        self.toReplace = toReplace
    }
    mutating func write(_ string: String) {
        let toWrite = toReplace.reduce(string) { partialResult, pair in
            partialResult.replacingOccurrences(of: pair.key, with: pair.value)
        }
        print(toWrite, terminator: "", to: &output)
    }
    
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        output.write(to: &target)
    }
}


var replacer = ReplacingStream(replacing: [
    "in the cloud": "on someone else's computer"
    ])
let source = "People find it convenient to store their data in the cloud."
print(source, terminator: "", to: &replacer)

var output = ""
print(replacer, terminator: "", to: &output)
output






