import UIKit

var str = "Hello, playground"

/*
 数组C 存放 物品占用空间, W 存放物品的价值, V 代表背包的总容量
 */


public func zeroOneRack(_ V: Int, _ C: [Int], _ W: [Int]) -> Int {
    guard V > 0 && C.count == W.count else {
        return 0
    }
    let n = C.count
    // dp[i][j]: 对于下标为 0~1 的物品,背包容量为 j 时的最大值
    var dp:[[Int]] = Array.init(repeating: Array.init(repeating: 0, count: V + 1), count: n + 1)
    // 背包空的情况下，价值为 0
    // dp[0][0] = 0
    for i in 1...n {
        for j in 1...V {
            // 不选物品 i 的话，当前价值就是取到前一个物品的最大价值，也就是 dp[i - 1][j]
            //print("*** i = \(i),j = \(j), dp[i][j] = \(dp[i][j]), dp[i - 1][j] = \(dp[i - 1][j])")
            dp[i][j] = dp[i - 1][j];
            // 如果选择物品 i 使得当前价值相对不选更大，那就选取 i，更新当前最大价值
            if (j >= C[i - 1] && (dp[i][j] < dp[i - 1][j - C[i - 1]] + W[i - 1])) {
                //print("### i = \(i),j = \(j), C[i - 1] = \(C[i - 1]), W[i - 1] = \(W[i - 1]), dp[i][j] = \(dp[i][j]), dp[i - 1][j] = \(dp[i - 1][j])")
                dp[i][j] = dp[i - 1][j - C[i - 1]] + W[i - 1]
            }
        }
    }
    // 返回，对于所有物品（0～N），背包容量为 V 时的最大价值
    return dp[n][V]
}

let result1 = zeroOneRack(3, [1, 1, 1, 1], [3, 5, 2, 7])
let result2 = zeroOneRack(3, [1, 2, 1, 1], [3, 5, 2, 7])
let result3 = zeroOneRack(3, [1, 1, 1, 2], [3, 5, 2, 7])
let result4 = zeroOneRack(3, [1, 2, 1, 1], [3, 5, 2, 7])


// Mark : 空间优化

/*
 仅仅看代码就可以发现，其实 dp 数组当前行的计算只用到了前一行，我们可以利用
 滚动数组 来优化，但是再仔细看下去的话，你就会发现其实还可以更优，当前行的遍历用到的值是上一行的前面列的值，
 如果我们第二层 for 循环遍历的时候倒着遍历的话，保证了前面更新的值不会被新计算的值覆盖掉，我们仅仅用一维数组就可以完美解决问题，
 代码如下：
 */

public func zeroOnePackOpt(_ V: Int, _ C: [Int], _ W: [Int]) -> Int {
    guard V > 0 && C.count == W.count else {
        return 0
    }
    let n = C.count
    var dp = Array.init(repeating: 0, count: V + 1)
    
    for i in 0..<n {
        for j in (C[i]...V).reversed() {
            dp[j] = max(dp[j], dp[j - C[i]] + W[i])
        }
    }
    return dp[V]
}

let result5 = zeroOnePackOpt(3, [1, 1, 1, 1], [3, 5, 2, 7])
let result6 = zeroOnePackOpt(3, [1, 2, 1, 1], [3, 5, 2, 7])
let result7 = zeroOnePackOpt(3, [1, 1, 1, 2], [3, 5, 2, 7])
let result8 = zeroOnePackOpt(3, [1, 2, 1, 1], [3, 5, 2, 7])
