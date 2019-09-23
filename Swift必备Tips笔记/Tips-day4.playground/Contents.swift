import UIKit


/// MARK: lazy

let data1 = 1...3
let data2 = "b"..."e"//let data2: ClosedRange<String>

//data1.map { (i: Int) -> Int in
//
//    return i * 2
//}
//let result0 = data1.map { $0 * 2 }



data1.map { (i: Int) -> Int in
    //code
    return i * 2
}
data1.map{ $0 * 2 }
data2.map{ $0 + "x" }
//data2.map { (<#ClosedRange<String>.Element#>) -> T in
//    <#code#>
//}

//data2.map { (str: ClosedRange<String>.Element) -> ClosedRange<String>.Element in
//
//    return str
//}

//data2.lazy// 报错 方法定义模糊

let result1 = data1.lazy.map {
    (i: Int) -> Int in
    print("正在处理\(i)")
    return i * 2
}

//let result2 = data2.lazy.map {
//    (str: String) -> String in
//    print("正在处理:\(i)")
//    return i + " -> "
//}

let result3: EnumeratedSequence<[Int]> = [1, 2, 3, 4].enumerated()
let reslut7: EnumeratedSequence<LazyCollection<[Int]>> = [1, 2, 3, 4, 5].lazy.enumerated()

let result4 = data1.lazy
let result5: EnumeratedSequence<LazyCollection<ClosedRange<Int>>> = result4.enumerated()

let result6 = result4.map {
    (i: Int) -> Int in
    print("正在处理\(i)")
    return i * 2
}

print("即将以 enumerated 形式访问")
for (index, num) in result6.enumerated() {
    print("操作结果为:\(num), 当前index = \(index)")
}
print("enumerated 形式访问结束")


print("准备访问结果")

for i in result1 {
    print("操作结果为:\(i)")
}


//print("即将以 enumerated 形式访问")
//for (index, num) in result5 {
//    print("遍历形式访问结果: index = \(index), num = \(num)")
//}
//print("enumerated 形式访问结束")
//

/// MARK: indirect 和 嵌套 enum

indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)

    func valueForEvalutate() -> Int {
        switch self {
        case let .number(value):
            return value
        case let .addition(left, right):
            return left.valueForEvalutate() + right.valueForEvalutate()
        case let .multiplication(left, right):
            return left.valueForEvalutate() * right.valueForEvalutate()
        }
    }
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
print(product.valueForEvalutate())

/// MARK: 实例方法的动态调用

class MyClass {
    func method(number: Int) -> Int {
        return number + 1
    }
}

let f = MyClass.method //let f: (MyClass) -> (Int) -> Int
let object = MyClass()
let result9 = f(object)(1)

let f2 = { (obj: MyClass) in obj.method }// 同 f 一样，可以看做 f 的字面量写法

class MyClass2 {
    func method(num: Int) -> Int {
        return num + 1
    }
    class func method(num: Int) -> Int {
        return num + 1
    }
}

let f2_1 = MyClass2.method// let f2_1: (Int) -> Int; class func method 的版本

let f2_2: (Int) -> Int = MyClass2.method// 和 f2_1 表示同一个方法

let f2_3: (MyClass2) -> (Int) -> Int = MyClass2.method// MyClass2 实例的方法; func method 的l柯里化版本

class ClassA {}

class ClassB: ClassA {}

let classObj: AnyObject = ClassB()

if (classObj is ClassA) {
    print("属于ClassA")
}
if classObj is ClassB {
    print("属于ClassB")
}







