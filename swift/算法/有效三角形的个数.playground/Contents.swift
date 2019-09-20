import UIKit

/*
 给定一个包含非负整数的数组，你的任务是统计其中可以组成三角形三条边的三元组个数。
 
 示例 1:
 输入: [2,2,3,4]
 输出: 3
 解释:
 有效的组合是:
 2,3,4 (使用第一个 2)
 2,3,4 (使用第二个 2)
 2,2,3
 
 注意:
 
 1. 数组长度不超过1000。
 2 .数组里整数的范围为 [0, 1000]。
 
 */


public func triangleCount(_ array: [Int]) -> Int {
    guard !array.isEmpty else {
        return 0
    }
    var result = 0
    let sortedArray = array.sorted()
    var third = sortedArray.count - 1
    while third >= 2 {
        var l = 0
        var r = third - 1
        while l < r {
            if sortedArray[third] < sortedArray[l] + sortedArray[r] {
                result += r - l // 直接加上存在的
                //print("\(sortedArray[r]) -> index = \(r)\n")
                r -= 1
            } else {
                l += 1
            }
        }
        third -= 1
    }
    return result
}

let result1 = triangleCount([2 ,2, 3, 4, 5, 6])
let result2 = triangleCount([2, 3, 4, 5, 6])
let result3 = triangleCount([2, 2, 3, 4])
