import Foundation

/*
  Stork > FromJson

  The 'FromJson' protocol requires a complying type to
  offer a way of maybe being built from a 'JsonValue'.
*/
public protocol FromJson {
  static func from(value: JsonValue) -> Self?
}

public  extension FromJson {
  static func from(json: JSON) -> Self? {
    return Self.from(value: .object(json))
  }
}

extension String: FromJson {
  public static func from(value: JsonValue) -> String? {
    return value.stringValue()
  }
}

extension Bool: FromJson {
  public static func from(value: JsonValue) -> Bool? {
    return value.boolValue()
  }
}

extension Int: FromJson {
  public static func from(value: JsonValue) -> Int? {
    return value.numberValue()?.intValue
  }
}

extension Double: FromJson {
  public static func from(value: JsonValue) -> Double? {
    return value.numberValue()?.doubleValue
  }
}

extension Decimal: FromJson {
  public static func from(value: JsonValue) -> Decimal? {
    return value.numberValue()?.decimalValue
  }
}

extension Array where Element: FromJson {
  public static func from(jsonArray: [JSON]) -> [Element] {
    return jsonArray.compactMap(Element.from(json:))
  }
}

extension FromJson where Self: RawRepresentable, Self.RawValue == Int {
  public static func from(value: JsonValue) -> Self? {
    return value
      .numberValue()
      .map { $0.intValue }
      .flatMap(Self.init(rawValue:))
  }
}

extension FromJson where Self: RawRepresentable, Self.RawValue == String {
  public static func from(value: JsonValue) -> Self? {
    return value
      .stringValue()
      .flatMap(Self.init(rawValue:))
  }
}

extension URL: FromJson {
  public static func from(value: JsonValue) -> URL? {
    return value
      .stringValue()
      .flatMap { URL(string: $0) }
  }
}

extension Dictionary: FromJson where Key == String, Value: FromJson {
  public static func from(value: JsonValue) -> Dictionary<Key, Value>? {
    return value.ifObject { json in
      json
        .mapValues { decodeValue($0)! }
    }
  }
}

public typealias JSON = [String: Any]
