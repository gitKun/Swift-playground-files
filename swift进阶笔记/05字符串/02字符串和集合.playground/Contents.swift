import Foundation


let flagLetterC = "🇨"
let flagLetterN = "🇳"
let flag = flagLetterC + flagLetterN

let flag2: Character = "🇨\u{200D}🇳"

flag.count
String(flag2).count

extension Collection where Element: Equatable {
    func split<S: Sequence>(separators: S) -> [SubSequence] where Element == S.Element {
//        return split(whereSeparator: { ele in
//            separators.contains(ele)
//        })
        return split { separators.contains($0) }
    }
}

let result1 = "Hello, world!".split(separators: ",!")// ["Hello", " world"]
type(of: result1[0])// Substring.Type


let commaSeparatedNumbers = "1,2,3,4,5"
let numbers = commaSeparatedNumbers.split(separator: ",").compactMap { Int($0) }
print((numbers, numbers.count))










