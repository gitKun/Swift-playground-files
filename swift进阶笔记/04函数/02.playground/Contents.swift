import Foundation

@objcMembers
final class Person: NSObject {
    let first: String
    let last: String
    let yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }
    override var description: String {
        return "last:\(last),first:\(first),yearOfBirth:\(yearOfBirth)\n"
    }
}

let people = [
    Person(first: "Emily", last: "Young", yearOfBirth: 2002),
    Person(first: "David", last: "Gray", yearOfBirth: 1991),
    Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
    Person(first: "Ava", last: "Barnes", yearOfBirth: 2000),
    Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
    Person(first: "Ava", last: "Barnes", yearOfBirth: 1998),
]

/// OC sortedArray(using:)

let lastDescriptor = NSSortDescriptor(key: #keyPath(Person.last), ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
let firstDescriptor = NSSortDescriptor(key: #keyPath(Person.first), ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
let yearDescriptor = NSSortDescriptor(key: #keyPath(Person.yearOfBirth), ascending: true)

let descriptors = [lastDescriptor, firstDescriptor, yearDescriptor]
let sortedResult = (people as NSArray).sortedArray(using: descriptors)
print(sortedResult)

/// Swift 的实现方式一 >>> 函数式

typealias SortDescriptor<Value> = (Value, Value) -> Bool

let sortByYear: SortDescriptor<Person> = { $0.yearOfBirth < $1.yearOfBirth }

let sortByLastName: SortDescriptor<Person> = {
    $0.last.localizedStandardCompare($1.last) == .orderedAscending
}

func sortDescriptor<Value, Key>(
    key: @escaping (Value) -> Key,
    by areInIncreasingOrder: @escaping (Key,Key) -> Bool) -> SortDescriptor<Value> {
    return { areInIncreasingOrder(key($0), key($1)) }
}

let sortByYearAlt: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth }, by: <)

/// Comparable 重载
func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key) -> SortDescriptor<Value> where Key: Comparable {
    return { key($0) < key($1) }
}

let sortByYearAlt2: SortDescriptor<Person> =
    sortDescriptor(key: { $0.yearOfBirth } )

/// 排序字符串

func sortDescriptor<Value, Key>(
    key: @escaping (Value) -> Key,
    ascending: Bool = true,
    by comparator: @escaping (Key) -> (Key) -> ComparisonResult
    )
    -> SortDescriptor<Value> {
        return {
            let order: ComparisonResult = ascending ? .orderedAscending : .orderedDescending
            return comparator(key($0))(key($1)) == order
        }
}

let sortByFirstName: SortDescriptor<Person> = sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)
people.sorted(by: sortByFirstName)


/// 实现 NSArray.sortedArray(using:)

func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
    return {
        for areInIncreasingOrder in sortDescriptors {
            if areInIncreasingOrder($0, $1) { return true }
            if areInIncreasingOrder($1, $0) { return false }
        }
        return false
    }
}

let  combined: SortDescriptor<Person> = combine(
    sortDescriptors: [sortByLastName, sortByFirstName, sortByYear]
)
people.sorted(by: combined)


/// 自定义运算符的方式来 合并两个排序函数

infix operator <||> : LogicalDisjunctionPrecedence

func <||><A>(lhs: @escaping (A, A) -> Bool, rhs: @escaping (A, A) -> Bool) -> (A, A) -> Bool {
    return { x, y in
        if lhs(x, y) {
            return true
        }
        if lhs(y, x) { return false }
        if rhs(x, y) { return true }
        return false
    }
}

/*
 自定义运算符在大多数情况下并不是明智之选，因为这些运算d自定义的运算符本身可能并不能描述s行为，所以他们比函数更难理解(将函数作为数据本身就已经很难理解)。但是，使用的当时m，他们又会显得无比强大
 */

let combineAlt = sortByLastName <||> sortByFirstName <||> sortByYear
people.sorted(by: combined)

/*
 自定义运算符出现的条件(条件或)：
    1. 所有使用者都清楚的知道这个运算符表达的意思
    2. 高度专用代码中使用
 */


/// 处理可选值: 编写一个接受_一个接受非可选值的函数_返回一个_接受同类型可选值的函数_

func leftFunc<A>(_ compare: @escaping (A) -> (A) -> ComparisonResult) -> (A?) -> (A?) -> ComparisonResult {
    return { lhs in { rhs in
        switch (lhs, rhs) {
        case (nil, nil): return .orderedSame
        case (nil, _): return .orderedAscending
        case (_, nil): return .orderedDescending
        case let(l?, r?): return compare(l)(r)
        }
    }}
}

/*
let files = ["one", "file.h", "file.c", "test.h"]

extension String {
    var drFileExtension: String? {
        if self.isEmpty { return nil }
        let array = self.split(separator: ".")
        if array.isEmpty {
            return nil
        } else {
            return String(array.last!)
        }
    }
}

// 不处理可选值的比较

files.sorted { l, r in r.drFileExtension?.compactMap {
    l.drFileExtension?.localizedStandardCompare($0)
    } == .orderedAscending
}

let compare = leftFunc(String.localizedStandardCompare)
let resultFiles = files.sorted(by: sortDescriptor(key: { $0.drFileExtension }, by: compare))

*/


/// 标准库提供的排序???

