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
    return value.intValue()
  }
}

extension Double: FromJson {
  static func from(value: JsonValue) -> Double? {
    return value.doubleValue()
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
      .intValue()
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

typealias JSON = [String: Any]
