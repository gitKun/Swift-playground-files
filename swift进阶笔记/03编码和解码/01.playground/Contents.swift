import Foundation
import CoreLocation

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
}


let places = [
    Placemark(name: "Berlin", coordinate: Coordinate(latitude: 52, longitude: 13)),
    Placemark(name: "Cape Town", coordinate: Coordinate(latitude: -34, longitude: 18))
]

//do {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(places)
    let jsonString = String(decoding: jsonData, as: UTF8.self)
    print("jsonString = \n\(jsonString)")
//} catch {
//    print(error.localizedDescription)
//}

do {
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Placemark].self, from: jsonData)
    type(of: decoded)
    print(String(describing: decoded))
} catch  {
    print(error.localizedDescription)
}

// Encoder

struct Placemark4: Codable {
    var name: String
    var coordinate: Coordinate?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.coordinate = try container.decodeIfPresent(Coordinate.self, forKey: .coordinate)
        } catch DecodingError.keyNotFound {
            self.coordinate = nil
        }
    }
}

let invalidJSONInput = """
[
{
"name" : "Berlin",
"coordinate" : {}
},
{"name" : "Cape Town"}
]
"""

print("自定义解析")
do {
    let inputData = invalidJSONInput.data(using: .utf8)!
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Placemark4].self, from: inputData)
    print("decoded = \n\(decoded)")
} catch {
    print("error:自定义解析出错!")
    print(error.localizedDescription)
}

struct Placemark5: Codable {
    var name: String
    var coordinate: CLLocationCoordinate2D
}

/// 为不支持 Codable 的类型增加 Codable 的实现

/// 1.使用内部封装
extension Placemark5 {
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // 分别编码经度和维度
        try container.encode(coordinate.longitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.coordinate = CLLocationCoordinate2D(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude)
        )
    }
}

/// 2.通过嵌套容器实现给不支持Codable的类型增加Codable协议
struct Placemark6: Encodable & Decodable {
    var name: String
    var coordinate: CLLocationCoordinate2D
    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }
    // 嵌套容器的编码建
    private enum CoordinateCodingKeys: CodingKey {
        case latitude
        case longitude
    }
    func encode(to encoder: Encoder) throws {
        // var container: KeyedEncodingContainer<Placemark6.CodingKeys>
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        //var coordinateContainer: KeyedEncodingContainer<Placemark6.CoordinateCodingKeys>
        var coordinateContainer = container.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        try coordinateContainer.encode(coordinate.latitude, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longitude, forKey: .longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let coordinateContainer = try container.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        self.coordinate = CLLocationCoordinate2D(
            latitude: try coordinateContainer.decode(Double.self, forKey: .latitude),
            longitude: try coordinateContainer.decode(Double.self, forKey: .longitude)
        )
    }
}

/// 3.使用计算属性绕开问题

struct Placemark7: Codable {
    var name: String
    private var _coordinate: Coordinate
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: _coordinate.latitude, longitude: _coordinate.longitude)
        }
        set {
            _coordinate = Coordinate(latitude: newValue.latitude, longitude: newValue.longitude)
        }
    }
    // 指定 _coordinate 从 coordinate 字段获取
    private enum CodingKeys: String, CodingKey {
        case name
        case _coordinate = "coordinate"
    }
}



