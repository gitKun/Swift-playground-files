import UIKit


/// MARK: 柯里化

func addOne(num: Int) -> Int {
    return num + 1
}

func addTo(_ adder: Int) -> (Int) -> Int {
    return {
        num in
        return num + adder
    }
}

let addTwo = addTo(2)//addTwo: (Int) -> Int
let result = addTwo(6)//result = 8

func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { $0 > comparer }
}

let greaterThan10 = greaterThan(10);

greaterThan10(13)    // => true
greaterThan10(9)     // => false
greaterThan(8)(2)

// 柯里化 用于处理 cocoa 中的 target-action 设计模式

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()
    func performAction() {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
    // ...
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    func setTarget<T: AnyObject>(target: T, action: @escaping (T) -> () -> (), controlEvent: ControlEvent) -> () {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    func removeTargetFroControlEcent(controlEvent: ControlEvent) -> () {
        actions[controlEvent] = nil
    }
    func performActionForControlEvent(controlEvent: ControlEvent) -> () {
        actions[controlEvent]?.performAction()
    }
}

/*
 总结

 1. 柯里化是一种量产相似方法的好办法，可以通过柯里化一个方法模板来避免写出很多重复代码，也方便了今后维护

 */

/// MARK: Sequence

class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T
    var array: [Element]
    var currentIndex = 0
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }

    func next() -> T? {
        if currentIndex < 0 {
            return nil
        }else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}

struct ReverseSequence<T>: Sequence {
    var array: [T]
    init(array: [T]) {
        self.array = array
    }

    typealias Iterator = ReverseIterator<T>

    func makeIterator() -> ReverseIterator<T> {
        return ReverseIterator(array: self.array)
    }
}

let arr = ["zeon", "first", "second", "third", "four"]

for i in ReverseSequence(array: arr) {
    print("i is the elememt: \(i), index is \(arr.firstIndex(of: i) ?? Int.self.max)")
}

// 展开 `for...in` 大概如下代码所示

var iterator = arr.makeIterator()// iterator: IndexingIterator<[Int]>

while let obj = iterator.next() {
    print(obj)
}

/// MARK: 多元组(Tuple)

//1. 交换值

//func swapMe1<T>(a: inout T, b: inout T) {
//    let tmp = a
//    a = b
//    b = tmp
//}

func swapMe2<T>(a: inout T, b: inout T) {
    (a, b) = (b, a)
}

//2. 函数多返回值的使用

let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let (small, large) = rect.divided(atDistance: 20, from: .minXEdge)
print("small = \(small), large = \(large)")


/// MARK: @autoclosure

func logIfTrue(_ predicate: () -> Bool) {
    if predicate() {
        print("Ture")
    }
}

logIfTrue({return 2 > 1})
logIfTrue{ 2 > 1 }

func logIfTrue2(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("Ture")
    }
}

logIfTrue2(2 > 1)

/// MARK: ??

var level: Int?
var startLevel = 1

var currentLevel = level ?? startLevel

// ?? 的定义如下

/*
 func ??<T>(optional: T?, defaultValue: @autoclosure () -> T?) -> T?

 func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T

 func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
    switch optional {
        case .Some(let value):
            return value
        case .None:
            return defaultValue()
    }
 }

 */

/*
 可能你会有疑问，为什么这里要使用 autoclosure，直接接受 T 作为参数并返回不行么，为何要用 () -> T 这样的形式包装一遍，岂不是画蛇添足？其实这正是 autoclosure 的一个最值得称赞的地方。如果我们直接使用 T，那么就意味着在 ?? 操作符真正取值之前，我们就必须准备好一个默认值传入到这个方法中，一般来说这不会有很大问题，但是如果这个默认值是通过一系列复杂计算得到的话，可能会成为浪费 -- 因为其实如果 optional 不是 nil 的话，我们实际上是完全没有用到这个默认值，而会直接返回 optional 解包后的值的。这样的开销是完全可以避免的，方法就是将默认值的计算推迟到 optional 判定为 nil 之后。

    就这样，我们可以巧妙地绕过条件判断和强制转换，以很优雅的写法处理对 `Optional` 及默认值的取值了。
 */

/// MARK: @escaping

func doWork(block: () -> ()) {
    block()
}
func doWorkAsync(block: @escaping () -> ()) {
    DispatchQueue.main.async {
        block()
    }
}

class S {
    var foo = "foo"
    func method1() {
        doWork {
            print(foo)
        }
        foo = "bar1"
    }
    func method2() {
        doWorkAsync {
            print(self.foo)
        }
        foo = "bar2"
    }
    func method3() {
        doWorkAsync {
            [weak self] in
            print(self?.foo ?? "nil")
        }
        foo = "bar3"
    }
}
S().method1()
S().method2()
S().method3()
/*
 method2 中强制引用了 S() 所以可以打印出 foo
 method3 中强没有强制引用 S() 所以新产生的 S 实例在地用完 method3 后就被释放了
 */
