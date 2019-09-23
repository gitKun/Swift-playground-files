import Foundation


let intRange = 1..<5
let intClosrRnage = 1...5

//RangeExpression
intRange.count


// public typealias CountableRange<Bound> = Range<Bound>
/*
 swift 4.2 将 CountableRange 归类为 Range 
 */
let intCountableRange: CountableRange<Int> = 1..<5
let intCountableCloseRange: CountableClosedRange<Int> = 1...5


let strRange = "a"..."d"
print(strRange.contains("e"))
print(strRange.description)
//strRange.first
let name = "Kun Kun k"
for index in stride(from: 0, to: name.count, by: 2) {
    print(index)
}
//for str in stride(from: 0, to: strRange.count, by: 1) {
//
//}


let fromA = Character("a")...//let fromA: PartialRangeFrom<Character>
let throughZ = ...Character("z")//let throughZ: PartialRangeThrough<Character>
let upto10 = ..<10//let upto10: PartialRangeUpTo<Int>
let fromFive = 5...//let fromFive: PartialRangeFrom<Int>

// swift 4.2 中已将 CountablePartialRangeFrom 归入 PartialRangeFrom
//public typealias CountablePartialRangeFrom<Bound> = PartialRangeFrom<Bound>
let fromFive2: CountablePartialRangeFrom<Int> = 5...


//Type 'Character' does not conform to protocol 'Strideable'
//for index in fromA {
//    print(index)
//}

//Type 'PartialRangeThrough<Character>' does not conform to protocol 'Sequence'
//for index in throughZ {
//    print(index)
//}

//Type 'PartialRangeUpTo<Int>' does not conform to protocol 'Sequence'
//for index in upto10 {
//    print(index)
//}

print(Int.max)//9223372036854775807
for index in (Int.max - 10)... {

    // 这里不加判断的话 在Int.max 处会崩溃
    /*
     error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).
     The process has been left at the point where it was interrupted, use "thread return -x" to return to the state before expression evaluation.
     */
    print(index)// 最后打印结果为 9223372036854775806 , 即 Int.max - 1
    guard index < Int.max - 1 else {
        break;
    }

}

/*
 其中能够计数的只有 CountablePartialRangeFrom 这一种类型，四种部分范围类型中，只有它能被进行迭代。

 迭代操作会从 lowerBound 开始，不断重复地调用 advanced(by: 1)。如果你在一个 for 循环中使用这种范围，你必须牢记要为循环添加一个 break 的退出条件，否则循环将无限进行下去 (或者当计数溢出的时候发生崩溃)。

 PartialRangeFrom 不能被迭代，这是因为它的 Bound 不满足 Strideable。

 而 PartialRangeThrough 和 PartialRangeUpTo 则是因为没有下界而无法开始迭代。
 */



let arr = [1, 2, 3, 4, 5]
let arrSli = arr[...3]//let arrSli: ArraySlice<Int>








