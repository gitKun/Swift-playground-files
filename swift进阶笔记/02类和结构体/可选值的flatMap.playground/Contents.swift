import Foundation
import UIKit
import PlaygroundSupport

let stringNumbers = ["1", "2", "3", "foo"]
let x = stringNumbers.first.map { Int($0) }//let x: Int??
print(type(of: x))//Optional<Optional<Int>>
// flatMap 把结果平展为单个可选值
let y = stringNumbers.first.flatMap { Int($0) }//let y: Int?
print(type(of: y))//Optional<Int>


if let z = (stringNumbers.first.flatMap { Int($0) }) {
    print(z)
}
//if let z = (stringNumbers.first.map { Int($0) }) {
//    print(z)//Expression implicitly coerced from 'Int?' to 'Any'
//}

let urlString = "https://www.baidu.com/img/bd_logo1.png?where=super"
let view = URL(string: urlString)
    .flatMap { try? Data(contentsOf: $0) }
    .flatMap { UIImage(data: $0) }
    .map { UIImageView(image: $0) }
if let view = view {
    PlaygroundPage.current.liveView = view
}

/// 使用 flatMap 过滤 nil
print("使用 flatMap 过滤 nil")
// 使用 case 对 for 进行 nil 排除

let numbers = ["1", "2", "3", "foo"]

var sum = 0

for case let i? in numbers.map({ Int($0) }) {
    sum += i
}
print("sum = \(sum)")

let flatNumbers = numbers.compactMap { Int($0) }


func flatten<S: Sequence, T>(source: S) -> [T] where S.Element == T? {
    let filered = source.lazy.filter { $0 != nil }
    return filered.map { $0! }
}

let resultCF = ["1", "2", "3", nil].filter { $0 != nil }
print(resultCF)
let resultCM = ["1", "2", "3", nil].compactMap { Int($0 ?? "") }
print(resultCM)

extension Sequence {
    func flatten2<T>() -> [T] where Self.Element == T? {
        let filered = self.lazy.filter { $0 != nil }
        return filered.map { $0! }
    }
}

        
let opNum: [Optional<String>] = [nil, "2", "3", "3"]

print(opNum)

opNum.flatten2()

/// 可选值判等

let regx = "^Hello$"

if regx.first == "^" {
    print("has prefix ^")
}


/// 隐式转换为 Operation
let a = [1, 2, nil]
let b = [1, 2, nil]
print(a == b)
print("a = \(a)")
// a = [Optional(1), Optional(2), nil]

//let c = ["1.1", "-3.3", "sda"]
//let resultC = c.filter { Double($0) < 0.0 }//Binary operator '<' cannot be applied to operands of type 'Double?' and 'Double'


let ages = [
    "Tim": 53, "Angela": 54, "Craig": 44,
    "Jony": 47, "Chris": 37, "Michael": 34,
]

let resultAges = ages.filter { $0.1 < 50 }.map { $0.0 }.sorted()

print("resultAges = \n\(resultAges)")



infix operator !!

func !!<T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped { return x  }
    fatalError(failureText())
}

let foo = "foo"
let resultFoo = Int("3") !! "ddd"

infix operator !?

func !?<T: ExpressibleByIntegerLiteral>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

let s20 = "20"
let i20 = Int(s20) !? "Expecting integer, got\"\(s20)\""



