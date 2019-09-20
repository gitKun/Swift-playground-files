import UIKit

/// MARK:  https://juejin.im/post/5d6b92bfe51d453b1d64832c


/*
 第k大元素问题(k-th Largest Element Problem)
 你有一个整数数组a。 编写一个算法，在数组中找到第k大的元素。
 例如，第1个最大元素是数组中出现的最大值。 如果数组具有n个元素，则第n最大元素是最小值。 中位数是第n/2最大元素。
 */



// 朴素 时间:O(nlogn) 空间:O(n)

func kthLargest(a: [Int], k: Int) -> Int? {
    let len = a.count
    if k > 0 && k <= len {
        let sorted = a.sorted()
        return sorted[len - k]
    } else {
        return nil
    }
}


// 更快的方法

public func randomizedSelect<T: Comparable>(_ array: [T], order k: Int) -> T {
    var a = array

    func randomPivot<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> T {
        let pivotIndex = Int.random(in: low...high)
        a.swapAt(pivotIndex, high)
        return a[high]
    }
    
    func randomizedPartition<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> Int {
        let pivot = randomPivot(&a, low, high)
        var i = low
        for j in low..<high {
            if a[j] <= pivot {
                a.swapAt(i, j)
                i += 1
            }
        }
        a.swapAt(i, high)
        return i
    }
    
    func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
        if low < high {
            let p = randomizedPartition(&a, low, high)
            if k == p {
                return a[p]
            } else if k < p {
                return randomizedSelect(&a, low, p - 1, k)
            } else {
                return randomizedSelect(&a, p + 1, high, k)
            }
        } else {
            return a[low]
        }
    }
    precondition(a.count > 0)
    return randomizedSelect(&a, 0, a.count - 1, k)
}

/*
 
 randomPivot()选择一个随机数并将其放在当前分区的末尾（这是Lomuto分区方案的要求，有关详细信息，请参阅快速排序上的讨论）。
 
 
 randomizedPartition()是Lomuto的快速排序分区方案。 完成后，随机选择的基准位于数组中的最终排序位置。它返回基准值的数组索引。
 
 
 randomizedSelect()做了所有困难的工作。 它首先调用分区函数，然后决定下一步做什么。 如果基准的索引等于我们正在寻找的k元素，我们就完成了。 如果k小于基准索引，它必须回到左分区中，我们将在那里递归再次尝试。 当第k数在右分区中时，同样如此。
 
 
 很酷，对吧？ 通常，快速排序是一种 O(nlogn) 算法，但由于我们只对数组中较小的部分进行分区，因此randomizedSelect()的运行时间为 O(n)。
 
 */

