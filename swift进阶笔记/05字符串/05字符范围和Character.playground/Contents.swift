import Foundation
//import UIKit

/*
 Character 并不满足 Strideable 协议
 */

let lowercaseLetters = ("a" as Character)..."z"

lowercaseLetters.contains("A")
lowercaseLetters.contains("é")

extension Unicode.Scalar: Strideable {
    public typealias Stride = Int
    public func distance(to other: Unicode.Scalar) -> Int {
        return Int(other.value) - Int(self.value)
    }
    public func advanced(by n: Int) -> Unicode.Scalar {
        return Unicode.Scalar(UInt32(Int(value) + n))!
    }
}

// 这里忽略 0xD800...0xDFFF 之间的代理编码点不是有效的 Unicode 标量这个事实，构建一个与此区域重合的范围被认为是程序员的错误

let lowercase = ("a" as Unicode.Scalar)..."z"

Array(lowercase.map(Character.init))

//for item in lowercase {
//    print(item)
//}

/// CharacterSet


let favoriteEmoji = CharacterSet("👩‍🚒👨‍🎨".unicodeScalars)
print(favoriteEmoji)
favoriteEmoji.contains("🚒")// true

//CharacterSet.alphanumerics
//CharacterSet.whitespacesAndNewlines



//let sss = "👩‍🚒"
//
//for v in sss.unicodeScalars {
//    print(v.value)
//}

// 将字符串分割为单词
extension String {
    func words(with charset: CharacterSet = .alphanumerics) -> [SubSequence] {
//        return self.unicodeScalars.split { (item :Unicode.Scalar) -> Bool in
//            return !charset.contains(item)
//        }.map(Substring.init)
        return self.unicodeScalars.split { !charset.contains($0) }.map(Substring.init)
    }
}

let code = "struct Array<Element>: Collection {}"
code.words()//["struct", "Array", "Element", "Collection"]

/*
 即使经过了这样相对较多的操作，words 中的字符串切片依然只是原字符串的视图，
 所以它还是会比 components(separatedBy:) 高效得多 (这个方法将返回一个字符串数组，所以需要进行复制)。
 */


/// MARK: String 和 Character 的内部结构

MemoryLayout<Character>.size// 16




