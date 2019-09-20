import UIKit

/*
 LeetCode 第 41 号问题：缺失的第一个正数。题目难度为 Hard。本文使用了一个比较 Trick 的解法。
 
 给定一个未排序的整数数组，找出其中没有出现的最小的正整数。
 
 示例 1:
     输入: [1,2,0]
     输出: 3
 
 示例 2:
     输入: [3,4,-1,1]
     输出: 2
 
 示例 3:
     输入: [7,8,9,11,12]
     输出: 1
 
 说明:
    你的算法的时间复杂度应为O(n)，并且只能使用常数级别的空间。
 
 解析:
     给一个整形数组，找出最小缺失的正整数，例如 [0,-1,2] 中最小缺失的正整数就是 1，[ 1，2 ，4 ，9 ] 中最小缺失的正整数就是 3。
     这道题如果不加上  O(n)  时间和  O(1)  空间这样的限定条件，应该再简单不过，但是加上了这两个要求，一下子使问题变得棘手。
     怎么思考呢？
 
     首先这道题给定的条件很有限，输入参数就 只有数组 ，如果非要用   O(n)  时间和  O(1)  空间来做的话，表示我们除了输入数组以外，不能借助任何其他的数据结构。
 
     数组应该是属于一类最最基础的数据结构，除去 length 之外，就只有两个属性 index 和 value，那这道题就变成了 如何利用数组的 value 和 index 之间的关系来找到最小缺失正整数 ，如果想到了这一点，就已经成功了一半。
 
     如果继续想下去有几点是可以明确的：
 
     缺失的正整数肯定在 [1, array.length + 1] 这个范围内
     我们可以交换输入数组中的元素的位置来让 index 和 value 的关系更加明确
     保证 index 和 value 的关系后，我们可以通过 index 来判定整数的存在性
     第一点很好理解，一个数组总共有 array.length 这么多个数，全部排满，也就是 1,2,…array.length， 那么答案就是 array.length + 1，没有排满，那么在这之间肯定是有缺失元素的。
 
     第二点是说我们可以通过交换来让 index 和 value 形成对应，我们看的是 value，但是 index 可以辅助我们寻找。
 
     前两点明确了，第三点就是从头到尾寻找答案的过程。
 
 */


public func firstMissingPostive( _ nums:inout [Int]) -> UInt {
    guard !nums.isEmpty else {
        return 1
    }
    let length = nums.count
    var index = 0
    while index < length {
        if (nums[index] <= 0) || (nums[index] > length) || nums[nums[index] - 1] == nums[index]  {
            index += 1
            continue
        }
        // swap
        let tmp = nums[nums[index] - 1]
        nums[nums[index] - 1] = nums[index]
        nums[index] = tmp
    }
    print("排序后的nums:\n\(nums)")
    for i in 0..<length {
        if nums[i] != i + 1 {
            return UInt(i + 1)
        }
    }
    return UInt(length + 1)
}

var nums1 = [-1, 1, 7, 3, 5]
var nums2 = [10, 9, 16, 9, 5, 7]

print(firstMissingPostive(&nums1))
print(firstMissingPostive(&nums2))


/*
 总的来说这道题并没有涉及什么算法和数据结构的应用，有点像脑筋急转弯的感觉，想到了就做的出，想不到的话就做不出.
 但是它给我们解数组问题提供了一个新的方向：利用 index 和 value 的对应关系来辅助求解。
 */
