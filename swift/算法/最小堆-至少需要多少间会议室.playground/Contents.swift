import UIKit


/**
 * 今天分享的题目来源于 LeetCode 第 252 号问题：会议室。这是一道题目很好理解，解法也比较多的题目，
 * 可以很好的复习 最小堆 这种数据结构。
 *
 *
 *! 题目描述:
 *
 *  给定一个会议时间安排的数组，每个会议时间都会包括开始和结束的时间  [[ s1 , e1 ] ，[ s2 , e2 ]，…] (si < ei)
 *  为避免会议冲突，同时要考虑充分利用会议室资源，请你计算至少需要多少间会议室，才能满足这些会议安排。
 *
 *! 示例1:
 *
 *  输入: [[0, 30],[5, 10],[15, 20]]
 *  输出: 2
 *
 *! 示例2:
 *
 *  输入: [[7,10],[2,4]]
 *  输出: 1
 *
 */


/**
 *! 解析:
 *
 *  对于这道题，我们需要知道的是，“当一个会议要开始的时候，需不需要另外安排会议室？”，
 *  你可以看到，按照这个思路来说，我们考虑的顺序是按照会议开始的时间，因此这里按照会议起始的时间来排序。
 *
 *  排完序之后又遇到一个问题就是，有的会议长有的会议短，当新的一个会议开始的时候，我们要怎么确定这个时候是否有之前空出来的会议室？
 *  因此我们还要对会议的结束时间进行统计，每当一个会议开始，我们就去检查在这个会议之前开始的会议的结束时间的最小值，
 *  到这里，你应该能想到堆这个数据结构，没错，我们可以维护一个最小堆用于记录结束时间，这样可以保证整个解的时间复杂度是 O(nlogn) 的。
 *
 *  另外还有一种解法也是比较巧妙，没有用到什么特别的数据结构。
 *  这种解法是将所有会议的起始时间和终止时间拆分开来形成两个数组，分别排序，遍历起始时间数组，
 *  然后看终止时间数组中是否有结束的会议，记录即可。整个时间复杂度也是 O(nlogn) 的。
 *
 */


/** 参考代码 1 */

typealias meeting = (start :Int, end: Int)

func minMeetingRoom(_ interVals:[meeting]) -> Int {
    guard !interVals.isEmpty else {
        return 0
    }
    
    let count = interVals.count
    
    var startArray = Array.init(repeating: 0, count: count)
    var endArray = Array.init(repeating: 0, count: count)
    
    for i in 0..<count {
        let meeting = interVals[i]
        startArray[i] = meeting.start
        endArray[i] = meeting.end
    }
    
    // 排序
    startArray.sort()
    endArray.sort()
    // 记录 会议结束时间 在 会议开始时间 之前 的次数, 每出现一就表示 最大 次数 n 需要减小 1
    var e = 0
    for i in 0..<count {
        if endArray[e] <= startArray[i] {
            e += 1
        }
    }
    return count - e
}

let meetings1 = [(7, 10), (2, 4)]
let result1 = minMeetingRoom(meetings1)
print("result1 = \(result1)")


let meetings2 = [(4, 10), (2, 5), (0, 6)]
let result2 = minMeetingRoom(meetings2)
print("result2 = \(result2)")
