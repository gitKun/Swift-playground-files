import Foundation
import UIKit

/// 重载
func log<View: UIView>(_ view: View) {
    print("it's a \(type(of: view)), frame:\(view.frame)")
}

func log(_ view: UILabel) {
    let text = view.text ?? "empty"
    print("it's a label, text:\(text)")
}

/* 对于重载的函数调用的选择：选择最具体的一个，即非通用的函数会优先于通用函数的使用 */

let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 32))
label.text = "Password"
log(label)// it's a label, text:Password

let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
log(button)// it's a UIButton, frame:(0.0, 0.0, 100.0, 50.0)

/* 要特别注意的，重载的使用是在编译期间静态决定的 */

let views = [label, button]

for view in views {
    log(view)
}
//it's a UILabel, frame:(20.0, 20.0, 200.0, 32.0)
//it's a UIButton, frame:(0.0, 0.0, 100.0, 50.0)


/// 运算符重载

// 1. 定义运算符的优先级
precedencegroup ExponentiationPrecedence {
    associativity: left// 运算顺序
    higherThan: MultiplicationPrecedence // 优先级
}
// 2. 定义运算符
infix operator **: ExponentiationPrecedence
// 3. 运算符对应的函数实现
func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

func **(lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)
}

let result1 = 2.0 ** 3.0

// 对整数的重载

func **<I: BinaryInteger>(lhs: I, rhs: I) -> I {
    let result = Double(Int64(lhs)) ** Double(Int64(rhs))
    return I(result)
}



/* 对于重载的运算符，类型检查器回去使用非泛型版本的重载，而不考虑泛型版本 */

/*
 2 ** 3// Ambiguous use of operator '**'
 */

/* 为了使编译器选择正确的重载，我们需要至少讲一个参数显式的声明为整数类型，或者明确返回值的类型为整数 */

let intResult: Int = 2 ** 3

/* 编译器的这种行为只对运算符生效 */



/// 使用泛型约束进行重载

extension Sequence where Element: Equatable {
    // 复杂度 O(nm)
    func isSubset(of other: [Element]) -> Bool {
        for element in self {
            guard  other.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence where Element: Hashable {
    // 复杂度 O(n+m)
    func isSubset(of other:[Element]) -> Bool {
        // 将 other 转换为 otherSet 的时间复杂度为 O(m)
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

/// 重写为任意类型

extension Sequence where Element: Hashable {
    func isSunset<S: Sequence>(of other: S) -> Bool
        where S.Element == Element
    {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

let intRange = 1...10// CountableClosedRange<Int>
[5, 3, 4].isSunset(of: intRange)

[[1, 2]].isSubset(of: [[1, 2], [3, 4]])
//Array
let array1: [Int] = [1, 2]
let array2 = [3, 4]
array1 == array2//false


let isEven = { $0 % 2 == 0 }

(0...5).contains(where: isEven)
[1, 3, 99].contains(where: isEven)

// 闭包表达式
extension Sequence {
    func isSubset<S: Sequence>(of other: S, by areEquivalent: (Element, S.Element) -> Bool) -> Bool {
        for element in self {
            guard other.contains(where: { areEquivalent(element, $0) }) else {
                return false
            }
        }
        return true
    }
}

let ints = [1, 2]
let strings = ["1", "2", "3"]
let result2 = ints.isSubset(of: strings) { String($0) == $1 }
result2














