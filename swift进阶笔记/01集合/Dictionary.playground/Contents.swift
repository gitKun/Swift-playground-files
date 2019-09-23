import Foundation

/// MARK: 字典常用的方法

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String : Setting] = [
    "Airplane Mode" : .bool(false),
    "Name": .text("My iPhone")
]

var settings = defaultSettings
let overriddenSettings: [String : Setting] = ["Name" : .text("Jane's iPhone")]

settings.merge(overriddenSettings) { $1 }
print(settings)

extension Sequence where Element: Hashable {
    var frequencies: [Element: Int] {
        let frequencyParis = self.map { ($0, 1) }
        return Dictionary.init(frequencyParis, uniquingKeysWith: +)
    }
}

let frequencyParis = "hello".map { ($0, 1) }
let frequencies = "hello".frequencies
let frequenciesFilter = frequencies.filter { $0.value > 1 }
print(frequenciesFilter)


