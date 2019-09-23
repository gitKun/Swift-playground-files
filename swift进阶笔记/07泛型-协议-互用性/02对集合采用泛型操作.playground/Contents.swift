import Foundation
import UIKit


// 泛型二分法查找

extension RandomAccessCollection {
    public func binarySearch(for value: Element, areIncreasingOrder: (Element, Element) -> Bool) -> Index?
    {
        guard !isEmpty else {
            return nil
        }
        var left = startIndex
        var right = endIndex
        
        while left <= right {
            // RandomAccessCollection 类型的集合 distance 的操作复杂度为 O(1)
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: (dist / 2))
            let candidate = self[mid]
            if areIncreasingOrder(candidate, value) {
                left = index(after: mid)
            }else if areIncreasingOrder(value, candidate) {
                right = index(before: mid)
            }else {
                // 如果两个元素互无顺序关系，那么他们一定相等(由于 isOrderedBefore 的需求)
                return mid
            }
        }
        return nil
    }
}

extension RandomAccessCollection where Element: Comparable {
    func binarySearch(for value: Element) -> Index? {
        return binarySearch(for: value, areIncreasingOrder: <)
    }
}



/*
extension String {
    func tests() -> Int {
        let start = startIndex
        let end = endIndex
        // 由于 String 不是 RandomAccessCollection 类型，
        // 因此 distance 的复杂度为 O(n)，n 为 from 到 end 的间距
        let result = distance(from: start, to: end)
        return result
    }
}

"1234".tests()// 4
"👨‍🚒爱👮‍♀️".tests()// 3
"👨‍🚒爱👮‍♀️".count// 3
*/

let a = ["a", "b", "c", "d", "e", "f", "g"]
let r = a.reversed()
r.binarySearch(for: "g", areIncreasingOrder: >) == r.startIndex

let s = a[2...5]
s.startIndex//2
s.binarySearch(for: "d")//Option(3)

/// MARK: 集合随机排列

// 拓展 arc4random_uniform

extension BinaryInteger {
    static func arc4random_uniform(_ upper_bound: Self) -> Self {
        precondition(upper_bound > 0 && UInt32(upper_bound) < UInt32.max,
                     "arc4random_uniform inly callable up to \(UInt32.max)")
        return Self(Darwin.arc4random_uniform(UInt32(upper_bound)))
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    mutating func shuffle() {
        var i = startIndex
        let beforeEndIndex = endIndex//index(before: endIndex)
        while i < beforeEndIndex {
            let dist = distance(from: i, to: beforeEndIndex)
            let randomDistance = Int.arc4random_uniform(dist)
            let j = index(i, offsetBy: randomDistance)
            self.swapAt(i, j)
            formIndex(after: &i)
        }
    }
}

extension Sequence {
    func shuffled() -> [Element] {
        var clone = Array(self)
        clone.shuffle()
        return clone
    }
}

var numbers = Array(1...10)
numbers.shuffle()
numbers.shuffle()
/*
 // 验证算法从 endIndex 为结束不会出错
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
numbers.shuffle()
 
for _ in 1...100 {
    print(Darwin.arc4random_uniform(10))
}
*/

/*
let nsmArray = NSMutableArray(array: ["1", "2"])

var clonArray = nsmArray

clonArray.add("3")
clonArray
nsmArray
*/

extension MutableCollection where Self:RandomAccessCollection, Self: RangeReplaceableCollection {
    func shuffled() -> Self {
        var clone = Self()
        clone.append(contentsOf: self)
        clone.shuffle()
        return clone
    }
}







