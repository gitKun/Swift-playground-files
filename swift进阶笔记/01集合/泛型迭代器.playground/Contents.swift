import Foundation

struct PrefixIterator<Base: Collection>: IteratorProtocol, Sequence {
    let base: Base
    var offSet: Base.Index
    init(_ base: Base) {
        self.base = base
        self.offSet = base.startIndex
    }
    mutating func next() -> Base.SubSequence? {
        guard offSet < base.endIndex else {
            return nil
        }
        print("改变前的offeset = \(offSet)")
        base.formIndex(after: &offSet)
        print("改变后的offeset = \(offSet)")
        return base.prefix(upTo: offSet)
    }
}

let number = [1, 2, 3]
let numberSlice = PrefixIterator(number)
let resultArray = Array.init(numberSlice)
print(numberSlice)
print(resultArray)



