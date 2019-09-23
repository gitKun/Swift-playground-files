import Foundation

/// 结构体代理

/*
protocol AlertViewDelegate {
    mutating func buttonTapped(atIndex index: Int)
}
class AlertView {
    var buttons: [String]
    var delegate: AlertViewDelegate?
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}

struct TapLogger: AlertViewDelegate {
    var taps: [Int] = []
    mutating func buttonTapped(atIndex index: Int) {
        taps.append(index)
    }
}

let alert = AlertView()
let logger = TapLogger()
alert.delegate = logger
alert.fire()

print(logger.taps)

if let theLogger = alert.delegate as? TapLogger {
    print(theLogger.taps)
}
*/
/*
 很显然这种方式并不能很好地工作。当使用类时，很容易造成引用循环，当使用结构体时，原来的值不会被改变。一句话总结：在代理和协议的模式中，并不适合使用结构体.
 */


/// 使用函数代替

class AlertView {
    var buttons: [String]
    var buttonTapped:((_ buttonIndex: Int) -> ())?
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    func fire() {
        buttonTapped?(1)
    }
}

struct TapLogger {
    var taps: [Int] = []
    mutating func logTap(index: Int) {
        taps.append(index)
    }
}

let alert = AlertView()

var logger = TapLogger()

//alert.buttonTapped = logger.logTap//Partial application of 'mutating' method is not allowed

// 我们是想要捕获原来的 logger 变量 (不是其中的值)，然后我们将改变它：
alert.buttonTapped = { logger.logTap(index: $0) }

class ViewController {
    let alert: AlertView
    init() {
        alert = AlertView(buttons: ["OK", "Cancel"])
        // 这里会造成循环引用
        // alert.buttonTapped = self.buttonTapped(atIndex:)
        // self.buttonTapped(atIndex:) 可以简写为 self.buttonTapped/buttonTapped
        
        // 改为weak
        alert.buttonTapped = {[weak self] index in
            self?.buttonTapped(atIndex: index)
        }
    }
    func buttonTapped(atIndex index: Int) {
        print("Button tapped:\(index)")
    }
    deinit {
        print("ViewController deinit!")
    }
}

var vc: ViewController? = ViewController()
vc = nil


class MyClass {
    func printFunc(by count: Int)  {
        print("current count is: \(count)")
    }
}
let cls = MyClass()
let mth = MyClass.printFunc// let mth: (MyClass) -> (Int) -> ()
print(type(of: MyClass.printFunc))// (ViewController) -> (Int) -> ()
let method1 = MyClass.printFunc(cls)
let method2 = cls.printFunc
method1(1)
method2(2)
/*
 如果你检查 MyClass.printFunc 这个表达式的类型时，你会发现它是:
 (MyClass) -> (Int) -> ()。
 这是什么？
 在底层，实例方法会被处理为这样一个函数：如果给定某个实例，它将返回另一个可以在该实例上进行操作的函数。
 cls.printFunc 实际上只是 MyClass.printFunc(cls) 的另一种写法
 - 两种表达式返回的都是类型为 (Int) -> () 的函数，这个函数强引用了 cls 实例.
 */
















