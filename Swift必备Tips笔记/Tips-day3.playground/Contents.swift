import UIKit

/// MARK: 可变参数

func myAddFunc(numbers: Int..., string: String) {
    numbers.forEach {
        for i in 0..<$0 {
            print("\(i + 1):\(string)")
        }
    }
}

myAddFunc(numbers: 1, 2, 3, string: "hello")

/// MARK 字面量

// ExpressibleByBooleanLiteral

// [枚举的原始值](https://www.cnswift.org/enumerations#spl-4)
enum MyBool: Int {
    case myTrue, myFalse
}

extension MyBool: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .myTrue : .myFalse
    }
}

let myTrue: MyBool = true
//let myFalse: MyBool = false
let myFalse = false

myTrue.rawValue

// 实现自己的 Person 类的 字符串字面量创建的方法

//class Person {
//    let name: String
//    init(name value: String) {
//        self.name = value
//    }
//}

class Person: ExpressibleByStringLiteral {
    let name: String
    init(name value: String) {
        self.name = value
    }
    // ExpressibleByUnicodeScalarLiteral
    required convenience init(unicodeScalarLiteral value: String) {
        // self.name = value
        self.init(name: value)
    }
    // ExpressibleByExtendedGraphemeClusterLiteral
    required convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
    // ExpressibleByStringLiteral
    required convenience init(stringLiteral value: String) {
        self.init(name: value)
    }
}

let p: Person = "小明"
print("p.name = \(p.name)")

let strP = "小黄"
print("strP = \(strP)")

/*
 总结一下，字面量表达是一个很强大的特性，使用得当的话对缩短代码和清晰表意都很有帮助；但是这同时又是一个比较隐蔽的特性：因为你的代码并没有显式的赋值或者初始化，所以可能会给人造成迷惑：比如上面例子中为什么一个字符串能被赋值为 Person？你的同事在阅读代码的时候可能不得不去寻找这些负责字面量表达的代码进行查看 (而如果代码库很大的话，这不是一件容易的事情，因为你没有办法对字面量赋值进行 Cmd + 单击跳转)
 */

/// MARK: 模式匹配(~=) 与 Switch 语句

/*
 Swift 的 switch 就是使用了 ~= 操作符进行模式匹配，case 指定的模式作为左参数输入，而等待匹配的被 switch 的元素作为操作符的右侧参数。只不过这个调用是由 Swift 隐式地完成的。于是我们可以发挥想象的地方就很多了，比如在 switch 中做 case 判断的时候，我们完全可以使用我们自定义的模式匹配方法来进行判断，有时候这会让代码变得非常简洁，具有条理。我们只需要按照需求重载 ~= 操作符就行了，接下来我们通过一个使用正则表达式做匹配的例子加以说明。

 首先我们要做的是重载 ~= 操作符，让它接受一个 NSRegularExpression 作为模式，去匹配输入的 String：
 */

func ~=(pattern: NSRegularExpression, input: String) -> Bool {
    return pattern.numberOfMatches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) > 0
}

/*
 然后为了简便起见，我们再添加一个将字符串转换为 NSRegularExpression 的操作符 (当然也可以使用 ExpressibleByStringLiteral，但是它不是这个 tip 的主题，在此就先不使用它了)：
 */

prefix operator ~/

prefix func ~/(pattern: String) throws -> NSRegularExpression {
    let regx = try NSRegularExpression(pattern: pattern, options: [])
    return regx
}

let contact = ("https://onevcat.com", "onev@onevcat.com")
let mailRegex: NSRegularExpression = try ~/"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
let siteRegex: NSRegularExpression = try ~/"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"

switch contact {
case (siteRegex, mailRegex):
    print("同时拥有有效网站和邮箱")
case (_, mailRegex):
    print("只有邮箱有效")
case (siteRegex, _):
    print("只有网址有效")
default:
    print("网站和邮箱都无效")
}


