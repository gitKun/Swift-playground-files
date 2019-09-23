import Foundation

// 1. 写时复制(copy-0n-write) 和 复制优化 不是同一件事;
// 复制优化是编译器做的事情：值总是需要复制这件事情听来可能有点低效，不过，编译器可以帮助我们进行优化，以避免很多不必要的复制操作。因为结构体非常基础和简单，所以这是可能的。结构体复制的时候发生的是按照字节进行的浅复制。除非结构体中含有类，否则复制时都不需要考虑其中属性的引用计数。当使用 let 来声明结构体时，编译器可以确定之后这个结构体的任何一个字节都不会被改变。另外，和 C++ 中类似的值类型不同，开发者没有办法知道和干预何时会发生结构体的复制。这些简化给了编译器更多的可能性，来排除那些不必要的复制，或者使用传递引用而非值的方式来优化一个常量结构体。

/// MARK: 写时复制

/*
 写时复制:它的工作方式是，每当数组被改变，它首先检查它对存储缓冲区的引用是否是唯一的，或者说，检查数组本身是不是这块缓冲区的唯一拥有者。如果是，那么缓冲区可以进行原地变更；也不会有复制被进行。不过，如果缓冲区有一个以上的持有者 (如本例中)，那么数组就需要先进行复制，然后对复制的值进行变化，而保持其他的持有者不受影响。
 */


/*
 isKnownUniquelyReferenced: 用于检测某个引用是否是唯一
    对于 Swift 类的实例会根据是否只有一个持有者返回 true/false
    对于 Objective-C 的类会直接返回 false
 */

final class Box<A> {
    var unbox: A
    init(_ value: A) {
        self.unbox = value
    }
}

var x = Box(NSMutableData())
isKnownUniquelyReferenced(&x)
var y = x
isKnownUniquelyReferenced(&x)
var xObjC = NSMutableData()
isKnownUniquelyReferenced(&xObjC)

struct MyData {
    private var _data: Box<NSMutableData>
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                print("Making a copy!")
            }
            return _data.unbox
        }
    }
    
    init() {
        _data = Box(NSMutableData())
    }
    init(_ data: NSData) {
        _data = Box(data.mutableCopy() as! NSMutableData)
    }
}

extension MyData {
    mutating func append(_ byte: UInt8) {
        var mutableByte = byte
        _dataForWriting.append(&mutableByte, length: 1)
    }
}

var bytes = MyData()
var copy = bytes

for byte in 0..<5 as Range<UInt8> {
    print("Appending 0x\(String(byte, radix: 16))")
    bytes.append(byte)
}

final class Empty {}

struct COWStruct {
    var ref = Empty()
    mutating func change() -> String {
        if isKnownUniquelyReferenced(&ref) {
            return "No copy."
        }else {
            return "Copy!"
        }
    }
}

var s = COWStruct()
s.change()

var original = COWStruct()
var copyOrig = original
original.change()

var array = [COWStruct()]
array[0].change()

var xCow = COWStruct()
var otherArray = [xCow]
//var arrayXCow = otherArray[0]
xCow.change()

var anotherArray = [COWStruct()]
var yCow = anotherArray[0]
yCow.change()

var dict = ["key" : COWStruct()]
dict["key"]?.change()

var dictXCow = COWStruct()
var otherDict = ["key" : dictXCow]
dictXCow.change()

var anotherDict = ["key" : COWStruct()]
var dictYCow = anotherDict["key"]!
dictYCow.change()

struct ContainerStruct<A> {
    var storage: A
    subscript(s: String) -> A {
        get { return storage }
        set { storage = newValue }
    }
}

var d = ContainerStruct(storage: COWStruct())
d.storage.change()
d["key"].change()


