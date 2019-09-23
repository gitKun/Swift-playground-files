import Foundation

/// 值类型迭代器例子
let seq = stride(from: 0, to: 10, by: 1)//let seq: StrideTo<Int>

var i1 = seq.makeIterator()//var i1: StrideToIterator<Int>

i1.next()
i1.next()
var i2 = i1

i1.next()
i1.next()

i2.next()
i2.next()

/// 引用类型迭代器 AnyIterator

var i3 = AnyIterator(i1)

var i4 = i3

i3.next()
i3.next()

i4.next()
i4.next()

/*
 如果你要在对象间传递一个迭代器，你可以将他们封装到序列中，而不是直接传递他们
 */

/// MARK: 基于函数的迭代器和序列

// 使用 AnyIterator 来构建斐波那契迭代器

func fibsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator ({
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    })
    // 上面是简写等价于下面的写法：
    // 1. init 可以省略
    // 2. 类型推断断 声明的 result 可推断出 闭包返回类型所以 () -> Int in 可以省略;同理如果 () -> Int in  和 : AnyIterator<Int> 二者可以省略一个
    // 如果直接写 return 而不是声明 result 的话 会根据函数的返回值 推断出类型，如果不直接return 则无法推断出 result 的类型需要手动的指定类型
//    let result = AnyIterator({ () -> Int in
//        let upNum = state.0
//        state = (state.1, state.0 + state.1)
//        return upNum
//    })
//    return result
//    let result: AnyIterator<Int> = AnyIterator.init { () -> Int in
//        let upcomingNumber = state.0
//        state = (state.1, state.0 + state.1)
//        return upcomingNumber
//    }
//
//    return result
}

// AnySequence

let fibsSequence = AnySequence(fibsIterator)
Array(fibsSequence.prefix(10))//[0,1,1,2,3,5,8,13,21,34]

//let fibsSquence2 = sequence(state: <#T##State#>, next: <#T##(inout State) -> T?#>)
//let fibsSequence2: UnfoldSequence<Int, (Int, Int)>
let fibsSequence2 = sequence(state: (0, 1)) {
    (state: inout (Int, Int)) -> Int? in
    let upcomingNumber = state.0
    state = (state.1, state.0 + state.1)
    return upcomingNumber
}

/*
 "Sequence 的文档非常明确地指出了序列并不保证可以被多次遍历"
 "一个非集合的序列可能会在第二次 for-in 循环时产生随机的序列元素。"
 */
//let standardIn = AnySequence {
//    return AnyIterator {
//        readLine()
//    }
//}
//
//let numberedStdIn = standardIn.enumerated()
//
//for (i, line) in numberedStdIn {
//    print("\(i+1):\(line)")
//}

extension Sequence where Element: Equatable, SubSequence: Sequence, SubSequence.Element == Element {
    func headMirrorsTail(_ n: Int) -> Bool {
        let head = prefix(n)
        let tail = suffix(n).reversed()
        return head.elementsEqual(tail)
    }
}

let head = (1...10).prefix(2)
let tail = (1...10).suffix(2)

for i in head {
    print(i)
}
print("#-------#")
for i in tail {
    print(i)
}


