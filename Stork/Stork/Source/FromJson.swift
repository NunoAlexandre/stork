import Foundation

/*
  Stork > FromJson

  The 'FromJson' protocol requires a complying type to
  offer a way of maybe being built from a 'JsonValue'.
*/
protocol FromJson {
  static func from(value: JsonValue) -> Self?
}

extension FromJson {

  static func from(json: JSON) -> Self? {
    return Self.from(value: .object(json))
  }
}

extension String: FromJson {
  static func from(value: JsonValue) -> String? {
    return value.stringValue()
  }
}

extension Bool: FromJson {
  static func from(value: JsonValue) -> Bool? {
    return value.boolValue()
  }
}

extension Int: FromJson {
  static func from(value: JsonValue) -> Int? {
    return value.numberValue()?.intValue
  }
}

extension Double: FromJson {
  static func from(value: JsonValue) -> Double? {
    return value.numberValue()?.doubleValue
  }
}

extension Decimal: FromJson {
  static func from(value: JsonValue) -> Decimal? {
    return value.numberValue()?.decimalValue
  }
}

extension Array where Element: FromJson {
  static func from(jsonArray: [JSON]) -> [Element] {
    return jsonArray.compactMap(Element.from(json:))
  }
}

extension FromJson where Self: RawRepresentable, Self.RawValue == Int {
  static func from(value: JsonValue) -> Self? {
    return value
      .numberValue()
      .map { $0.intValue }
      .flatMap(self.init(rawValue:))
  }
}

extension FromJson where Self: RawRepresentable, Self.RawValue == String {
  static func from(value: JsonValue) -> Self? {
    return value
      .stringValue()
      .flatMap(self.init(rawValue:))
  }
}

extension URL: FromJson {
  static func from(value: JsonValue) -> URL? {
    return value
      .stringValue()
      .flatMap { URL(string: $0) }
  }
}

typealias JSON = [String: Any]
