import UIKit

var str = "Hello, playground"

/*
 *! 题目描述:
 
 给定一个有序数组,需要在原地删除重复出现的元素,使得每个元素只出现一次,返回移除后数组的新长度.
 
 *! 要求:
 
 不能使用额外的数组空间,必须在原数组中修改并使用O(1)额外空间
 
 *! 备注: 不需要考虑数组中超出新长度后面的元素.
 
 
 *! 示例1:
 
 nums = [1, 1, 2]
 
 函数返回长度为 2, nums 的前 2 个元素被修改该为 1, 2.
 
 
 *! 示例2:
 
 nums = [0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 3, 4, 4, 4]
 
 函数返回长度为 5, nums 的前 5 个元素被修改该为 0, 1, 2, 3, 4.
 
 */


public func removeDuplicates(_ nums: inout [Int]) -> Int {
    let n = nums.count
    guard n != 0 else {
        return 0
    }
    var slow = 0, fast = 1
    while fast < n {
        if nums[fast] != nums[slow] {
            slow += 1
            // 维护 nums[0...slow] 无重复
            nums[slow] = nums[fast]
        }
        fast += 1
    }
    return slow + 1
}

var nums1 = [1, 1, 2]
var nums2 = [0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 3, 4, 4, 4]

print("test1 result: ")
print("count = \(removeDuplicates(&nums1)) num1 = \(nums1)")
print("test2 result: ")
print("count = \(removeDuplicates(&nums2)) num1 = \(nums2)")



