import Foundation

enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

extension List {
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}

let list = List<Swift.Int>.end.cons(1).cons(2).cons(3)
/*
 node(3, next: List<Swift.Int>.node(2, next: List<Swift.Int>.node(1,
 next: List<Swift.Int>.end)))
 */

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in
            partialList.cons(element)
        }
    }
}

let list2: List = [3, 2, 1]

// 链表的共享

extension List {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    mutating func pop() -> Element? {
        switch self {
        case .end:
            return nil
        case let .node(x, next: tail):
            self = tail
            return x
        }
    }
}

var stack: List<Int> = [3, 2, 1]
var a = stack
var b = stack

a.pop()
a.pop()
a.pop()

stack.pop()
stack.push(4)

b.pop()
b.pop()
b.pop()

stack.pop()
stack.pop()
stack.pop()

extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}

let list3: List = ["1", "2", "3"]
for x in list3 {
    print("\(x)",terminator: "->")
}
print("\n")

list3.joined(separator: "->")
list3.contains("2")
let result3 = list3.compactMap { Int($0) }
print(result3)
list3.elementsEqual(["1", "2", "3"])
