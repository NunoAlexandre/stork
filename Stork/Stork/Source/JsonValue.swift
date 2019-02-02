/*
 Stork > JsonValue

 A 'JsonValue' is a type-safe capture of what any value in
 a JSON object can be, following to the JSON specification.

*/
enum JsonValue {
  case boolean(Bool)
  case int(Int)
  case double(Double)
  case string(String)
  case object(JSON)
  case list([JsonValue])

  func boolValue() -> Bool? {
    return self.ifBool(id)
  }

  func intValue() -> Int? {
    return self.ifInt(id)
  }

  func stringValue() -> String? {
    return self.ifString(id)
  }

  func ifBool<T>(_ apply: (Bool) throws -> T) -> T? {
    switch self {
    case .boolean(let bool):
      return try? apply(bool)
    default:
      return nil
    }
  }

  func ifInt<T>(_ apply: (Int) throws -> T) -> T? {
    switch self {
    case .int(let int):
      return try? apply(int)
    default:
      return nil
    }
  }

  func ifObject<T>(_ apply: (JSON) throws -> T) -> T? {
    switch self {
    case .object(let json):
      return try? apply(json)
    default:
      return nil
    }
  }

  func ifString<T>(_ apply: (String) throws -> T) -> T? {
    switch self {
    case .string(let str):
      return try? apply(str)
    default:
      return nil
    }
  }
}

func id<T>(_ value: T) -> T {
  return value
}
