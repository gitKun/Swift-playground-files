import Foundation

let i: Int? = nil
let j: Int? = nil
let k: Int? = 42
print(i ?? "nil")
let m = i ?? j ?? k

print(m ?? "nil")

// 注意 a ?? b ?? c 和 (a ?? b) ?? c 表达的意义不同，结果不一定相同如下

let s1: String?? = nil
(s1 ?? "inner") ?? "outer"
let s2: String?? = .some(nil)
(s2 ?? "inner") ?? "outer"

infix operator ???: NilCoalescingPrecedence

public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?:
        return String(describing: value)
    case nil:
        return defaultValue()
    }
}

print("m = \(m ??? "n/a")")

/// 可选值 map

let charaters: [Character] = ["a", "b", "c"]

//String(charaters.first)//Value of optional type 'Character?' must be unwrapped to a value of type 'Character'

let firstChar = charaters.first.map { String($0) }
let nilCharas: [Character] = []
let firstNil = nilCharas.first.map { String($0) }

print(firstChar as Any)
print(firstNil as Any)

let dropFirsr = charaters.dropFirst()

let reduceResult1 = [1, 2, 3, 4].reduce(5) { $0 + $1 }
print("reduceResult1 = \(reduceResult1)")


extension Array {
    func reduce(_ nextPartialResult:(Element, Element) -> Element) -> Element? {
        return first.map {
            dropFirst().reduce($0, nextPartialResult)
        }
    }
}

extension Array {
    func reduce2(_ nextPartialResult:(Element, Element) -> Element) -> Element? {
        guard let fst = first else { return nil }
        return dropFirst().reduce(fst, nextPartialResult)
    }
}

[1, 2, 3, 4].reduce(+)
[1, 2, 3, 4].reduce2(+)
