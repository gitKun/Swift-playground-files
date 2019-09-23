import Foundation

extension Substring {
    var nextWordRange: Range<Index> {
        let start = drop(while: { $0 == " " })
        let end = start.firstIndex(where: { $0 == " " }) ?? endIndex
        return start.startIndex..<end
    }
}

/*
 Collection 协议中，通过索引查找某个元素的操作属于 O(1),例如 String 中通过 index 查找某个 Character
 
 let str = "hello"
 let cStr = str[str.startIndex]
 */


struct Words: Collection {
    let string: Substring
    let startIndex: WordsIndex
    
    init(_ s: String) {
        self.init(s[...])
    }
    
    private init(_ s: Substring) {
        self.string = s
        self.startIndex = WordsIndex(string.nextWordRange)
    }
    
    var endIndex: WordsIndex {
        let e = string.endIndex
        return WordsIndex(e..<e)
    }
}

extension Words {
    subscript(index: WordsIndex) -> Substring {
        return string[index.range]
    }
}

extension Words {
    subscript(rang: Range<WordsIndex>) -> Words {
        let start = rang.lowerBound.range.lowerBound
        let end = rang.upperBound.range.upperBound
        return Words(string[start..<end])
    }
}

extension Words {
    func index(after i: WordsIndex) -> WordsIndex {
        guard i.range.upperBound < string.endIndex else {
            return endIndex
        }
        let remainder = string[i.range.upperBound...]
        return WordsIndex(remainder.nextWordRange)
    }
}


struct WordsIndex: Comparable {
    fileprivate let range: Range<Substring.Index>
    fileprivate init(_ value: Range<Substring.Index>) {
        self.range = value
    }
    static func <(lhs: Words.Index, rhs: Words.Index) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
    static func ==(lhs: Words.Index, rhs: Words.Index) -> Bool {
        return lhs.range == rhs.range
    }
}

let arrayElement = Words("Hello world test").prefix(2)

print("Array = \(Array.init(arrayElement))")

