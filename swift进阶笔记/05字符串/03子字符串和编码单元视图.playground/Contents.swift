import Foundation

/*
 Swift 提供了是三种视图: unicodeScalars, utf16, utf8.
 他们也是双向索引的集合，视图于字符串共享存储；
 他们只是简单地以另一种方式呈现底层的字节；
 
 */

let tweet = "Having ☕️ in a cafe\u{301} in 🇮🇪 and enjoying the ☀️."
tweet.count
let characterCount = tweet.precomposedStringWithCanonicalMapping.unicodeScalars.count // 46
let utf8Bytes = Data(tweet.utf8)
utf8Bytes.count// 62

// 已 null 结尾的表示(转换为 C String)
let nullTerminatedUTF8 = tweet.utf8CString
nullTerminatedUTF8.count// 63

/// 编码视图 共享索引

let pokemon = "Poke\u{301}mon"// Pokémon
if let index = pokemon.firstIndex(of: "é") {
    let scalar = pokemon.unicodeScalars[index]
    String(scalar)// e
}



let family = "👨‍👩‍👧‍👦"

let someUTF16Index = String.Index(utf16Offset: 2, in: family)

if let accentIndex = pokemon.unicodeScalars.firstIndex(of: "\u{301}") {
    accentIndex.samePosition(in: pokemon)// nil
}


let noCharacterBoundary = family.utf16.index(family.utf16.startIndex, offsetBy: 3)
// 在字符视图中，并非有效的位置
noCharacterBoundary.utf16Offset(in: family)//3
noCharacterBoundary < family.utf16.endIndex// true
// 错误 idx 不是有效索引
if let idx = String.Index(noCharacterBoundary, within: family) {
    family[idx]
}

// 寻找 Character 边界起始位置的可靠方式是使用 Foundation 中的 rangeOfComposedCharacterSequence: 方法

extension String.Index {
    func samePositionOnCharacterBoundary(in str: String) -> String.Index {
        let  range = str.rangeOfComposedCharacterSequence(at: self)
        return range.lowerBound
    }
}

let validIndex = noCharacterBoundary.samePositionOnCharacterBoundary(in: family)
print(validIndex)

family[validIndex]// 👨‍👩‍👧‍👦






