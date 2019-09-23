import Foundation

/*

 ZZ Z Z
   <︵/
 / <_/_____/
___________／`­­­–
 
*/

/// 标准等价

let aChar: Character = "é"

let single = "Pok\u{00E9}mon"
let double = "Poke\u{0301}mon"

print(single, double)

print(single.count, double.count)

print(single == double)


single.utf16.count
double.utf16.count

//String.UnicodeScalarView
//Unicode.Scalar

let chars: [Character] = ["\u{1ECD}\u{300}",
                          "\u{F2}\u{323}",
                          "\u{6f}\u{323}\u{300}",
                          "\u{6F}\u{300}\u{323}"
]// ["ọ̀", "ọ̀", "ọ̀", "ọ̀"]

print("\u{6F}\u{300}\u{323}" == "\u{6f}\u{323}\u{300}")


let crlf = "\r\n"
crlf.count

let flags = "🇧🇷🇳🇿"
flags.count

let falgsScalars = flags.unicodeScalars.map {
    "U+\(String($0.value, radix: 16, uppercase: true))"
}
print(falgsScalars)// ["U+1F1E7", "U+1F1F7", "U+1F1F3", "U+1F1FF"]

extension StringTransform {
    static let toUnicodeName = StringTransform(rawValue: "Any-Name")
}

extension Unicode.Scalar {
    // 标量的 Unicode 名字，比如 "LATIN CAPITAL LETTER A"
    var unicodeName: String {
        // 强制解包是安全，因为这个变形不可能失败
        let name = String(self).applyingTransform(.toUnicodeName, reverse: false)!
        let prefixPattern = "\\N{"
        let suffixPattern = "}"
        let prefixLength = name.hasPrefix(prefixPattern) ? prefixPattern.count : 0
        let suffixLength = name.hasSuffix(suffixPattern) ? suffixPattern.count : 0
        return String(name.dropFirst(prefixLength).dropLast(suffixLength))
    }
}

let skinTone = "👧🏽"
skinTone.count

let skinToneName = skinTone.unicodeScalars.map { $0.unicodeName }
print(skinToneName)// ["GIRL", "EMOJI MODIFIER FITZPATRICK TYPE-4"]

let family1 = "👨‍👩‍👧‍👦"

let family2 = "👨\u{200D}👩\u{200D}👧\u{200D}👦"

let family3 = "👨\u{200D}👩\u{200D}👦"

let family4 = "👨\u{200D}👩\u{200D}👶🏼"

family1.count
family2.count
family3.count
family4.count

family1 == family2

// 字节长度
family1.count
family1.utf16.count
family1.utf8.count




