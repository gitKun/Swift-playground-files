import Foundation

struct Address {
    var street: String
    var city: String
    var zipCode: Int
}

struct Person {
    let name: String
    var address: Address
}

let streetKeyPath = \Person.address.street
let nameKeyPath = \Person.name

let simpsomResidence = Address(street: "1094 Evergreen Terrace", city: "Springfielf", zipCode: 97475)
var lisa = Person(name: "Lisa Simpson", address: simpsomResidence)
lisa[keyPath: nameKeyPath]
lisa[keyPath: streetKeyPath]

lisa[keyPath: streetKeyPath] = "742 Evergreen Terrace"


// KeyPath<Person, String> + KeyPath<String, Int> = KeyPath<Person, Int>
//let nameCountKeyPath = nameKeyPath.appending(path: \String.count)



typealias SortDescriptor<Value> = (Value, Value) -> Bool

func sortDescriptor<Value, Key>(key: @escaping(Value) -> Key) -> SortDescriptor<Value> where Key: Comparable {
    return { key($0) < key($1) }
}

let streetSD: SortDescriptor<Person> = sortDescriptor { $0.address.street }

// 使用 KeyPath 重载

func sortDescriptor<Value, Key>(key: KeyPath<Value, Key>) -> SortDescriptor<Value> where Key: Comparable {
    return { $0[keyPath: key] < $1[keyPath: key] }
}

let streetSDKeyPath: SortDescriptor<Person> = sortDescriptor(key: \.address.street)


/// 可写键路径

/*
 1. 单向数据绑定
 */

extension NSObjectProtocol where Self: NSObject {
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>,
                           writeTo other: Other,
                           _ otherKeyPath: ReferenceWritableKeyPath<Other, A>)
        -> NSKeyValueObservation
        where A: Equatable, Other: NSObjectProtocol
    {
        return observe(keyPath, options: .new) {_, change in
            guard let newValue = change.newValue,
                other[keyPath: otherKeyPath] != newValue else
            {
                return
            }
            other[keyPath: otherKeyPath] = newValue
        }
    }
}

extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self, A>,
                        to other: Other,
                        _ otherKeyPath: ReferenceWritableKeyPath<Other, A>)
        -> (NSKeyValueObservation, NSKeyValueObservation)
        where A: Equatable, Other: NSObject
    {
        let one = observe(keyPath, writeTo: other, otherKeyPath)
        let two = other.observe(otherKeyPath, writeTo: self, keyPath)
        return (one, two)
    }
}

final class Sampla: NSObject {
    @objc dynamic var name = ""
}

class MyObj: NSObject {
    @objc dynamic var test = ""
}

let sample = Sampla()
let other = MyObj()

let observation = sample.bind(\Sampla.name, to: other, \.test)

sample.name = "New"
other.test//"New"
other.test = "Hi"
sample.name
sample.name = "Hello"
other.test

/// 键路径层级






















