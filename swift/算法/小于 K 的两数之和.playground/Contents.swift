import UIKit

/*
 
 题目来源于 LeetCode 上第 1099 号问题：小于 K 的两数之和。
 
 给你一个整数数组 A 和一个整数 K，请在该数组中找出两个元素，使它们的和小于 K 但尽可能地接近 K，返回这两个元素的和。
 
 如不存在这样的两个元素，请返回 -1。
 
 示例一:
 
 输入：A = [34,23,1,24,75,33,54,8], K = 60
 输出：58
 解释：
 34 和 24 相加得到 58，58 小于 60，满足题意。
 
 示例二:
 
 输入：A = [10,20,30], K = 15
 输出：-1
 解释：
 我们无法找到和小于 15 的两个元素。
 */


public func twoSunLessThanK(_ array:[Int], _ k: Int) -> Int {
    guard !array.isEmpty else {
        return -1;
    }
    var sortedArray = array.sorted()
    var left = 0;
    var right = sortedArray.count - 1
    var result = Int.min
    
    while left < right {
        if sortedArray[left] + sortedArray[right] >= k {
            right -= 1
        } else {
            result = max(result, sortedArray[left] + sortedArray[right])
            left += 1
        }
    }
    return result == Int.min ? -1 : result
}

let result1 = twoSunLessThanK([34,23,1,24,75,33,54,8], 60)
let result2 = twoSunLessThanK([10,20,30], 15)
