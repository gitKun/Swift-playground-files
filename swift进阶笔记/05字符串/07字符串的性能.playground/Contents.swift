import Foundation
//import UIKit

/// 字符串的性能

/*
 封装 **幻影类型**
 */

protocol StringViewSelector {
    associatedtype View: Collection
    
    static var carat: View.Element { get }// ^
    static var asterisk: View.Element { get }//*
    static var period: View.Element { get }// .
    static var dollar: View.Element { get }// $
    
    static func view(from s: String) -> View
}

struct UTF8ViewSelector: StringViewSelector {
    static var carat: UInt8 { return UInt8(ascii: "^") }
    static var asterisk: UInt8 { return UInt8(ascii: "*") }
    static var period: UInt8 { return UInt8(ascii: "*") }
    static var dollar: UInt8 { return UInt8(ascii: "$") }
    
    static func view(from s: String) -> String.UTF8View {
        return s.utf8
    }
}

struct CharacterViewSelector: StringViewSelector {
    static var carat: Character { return "^" }
    static var asterisk: Character { return "*" }
    static var period: Character { return "*" }
    static var dollar: Character { return "$" }
    
    static func view(from s: String) -> String {
        return s
    }
}


/*
 UTF8ViewSelector 和 CharacterViewSelector 被称作 **幻影类型**
 MemoryLayout<UTF8ViewSelector>.size 返回 0，因为里面没有任何数据
 */
MemoryLayout<UTF8ViewSelector>.size

/// MARK: 使用 幻影类型 重新实现 Regex

struct Regex<V: StringViewSelector>
    where V.View.Element: Equatable
//    ,V.View.SubSequence: Collection
{
    let regexp: String
    // 从正则表达式字符串出初始化
    init(_ regexp: String) {
        self.regexp = regexp
    }
}

extension Regex {
    func match(_ text: String) -> Bool {
        let text = V.view(from: text)
        let regexp = V.view(from: self.regexp)
        // 正则表达式以 ^ 起始
        if regexp.first == V.carat {
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
    private static func matchHere(regexp: V.View.SubSequence, text: V.View.SubSequence) -> Bool {
        // l空的正则表达式可以匹配所有
        if regexp.isEmpty {
            return true
        }
        // 所有跟在 * 后面的字符都要调用 matchStar
        if let c = regexp.first, regexp.dropFirst().first == V.asterisk {
            return matchStar(character: c, regexp: regexp.dropFirst(2), text: text)
        }
        // 如果已经是正则表达式的最后一个字符，而且这个字符是 $
        // 那么当且仅当剩余字符串为空时才匹配
        if regexp.first == V.dollar && regexp.dropFirst().isEmpty {
            return text.isEmpty
        }
        // 如果当前字符匹配了，那么就从输入的字符串和正则表达式中将其丢弃，
        // 然后继续进行接下来的匹配
        if let tc = text.first, let rc = regexp.first, rc == V.period || tc == rc {
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
    private static func matchStar(character c: V.View.Element, regexp: V.View.SubSequence, text: V.View.SubSequence) -> Bool {
        var idx = text.startIndex
        while true {
            if matchHere(regexp: regexp, text: text.suffix(from: idx)) {
                return true
            }
            if idx == text.endIndex || (text[idx] != c && c != V.period) {
                return false
            }
            text.formIndex(after: &idx)
        }
    }
}

// 使用匹配器




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









