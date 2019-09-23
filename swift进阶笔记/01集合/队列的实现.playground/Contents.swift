import Foundation

protocol Queue {
    associatedtype Element

    mutating func enqueue(_ newElemanet: Element)

    mutating func dequeue() -> Element?

}

struct FIFOQueue<Element>: Queue {
    private var left: [Element] = []
    private var right: [Element] = []
    mutating func enqueue(_ newElemanet: Element) {
        right.append(newElemanet)
    }
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    var startIndex: Int { return 0 }
    var endIndex: Int { return left.count + right.count }
    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        }else {
            return right[position - left.count]
        }
    }
}

// 使用 Collection 的方法
var q = FIFOQueue<String>()
for x in ["1", "2", "foo", "3"] {
    q.enqueue(x)
}

var a = Array(q)
a.append(contentsOf: q[2...3])
//可以使用 Squence 的方法

for x in (q.map { $0.uppercased() }) {
    print(x)
}
print("====")
for x in (q.compactMap { Int($0) }) {
    print(x)
}
print("====")
for x in (q.sorted()) {
    print(x)
}
print("====")
for x in (q.joined(separator: "")) {
    print(x)
}

extension FIFOQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        left = elements.reversed()
        right = []
    }
}
let queue: FIFOQueue = [1, 2, 3]

// 字面量

