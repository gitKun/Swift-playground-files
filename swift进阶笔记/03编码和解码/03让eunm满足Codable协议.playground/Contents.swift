import UIKit

/*
 // Swift 4.2 前的做法
enum Either<A: Codable, B: Codable>: Codable {
    case left(A)
    case right(B)
    private enum CoodingKeys: CodingKey {
        case left
        case right
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoodingKeys.self)
        switch self {
        case .left(let value):
            try container.encode(value, forKey: .left)
        case .right(let value):
            try container.encode(value, forKey: .right)
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoodingKeys.self)
        if let leftValue = try container.decodeIfPresent(A.self, forKey: .left) {
            self = .left(leftValue)
        }else {
            let rightValue = try container.decode(B.self, forKey: .right)
            self = .right(rightValue)
        }
    }
}
*/

// Swift 4.2 之后可以使用 extension where 来约束
enum Either<A,B> {
    case left(A)
    case right(B)
}

extension Either: Codable where A: Codable, B: Codable {
    private enum CoodingKeys: CodingKey {
        case left
        case right
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoodingKeys.self)
        switch self {
        case .left(let value):
            try container.encode(value, forKey: .left)
        case .right(let value):
            try container.encode(value, forKey: .right)
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoodingKeys.self)
        if let leftValue = try container.decodeIfPresent(A.self, forKey: .left) {
            self = .left(leftValue)
        }else {
            let rightValue = try container.decode(B.self, forKey: .right)
            self = .right(rightValue)
        }
    }
}



/// PropertyListEncoder & PropertyListEncoder

let values: [Either<String, Int>] = [.left("Forty-two"), .right(42)]

do {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let xmlData = try encoder.encode(values)
    let xmlString = String(decoding: xmlData, as: UTF8.self)
    print("xmlString: \n\(xmlString)")
    /*
     xmlString:
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
     <array>
     <dict>
     <key>left</key>
     <string>Forty-two</string>
     </dict>
     <dict>
     <key>right</key>
     <integer>42</integer>
     </dict>
     </array>
     </plist>
     */
    let decoder = PropertyListDecoder()
    let decoded = try decoder.decode([Either<String, Int>].self, from: xmlData)
    print("decoded:\n\(decoded)")
} catch {
    print("PropertyListEncoder error!!!")
    print(error.localizedDescription)
}















