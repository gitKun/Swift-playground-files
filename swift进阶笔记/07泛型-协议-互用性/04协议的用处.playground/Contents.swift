import Foundation
import UIKit

/// MARK: 面向协议编程

/* 协议的最强大的特性之一就是我们可以以追溯的方式来修改任意类型，让他们满足协议 */

protocol Drawing {
    mutating func addElipse(rect: CGRect, fill: UIColor)
    mutating func addRectangle(rect: CGRect, fillColor: UIColor)
}

extension CGContext: Drawing {
    func addElipse(rect: CGRect, fill: UIColor) {
        setFillColor(fill.cgColor)
        fillEllipse(in: rect)
    }
    func addRectangle(rect: CGRect, fillColor: UIColor) {
        setFillColor(fillColor.cgColor)
        fill(rect)
    }
}

// 自定义一个 XMLNode 类型来解析 svg

class XMLNode {
    private var rootName: String
    private var nextRoot: XMLNode
    var childen: XMLNode {
        get {
            return nextRoot
        }
    }
    
    init(tag root: String) {
        self.rootName = root
        self.nextRoot = XMLNode(tag: "child")
    }
    
    func append(node next: XMLNode) {
        
    }
    
}

struct SVG {
    var rootNode = XMLNode(tag: "svg")
    mutating func append(node: XMLNode) {
        rootNode.childen.append(node: node)
    }
}

//extension SVG: Drawing {
//    mutating func addElipse(rect: CGRect, fill: UIColor) {
//        var attributes: [String: String] = rect.sv
//
//    }
//}


/* Swift 的协议的另一个强大的特性是我们可以使用完整的方法实现来扩展一个协议。
 即可以扩展自己的协议，也可以扩展别人的协议 */

/// MARK: 在协议拓展中重写方法

struct MyValue {}

protocol MyProtocol {
    func customPrint()
    func anotherPrint()
}

extension MyValue: MyProtocol {
    func customPrint() {
        print("MyValue: MyProtocol -> customPrint()")
    }
    func anotherPrint() {
        print("MyValue: MyProtocol -> anotherPrint()")
    }
}

extension MyProtocol {
    func otherPrintFunc() {
        print("extension MyProtocol -> otherPrintFunc()")
    }
    func anotherPrint() {
        print("extension MyProtocol -> anotherPrint()")
    }
}

extension MyValue {
    func otherPrintFunc() {
        print("extension MyValue -> otherPrintFunc()")
    }
}


let value1 = MyValue()
value1.customPrint()// MyValue: MyProtocol -> customPrint()
value1.otherPrintFunc()// extension MyValue -> otherPrintFunc()
value1.anotherPrint()// MyValue: MyProtocol -> anotherPrint()

let value2: MyProtocol = MyValue()
value2.customPrint()// MyValue: MyProtocol -> customPrint()
value2.otherPrintFunc()// extension MyProtocol -> otherPrintFunc()
value2.anotherPrint()// MyValue: MyProtocol -> anotherPrint()

/*
 当 value 定义为 MyProtocol 类型时，编译器会自动将 MyValue 值封装到一个代表协议的类型中，这个封装被称作 存在容器；
 当我们对存在容器调用 otherPrintFunc 方法(方法和函数？？？)时,方法是静态的派发的，
 也就是说，它会使用 MyProtocol 中扩展。(如果是动态派发它应该调用 MyValue 的 otherPrintFunc 方法)
 
 定义在协议内的方法(协议要求的方法)是动态派发的，定义在协议扩展中的方法是静态派发的；
 协议要求的方法：定义在协议内的方法。
 当协议要求发的方法有默认实现时，如果遵守协议的类型未实现则会使用 协议的默认实现(但这也是动态派发后的结果)
 */


/// MARK: 协议的两种类型

/* 带有关联类型的协议和普通的协议是不同的，*/
/* 对于那些在协议定义中在任何地方使用了 Self 的协议来说也是如此 */


// 1. 关联类型协议

/*
 `protocol` 和 `class` 、`struct` 以及 `enum` 不同，它不支持 `泛型类型参数` 。取而代之的是支持抽象类型成员；称作 `关联类型` 。
 */


protocol ATypeDelegate {
    /// 关联类型的协议必须你自己手动写 associatedtype 创建关联类型
    associatedtype T
    func printContent(ct: T)
    
    func colum(ct: T)
}

class ATypeClass: ATypeDelegate {
    // 只要遵守了 ATypeDelegate 协议 就应该明确指定 关联的类型
    typealias T = Int
    func printContent(ct: Int) {
        
    }
    func colum(ct: Int) {
        print("Int",#function)
    }
}

//extension Collection {
//
//}

let aTypeClass = ATypeClass()
aTypeClass.colum(ct: 9)

/*
//Protocol 'Equatable' can only be used as a generic constraint because it has Self or associated type requirements
let equlableType: Equatable = 32
*/


func nextInt<I: IteratorProtocol>(iterator: inout I) -> Int?
    where I.Element == Int
{
    return iterator.next()
}

/*
 
 */

class IteratorStore<I: IteratorProtocol> where I.Element == Int {
    var iterator: I
    init(iterator: I) {
        self.iterator = iterator
    }
}


/*
 类型抹除的第二种方法: 类继承的方式，将具体的地带器类型隐藏在子类中，对外提供元素类型的泛型类型
 */

class IteratorBox<Element>: IteratorProtocol {
    func next() -> Element? {
      fatalError("This method is abstract")
    }
}

//class IteratorBoxHelper<I: IteratorProtocol> {
//    var iterator: I
//    init(iterator: I) {
//        self.iterator = iterator
//    }
//    func next() -> I.Element? {
//        return iterator.next()
//    }
//}

class IteratorBoxHelper<I: IteratorProtocol>: IteratorBox<I.Element> {
    var iterator: I
    init(_ iterator: I) {
        self.iterator = iterator
    }
    override func next() -> I.Element? {
        return iterator.next()
    }
}


