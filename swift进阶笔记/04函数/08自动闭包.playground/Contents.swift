import Foundation

/// 短路求值

let evens = [2, 4, 6]

if !evens.isEmpty && evens[0] > 10 {
    print("xxx")
}

if let first = evens.first, first > 10 {
    print("yyy")
}

/// @autoclosure 自动闭包

func and1(_ l: Bool, _ r: () -> Bool) -> Bool {
    guard l else { return false }
    print("调用函数\(#function)")
    return r()
}

if and1(!evens.isEmpty, { print("调用闭包\(#function)")
    return evens[0] > 10
}) {
    print("xxx")
}

func add(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
    guard l else { return false }
    return r()
}

if add(!evens.isEmpty, evens[0] > 10) {
    print("yyy")
}


func log(isFalse condition: Bool,
         message: @autoclosure () -> String,
         file: String = #file,
         function: String = #function,
         line: Int = #line) {
    guard !condition else { return }
    print("Assertion failed:\(message()),\(file),\(function),\(line)")
}


/// @escaping 逃逸闭包

/// withoutActuallyEscaping

extension Array {
    func all(matching predicate: (Element) -> Bool) -> Bool {
        
        return withoutActuallyEscaping(predicate, do: { escapablePredicate in
            self.lazy.filter { !escapablePredicate($0) }.isEmpty
        })
        // 报错: Closure use of non-escaping parameter 'predicate' may allow it to escape
        // return self.lazy.filter({ !predicate($0) }).isEmpty
    }
}

let areAllEven = [1, 2, 3, 4].all { $0 % 2 == 0 }
print(areAllEven)
let areAllOneDigit = [1, 2, 3, 4].all { $0 < 10 }
print(areAllOneDigit)
















