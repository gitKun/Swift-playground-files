import Foundation


func returnFunc() -> (Int) -> String {
    return { return "you passed \($0)" }
}

func returnFunc2() -> (Int) -> String {
    func innetFunc(i: Int) -> String {
        return "you passed \(i)"
    }
    return innetFunc
}

var myFunc = returnFunc()
myFunc(3)
myFunc = returnFunc2()
myFunc(4)

/// 函数捕获它们作用域之外的变量

class MyClass {
//    let name = "cls"
    
}

var cls = MyClass()


func counterFunc() -> (Int) -> String {
    var counter = 0
    return {i in
        print("cls    : \(Unmanaged.passUnretained(cls).toOpaque())")
        var i2 = i
        Swift.withUnsafePointer(to: &i2) { print("i2     : \($0)") }
        counter += i
        Swift.withUnsafePointer(to: &cls) { print("counter: \($0)") }
        return "running total:\(counter)"
    }
}
func counterFunc2() -> (Int) -> String {
    var counter = 0
    return {
        counter += $0
        return "running total:\(counter)"
    }
}

/*
 ??? counter 将存在于堆上而非栈上 ???。我们可以多次调用 counterFunc，并且看到 running total 的输出在增加：
 
 Swift 的结构体一般被存储在栈上，不过可变结构体默认是存储在堆上的，但大多数情况下这些可变结构体都会被编译器优化并存储到栈上。当编译器侦测到结构体变量被一个函数闭合的时候这种优化将不再生效，此时可变结构体存储在堆上!
 上面例子中：counter 在退出 counterFun 的作用域时任然存在！(因为被逃逸闭包捕获的变量需要在栈帧之外依然存在!)
 
 Swift 的 `copy-in` `copy-out` 模型，`引用调用`优化，官方文档如下：
 
  > As an optimization, when the argument is a value stored at a physical address in memory, the same memory location is used both inside and outside the function body. The optimized behavior is known as call by reference; it satisfies all of the requirements of the copy-in copy-out model while removing the overhead of copying. Write your code using the model given by copy-in copy-out, without depending on the call-by-reference optimization, so that it behaves correctly with or without the optimization.
 
 Swift 中开发者没办法知道和干预何时会发生结构体的复制，这些简化给了编译器更多的可能性，来排除那些不必要的复制，或者使用触底引用而非值的方式来优化一个常量结构体  -- Swift进阶>结构体和类>值类型
 
 编译器所做的对于值**类型**的_复制优化_和值**语义**类型的_写时复制_行为并不是一回事。_写时复制_需要开发者来实现  -- Swift进阶>结构体和类>值类型
 
 */

let f = counterFunc()
f(3)//running total:3
f(4)//running total:7
f(-1)
f(-3)


/// 函数可以使用 {} 来声明闭包表达式

let intArray = [1, 2, 3]

intArray.map { (i: Int) -> Int in return i * 2 }
intArray.map({ i in return i * 2 })
intArray.map({ i in i * 2 })
intArray.map({ $0 * 2 })
intArray.map(){ $0 * 2 }
intArray.map { $0 * 2 }

//extension BinaryInteger {
//
//}

//let boolResult = (2, "two") > (1, "one")// ture

let animals = ["elephant", "zebra", "dog"]
animals.sorted { lhs, rhs in
    let l = lhs.reversed()
    let r = lhs.reversed()
    return l.lexicographicallyPrecedes(r)
}

animals.sorted {
    let l = $0.reversed()
    let r = $1.reversed()
    return l.lexicographicallyPrecedes(r)
}

