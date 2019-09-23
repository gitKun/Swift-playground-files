import UIKit

extension UIColor {
    var rgba:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red: red, green: green, blue: blue, alpha: alpha)
        }else {
            return nil
        }
    }
    
}

extension UIColor {
    struct CodableWrapper: Codable {
        var value: UIColor
        init(_ value: UIColor) {
            self.value = value
        }
        enum CodingKeys: CodingKey {
            case red
            case green
            case blue
            case alpha
        }
        func encode(to encoder: Encoder) throws {
            guard let (red, green, blue, alpha) = value.rgba else {
                let errorContext = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported color format:\(value)")
                throw EncodingError.invalidValue(value, errorContext)
            }
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(alpha, forKey: .alpha)
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let red = try container.decode(CGFloat.self, forKey: .red)
            let green = try container.decode(CGFloat.self, forKey: .green)
            let blue = try container.decode(CGFloat.self, forKey: .blue)
            let alpha = try container.decode(CGFloat.self, forKey: .alpha)
            self.value = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

let colors: [UIColor] = [.red, .yellow, UIColor.init(displayP3Red: 0.5, green: 0.4, blue: 1.0, alpha: 0.8), UIColor.init(hue: 0.6, saturation: 1.0, brightness: 0.8, alpha: 0.9)]

let codableColors = colors.map(UIColor.CodableWrapper.init)
//let codableColors2 = colors.map { return UIColor.CodableWrapper.init($0) }

struct ColoredRect: Codable {
    var rect: CGRect
    // 对颜色进行存储
    private var _color: UIColor.CodableWrapper
    var color: UIColor {
        get { return _color.value }
        set { _color.value = newValue }
    }
    init(rect: CGRect, color: UIColor) {
        self.rect = rect
        self._color = UIColor.CodableWrapper(color)
    }
    private enum CodingKeys: String, CodingKey {
        case rect
        case _color = "color"
    }
}





