import Foundation

/// MARK: 迭代器

struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

var fibsIterator = FibsIterator()
while let next = fibsIterator.next() {
    guard next < 100 else { break }
    print("firbsIterator result = \(next)")
}

/// MARK: 遵守序列协议

struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    mutating func next() -> Substring? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}

struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

for prefix in PrefixSequence(string: "Hello") {
    print(prefix)
}

let mapResult = PrefixSequence(string: "hello").map { $0.uppercased() }
print(mapResult)
let prefix10 = PrefixSequence(string: "123456789abcdef").prefix(10)
print(prefix10)

// 创建一个fibs的迭代序列
struct FibsSequence: Sequence {
    func makeIterator() -> FibsIterator {
        return FibsIterator()
    }
}

for result in FibsSequence().prefix(10) {
    print(result)
}
