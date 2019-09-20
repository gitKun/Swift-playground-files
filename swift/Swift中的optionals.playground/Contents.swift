import UIKit


let optional1: String? = "unicorn"
let optional2: String? = nil;

switch optional1 {
case .some(let value):
    print("value is: \(value)")
case .none:
    print("value is nil!")
}

// map
let optionls = ["value1", nil, "value2"]

let value1 = optionls.map(String.init(describing:))
print(value1)

// flatMap
let value2 = optionls.flatMap(String.init(describing:))
print(value2)

// compactMap
let value3 = optionls.compactMap { $0 }
print(value3)

// 类型转化
let value4 = optional1 as! String
print(value4)

// 可选链
let value5 = optional1?.uppercased()

// for
for element in optionls {
    if let value = element {
        print(value)
    }
}

// for case let

for case let optionl? in optionls {
    print(optionl)
}

// forEach
optionls.forEach { value in
    print(value as Any)
}

// 错误转换成 optional
//try? aThrowingCall()
