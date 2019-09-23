import Foundation

public class UnionFindSet {
    
    private var element:[Int]
    
    init(_ count: Int) {
        // 初始化全部为 -1,值为 -1 的下标即为根节点
        element = Array(repeating: -1, count: count)
    }
    // 找到一个数的根,返回值为这个根的下标(找到最顶部的朋友所在的位置)
    public func find(_ x: Int) -> Int {
        var index = x
        while(element[index] != -1) {
            index = element[index]
        }
        return index
    }
    // 把两个数的根连接起来(建立朋友关系)
    public func union(_ x: Int, _ y: Int) -> Void {
        // 寻根
        let rootX = find(x)
        let rootY = find(y)
        // 如果不是同一个根就连接起来
        if rootX != rootY {
            // 将根rootX下标的值置为索引(下标)rootY
            element[rootX] = rootY
        }
        // 如果根相同则不许需要连接防止形成环结构
    }
    // 计算形成了多少棵树
    public func count() -> Int {
        var count = 0
        for item in element {
            if item == -1 {
                count += 1
            }
        }
        return count
    }
    // 打印并查集
    public func printUnioFindSet() {
        for item in element {
            print(item)
        }
        print("\n")
    }
}

let ufs = UnionFindSet(10)
ufs.union(0, 1)
ufs.union(0, 2)
ufs.union(3, 4)
ufs.union(3, 1)
ufs.union(5, 7)
ufs.union(7, 8)
ufs.union(7, 8)

print(ufs.count())

/// MARK: 优化合并：基于矮树合并入高树

public class UnionFindSetMergeOptimize {
    // 存储并查集
    private var element:[Int]
    // 存储树的高度
    private var heights:[Int]
    
    init(_ count: Int) {
        // 初始化全部为 -1,值为 -1 的下标即为根节点
        element = Array(repeating: -1, count: count)
        heights = Array(repeating: 1, count: count)
    }
    // 找到一个数的根,返回值为这个根的下标(找到最顶部的朋友所在的位置)
    public func find(_ x: Int) -> Int {
        var index = x
        while(element[index] != -1) {
            index = element[index]
        }
        return index
    }
    // 把两个数的根连接起来(建立朋友关系)
    public func union(_ x: Int, _ y: Int) -> Void {
        // 寻根
        let rootX = find(x)
        let rootY = find(y)
        // 如果不是同一个根就连接起来
        if rootX != rootY {
            // 矮树向高树合并
            if heights[rootX] > heights[rootY] {
                element[rootY] = rootX
            } else if heights[rootX] < heights[rootY] {
                element[rootX] = rootY
            }else {
                // 如果高度相同，随便合并但要将 对应的 高度加一
                element[rootX] = rootY
                heights[rootY] += 1
            }
            
        }
        // 如果根相同则不许需要连接防止形成环结构
    }
    // 计算形成了多少棵树
    public func count() -> Int {
        var count = 0
        for item in element {
            if item == -1 {
                count += 1
            }
        }
        return count
    }
    // 打印并查集
    public func printUnioFindSet() {
        for item in element {
            print(item)
        }
        print("\n")
    }
}

let ufsmo = UnionFindSetMergeOptimize(10)
ufsmo.union(0, 1)
ufsmo.union(1, 2)
ufsmo.union(2, 3)
ufsmo.union(3, 4)
ufsmo.union(4, 5)
ufsmo.union(5, 6)
ufsmo.union(6, 7)
ufsmo.union(7, 8)
ufsmo.union(8, 9)

print(ufsmo.count())
