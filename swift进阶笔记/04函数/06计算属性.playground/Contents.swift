import Foundation
import CoreLocation

struct GPSTrack {
    private(set) var record: [(CLLocation, Date)] = []
}

extension GPSTrack {
    // 返回 GPS 追踪的时间戳
    // 复杂度 O(n)，n 是记录的数量
    var timestamps: [Date] {
        return record.map { $0.1 }
    }
}

// Swift API 指南推荐你对所有复杂度不是 O(1) 的计算属性都应该在文档中写明，因为调用者可能会假设一个计算属性的耗时是常数时间。

/// 延时存储属性

/*
 lazy var preview: UIImage = {
 
    return UIImage(/*...*/)
 }()
 
 */


// 延迟存储属性是 `mutating` 操作，在 `struct` 中使用延迟存储属性通常并不是一个好主意
// `lazy` 关键字不会进行任何线程同步

/// 下标

// 我们可以为已存在的类型提供新的下标重载
extension Collection {
    subscript(indice indexList: Index...) -> [Element] {
        var result: [Element] = []
        for index in indexList {
            result.append(self[index])
        }
        return result
    }
}

// 这里我们明确使用了参数标签来将我们的下标方法和标准库中的方法区分开来
let indice = Array("abcdefghijklmnopqrstuvwxyz")[indice: 7, 4, 11, 11, 14]
print(indice)// ["h", "e", "l", "l", "o"]


/// 下标进阶

var japan: [String: Any] = [
    "name": "Japan",
    "capital": "Tokyo",
    "population": 126_740_000,
    "coordinates": [
        "latitude": 35.0,
        "longitude": 139.0
    ]
]

extension Dictionary {
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get {
            return self[key] as? Result
        }
        set {
            guard let value = newValue as? Value else {
                return
            }
            self[key] = value
        }
    }
}

japan["coordinates", as: [String: Double].self]?["latitude"] = 36.0
print(japan["coordinates", as: [String: Double].self] ?? ["undefine":0.0])




















