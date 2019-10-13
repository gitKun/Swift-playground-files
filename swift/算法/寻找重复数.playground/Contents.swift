import UIKit

var str = "Hello, playground"


/**
 *! 题目描述:
 *
 * 今天分享的题目来源于 LeetCode 第 287 号问题：寻找重复数。
 * 给定一个包含 n + 1 个整数的数组 nums，其数字都在 1 到 n 之间（包括 1 和 n），可知至少存在一个重复的整数。
 * 假设只有一个重复的整数，找出这个重复的数;
 *
 *
 *! 示例1:
 *
 *  输入: [1,3,4,2,2]
 *  输出: 2
 *
 *! 示例2
 *
 *  输入: [3,1,3,4,2]
 *  输出: 3
 *
 *! 说明：
 *  不能更改原数组（假设数组是只读的）。
 *  只能使用额外的 O(1) 的空间。
 *  时间复杂度小于 O(n^2) 。
 *  数组中只有一个重复的数字，但它可能不止重复出现一次。
 *
 */


/**
 *! 解析:
 *  二分法(值二分法)
 *
 *! 解析1:
 *
 *  [1,3,4,2,2]                      元素个数
 *  <= 1 的元素：1                       1
 *  <= 2 的元素：1, 2, 2                 3
 *  <= 3 的元素：1, 2, 2, 3              4
 *  <= 4 的元素：1, 2, 2, 3, 4           5
 *
 *
 *! 解析2:
 *
 *  [3,3,3,3,4]
 *  <= 1 的元素：                        0
 *  <= 2 的元素：                        0
 *  <= 3 的元素：3, 3, 3, 3              4
 *  <= 4 的元素：3, 3, 3, 3, 4           5
 *
 *
 * 我们要找的答案其实就处于一个分界点的位置，寻找边界值，
 * 这又是二分的一个应用，而且题目已经告诉我们数组里面的值只可能在 [1, n] 之间，
 * 这么一来，思路就是在 [1, n] 区间上做二分，然后按我们之前提到的逻辑去做分割。
 * 整个解法的时间复杂度是 O(nlogn)，也是满足题目要求的
 *
 *  上面的解法不是最优的，但是个人觉得是根据现有的知识比较容易想到的。
 *
 */


let nums1 = [1, 6, 2, 3, 4, 5, 2, 7]

/// 二分法查找

public class Solution1 {
    public class func findDuplicate(_ nums: [Int]) -> Int {
        let len = nums.count
        var start = 1
        var end = len - 1
        while start < end {
            let mid = start + (end - start) / 2
            var counter = 0
            for num in nums {
                if num <= mid {
                    counter += 1
                }
            }
            if counter > mid {
                end = mid
            } else {
                start = mid + 1
            }
        }
        return start
    }
}

print("二分法查找到的重复数字为: \(Solution1.findDuplicate(nums1))")


/// 快慢指针解法

public class Solution2 {
    public class func findDuplicate(_ nums: [Int]) -> Int {
        var fast = nums[nums[0]]
        var slow = nums[0]
        while fast != slow {
            fast = nums[nums[fast]]
            slow = nums[slow]
        }
        slow = 0
        while fast != slow {
            fast = nums[fast]
            slow = nums[slow]
        }
        return slow
    }
}

print("快慢指针查找到的重复数字为: \(Solution1.findDuplicate(nums1))")


