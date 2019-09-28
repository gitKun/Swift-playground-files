import UIKit

var str = "Hello, playground"


/**
 *! 问题1: 给你一个数组和一个整数target，可以保证数组中存在两个数的和为target，请你返回这两个数的索引。
 *  比如输入nums = [3,1,3,6],target = 6，算法应该返回数组[0,2]，因为 3 + 3 = 6。
 *
 */

class Solution1 {
    // 散列表问题 时间：O(n) 空间：O(n)
    /*
    首先设置一个 Dictionary 容器 hash  用来记录元素的值与索引，然后遍历数组 nums 。
    每次遍历时使用临时变量 complement 用来保存目标值与当前值的差值
    在此次遍历中查找 hash ，查看是否有与 complement 一致的值，如果查找成功则返回查找值的索引值与当前变量的值 idx
    如果未找到，则在 hash 保存该元素与索引值 idx
    */
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var hash: [Int: Int] = [:]
        for (idx, num) in nums.enumerated() {
            if let complement = hash[target - num] {
                return [complement, idx]
            }
            hash[num] = idx
        }
        return []
    }
    
     func twoSum2(_ nums: [Int], _ target: Int) -> [Int] {
           var hash: Dictionary<Int, Int> = [:]
           for (idx, value) in nums.enumerated() {
            let targetNum = target - value
            if hash.keys.contains(targetNum) {
                return [hash[targetNum]!, idx]
            }
            hash.updateValue(idx, forKey: value)
           }
           return []
       }
}


/**
 *! 问题2: 实现一个提供向数据结构添加一个数 num ,和寻找当前数据结构中是否存在两数的和为 value,两个 API 的类
 *  `func add(_ num: Int)` `func find(_ value: Int) -> Bool`
 */

/*
 解法1: 针对频繁 add 的
 */

class TwoSunAdd {
    /**
     * 对于这个解法的时间复杂度呢，`add` 方法是 `O(1)` ，`find` 方法是 `O(N)` ，空间复杂度为 `O(N)` ，和上一道题目比较类似。
     */
    var freq: Dictionary<Int, Int> = [:]
    
    func add(_ num: Int) {
        if freq.keys.contains(num) {
            freq[num] = freq[num]! + 1
        } else {
            freq.updateValue(1, forKey: num)
        }
    }
    
    func find(_ value: Int) -> Bool {
        for key in freq.keys {
            let other = value - key
            // 情景1
            if other == key && freq[key]! > 1 {
                return true
            }
            // 情景2
            if other != key && freq.keys.contains(other) {
                return true
            }
        }
        return false
    }
}


/**
 * 解法2:针对频繁调用 `find` 的解法
 */

class TwoSumFind {
    /**
     * 每次find只要花费 `O(1)`
     */
    var sum: Set<Int> = []
    var nums: [Int] = []
    
    func add(_ num: Int) {
        for value in nums {
            sum.insert(value + num)
        }
        nums.append(num)
    }
    
    func find(_ value: Int) -> Bool {
        return sum.contains(value)
    }
}






