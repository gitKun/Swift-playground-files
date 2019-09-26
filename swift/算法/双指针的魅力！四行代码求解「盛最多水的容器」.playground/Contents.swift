import UIKit

var str = "Hello, playground"

/*
 今天图解的题目来源于 LeetCode 第 11 号问题：盛最多水的容器。这是一道可以使用 双指针 的技巧来解题的经典题目。
 */

/*
 *! 题目描述:
 
 给定 n 个非负整数 a1，a2，…，an，每个数代表坐标中的一个点 (i, ai) 。
 画 n 条垂直线，使得垂直线 i 的两个端点分别为 (i, ai) 和 (i, 0)。
 找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

 注意：你不能倾斜容器，n 至少是2
 
 *! 示例:
 
 输入: [1,8,6,2,5,4,8,3,7]
 输出: 49
 
 */


/*
 时间复杂度 O(N)，双指针遍历一次底边宽度 N 。
 空间复杂度 O(1)，指针使用常数额外空间。
 */

public func maxArea(_ height: [Int]) -> Int {
    guard !height.isEmpty else {
        return 0
    }
    func increaseIndex(_ index: inout Int) -> Int {
        defer {
            index += 1
        }
        return index
    }
    func reduceIndex(_ index: inout Int) -> Int {
        defer {
            index -= 1
        }
        return index
    }
    var left = 0
    var right = height.count - 1
    var result = 0
    while left < right {
        result = height[left] < height[right] ? max(result, (right - left) * height[increaseIndex(&left)]) : max(result, (right - left) * height[reduceIndex(&right)])
    }
    
    return result
}

let result1 = maxArea([1,8,6,2,5,4,8,3,7])

