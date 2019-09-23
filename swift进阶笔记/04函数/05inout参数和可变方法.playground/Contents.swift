import Foundation

/*
 inout 参数虽然使用&，但这并不是传递引用(区别于c和c++)：
    inout 参数将一个值传递给函数，函数可以改变这个值，然后将原来的值替换掉，并从函数中传出。
 */

/// 同时具有 set 和 get 的下标方法能被用于 inout 参数

func increment(value: inout Int) {
    value += 1
}

var array = [0, 1, 2]
increment(value: &array[0])
//print(array)// [1, 1, 2]

struct Point {
    var x: Int
    var y: Int
}
var point = Point(x: 0, y: 0)
increment(value: &point.x)
//print(point)// Point(x: 1, y: 0)

/// 只具有 get 或 set 的属性不能适用于 inout 参数

extension Point {
    var squareDistance: Int {
        return x * x + y * y
    }
}

// Cannot pass immutable value as inout argument: 'squareDistance' is a get-only property
//increment(value: &point.squareDistance)

/*
 编译器可能会把 inout 变量优化成引用传递，而非传入和传出时的复制。不过，文档已经明确指出了我们我们不应该依赖 inout 的这个行为。
 */

func incrementTenTimes(value: inout Int) {
    func inc(){
        value += 1
    }
    for _ in 0..<10 {
        inc()
    }
}

var x = 0
incrementTenTimes(value: &x)
x// 10

/// inout 参数不能逃逸

/*
func escapeIncrement(value: inout Int) -> () -> () {
    func inc() {
        value += 1
    }
    return inc// Nested function cannot capture inout parameter and escape
}
*/


/// & 不意味着 inout 的情况

// & 除了在将变量传递给 inout 以外，还可以用于将变量转换为不安全的指针

func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int {
    // 将指针的复制存储在闭包中
    return {
        pointer.pointee += 1
        return pointer.pointee
    }
}

// Swift 的数组可以无缝的隐式退化为指针，这使得 Swift 和 C 一起使用时非常的方便

let fun: () -> Int
do {
    var array = [4]
    fun = incref(pointer: &array)
}

fun()






