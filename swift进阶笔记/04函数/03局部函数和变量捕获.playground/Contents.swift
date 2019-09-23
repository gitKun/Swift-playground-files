import Foundation

extension Array where Element: Comparable {
    private mutating func merge(lo: Int, mi: Int, hi: Int) {
        var tmp: [Element] = []
        var i = lo, j = mi
        while i != mi && j != hi {
            if self[j] < self[i] {
                tmp.append(self[j])
                j += 1
            }else {
                tmp.append(self[i])
                i += 1
            }
        }
        tmp.append(contentsOf: self[i..<mi])
        tmp.append(contentsOf: self[j..<hi])
        replaceSubrange(lo..<hi, with: tmp)
    }
    // Inefficient: 低效率的,无效率的
    mutating func mergeSortInPlaceInefficient() {
        let n = count
        var size = 1
        while size < n {
            for lo in stride(from: 0, to: n - size, by: size * 2) {
                merge(lo: lo, mi: (lo + size), hi: Swift.min(lo + size * 2, n))
            }
            size *= 2
        }
    }
}

/// 将 merge 定义为内部函数

extension Array where Element: Comparable {
    
    mutating func mergeSortInPlace() {
        // 定义一个临时c存储
        var tmp: [Element] = []
        // 给他足够大的空间
        tmp.reserveCapacity(count)
        
        func mergeInFunc(lo: Int, mi: Int, hi: Int) {
            // 清空存储，但是保留容量
            tmp.removeAll(keepingCapacity: true)
            
            var i = lo, j = mi
            while i != mi && j != hi {
                if self[j] < self[i] {
                    tmp.append(self[j])
                    j += 1
                } else {
                    tmp.append(self[i])
                    i += 1
                }
            }
            tmp.append(contentsOf: self[i..<mi])
            tmp.append(contentsOf: self[j..<hi])
            replaceSubrange(lo..<hi, with: tmp)
        }
        let n = count
        var size = 1
        while size < n {
            for lo in stride(from: 0, to: n - size, by: size * 2) {
                mergeInFunc(lo: lo, mi: (lo + size), hi: Swift.min(lo + size * 2, n))
            }
            size *= 2
        }
    }
}

/*
 因为闭包 (也包括内部函数) 通过引用的方式来捕获变量，所以在单次的 mergeSortInPlace 调用中，每个对于 merge 的调用都将共享这个存储。不过它依然是一个局部变量，不同的并行的 mergeSortInPlace 中使用的将是分开的实例。使用这项技术可以为排序带来巨大的速度提升，而并不需要在原来的版本上做特别大的改动。
 */








