import UIKit

/// MARK: 操作符

struct Vector2D {
    var x = 0.0
    var y = 0.0
}

// 运算符重载
func +(left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}

// 自定义运算符
precedencegroup DotProductPrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
}

infix operator +*: DotProductPrecedence

func +*(left: Vector2D, right: Vector2D) -> Double {
    return left.x * right.x + left.y * right.y
}

/*
 precedencegroup: 定义了一个操作符优先级别

 associativity: 定义了结合律，即如果多个同类的操作符顺序出现的计算顺序

 higherThan: 运算的优先级，点积运算是优先于乘法运算。也支持使用 lowerThan 来指定优先级低于某个其他组。

 infix: 表示要定义的是一个中位操作符，即前后都是输入；其他的修饰子还包括 prefix 和 postfix
 */

/*

 最后需要多提一点的是，Swift 的操作符是不能定义在局部域中的，因为至少会希望在能在全局范围使用你的操作符，否则操作符也就失去意义了。
 另外，来自不同 module 的操作符是有可能冲突的，这对于库开发者来说是需要特别注意的地方。
 如果库中的操作符冲突的话，使用者是无法像解决类型名冲突那样通过指定库名字来进行调用的。

 因此在重载或者自定义操作符时，应当尽量将其作为其他某个方法的 "简便写法"，而避免在其中实现大量逻辑或者提供独一无二的功能。
 这样即使出现了冲突，使用者也还可以通过方法名调用的方式使用你的库。运算符的命名也应当尽量明了，避免歧义和可能的误解。
 因为一个不被公认的操作符是存在冲突风险和理解难度的，所以我们不应该滥用这个特性。

 在使用重载或者自定义操作符时，请先再三权衡斟酌，你或者你的用户是否真的需要这个操作符

 */


/// func 的参数修饰

/*
 因为 Swift 其实是一门讨厌变化的语言。所有有可能的地方，都被默认认为是不可变的，也就是用 let 进行声明的。这样不仅可以确保安全，也能在编译器的性能优化上更有作为。在方法的参数上也是如此，我们不写修饰符的话，默认情况下所有参数都是 let 的
 */

/// MRAK: 命名空间

struct MyClassContainer1 {
    class MyClass {
        class func hello() {
            print("hello from MyClassContainer1")
        }
    }
}

struct MyClassContainer2 {
    class MyClass {
        class func hello() {
            print("hello from MyClassContainer2")
        }
    }
}

MyClassContainer1.MyClass.hello()
MyClassContainer2.MyClass.hello()

/// MARK: associatedtype

/*
 在一个协议加入了像是 associatedtype 或者 Self 的约束后，它将只能被用为泛型约束，而不能作为独立类型的占位使用，也失去了动态派发的特性。也就是说，这种情况下，我们需要将函数改写为泛型：
 */

/*
func isDangerous<T: Animal>(animal: Animal) -> Bool {
    if animal is Tiger {
        return true
    }else {
        return false
    }
}
 */


