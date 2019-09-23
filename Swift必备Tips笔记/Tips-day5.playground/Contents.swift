//import UIKit
import Foundation


/// MARK: GCD

// 封装延时执行的 函数

typealias Task = (_ cancle: Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {

    func dispatch_later(block: @escaping () -> ()) {
        let t = DispatchTime.now() + time
        //DispatchQueue.main.asyncAfter(deadline: <#T##DispatchTime#>, execute: <#T##() -> Void#>)
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (() -> Void)? = task
    var result: Task?

    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancel(_ task: Task?) {
    task?(true)
}

print("即将开始一个延时任务    \(NSDate())")
delay(2){
    print("2 秒后输出           \(NSDate())")
}
print("已经开始延时任务       \(NSDate())")

let task = delay(5) {print("拨打 110")}
cancel(task)
