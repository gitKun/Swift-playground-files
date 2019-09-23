import Foundation
import UIKit


/*
 Swift 中的 String 仍然缺少很多 NSString 中的功能;
 你所看到的 String **实例** 能访问 NSString 的成员，是因为编译器的特殊对待(当导入 Foundation 时);
 如果你忘记引入 Foundation 你可能会奇怪某些方法为什么不可用；
 
 */


let sentence = """
The quick brown fox jumped \
over the lazy dog.
"""
print(sentence)

var words: [String] = []
sentence.enumerateSubstrings(in: sentence.startIndex..., options: .byWords) { (word, range1, range2, _) in
//    print((range1 == range2, range1, range2))
    guard let word = word else { return }
    words.append(word)
}
words// ["The", "quick", "brown", "fox", "jumped", "over", "the", "lazy", "dog"]

/// NSAttributeString NSMutableAttributeString (使用起来并不很 Swift)

let text = "👉 Click here for more info."
let linkTarger = URL(string: "https://www.baidu.com")!
// 尽管使用 let formatted 仍然可变遵从的是引用语义
let formatted = NSMutableAttributedString(string: text)

if let linkRange = formatted.string.range(of: "Click here") {
    // 将 Swift 的 Range<String.Index> 转换为 NSRange
    let nsRange = NSRange(linkRange, in: formatted.string)
    // 添加属性
    formatted.addAttribute(NSAttributedString.Key.link, value: linkTarger, range: nsRange)
}

if let queryRange = formatted.string.range(of: "here"),
    // 获取在 UTF-16 视图中的索引
    let utf16Index = String.Index(queryRange.lowerBound, within: formatted.string.utf16) {
    // 将索引转换为 UTF-16 证书偏移量
    let utf16Offset = utf16Index.utf16Offset(in: formatted.string)
    
    // 准备用来接收属性影响的范围(effectiveRange)的 NSRangePointer
    var attributesRange = UnsafeMutablePointer<NSRange>.allocate(capacity: 1)
    defer {
        attributesRange.deinitialize(count: 1)
        attributesRange.deallocate()
    }
    // 执行查询
    let attributes = formatted.attributes(at: utf16Offset, effectiveRange: attributesRange)
    attributes
    attributesRange.pointee
    // 将 NSRange 转换回 Range<String.Index>
    if let effectiveRange = Range(attributesRange.pointee, in: formatted.string) {
        // 属性所跨越的子字符串
        formatted.string[effectiveRange]
    }
}








