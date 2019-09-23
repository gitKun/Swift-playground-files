import Foundation

// BidirectionalCollection

// RandomAccessCollection

// RangeReplaceableCollection


let str = "Hello"

str.last
str.count



let urlString = "https://www.objc.io/logo.png"

let scanner = Scanner(string: "lisa123")
var username: NSString?
let alphas = CharacterSet.alphanumerics
print("alphas = \(alphas.description)")

if scanner.scanCharacters(from: alphas, into: &username),
    let name = username {
    print(name)
}



let j = 5

if case 0...10 = j {
    print("\(j)在范围内！")
}

// case 是匹配 ~= 运算符来进行扩展的
/*
func ~=(range: ClosedRange<Int>, value: Int) -> Bool {
    return range.contains(value)
}

let tenRange = 1...10
tenRange.contains(j)
 
 func ~=<T, U>(_: T, _: U) -> Bool { return true }
*/


// swift 中的延时初始化！！！
func fileExtension(_ fileName: String) -> String? {
    let period: String.Index
    if let idx = fileName.index(of: ".") {
        period = idx
    }else {
        return nil
    }
    let extensionStart = fileName.index(after: period)
    return String(fileName[extensionStart...])
}

if let fileExt = fileExtension("hello.txt") {
    print(fileExt)
}else {
    print("Not Ext")
}
