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

  func doubleValue() -> Double? {
    return self.ifDouble(id)
  }

  func stringValue() -> String? {
    return self.ifString(id)
  }

  func ifBool<T>(_ apply: (Bool) -> T?) -> T? {
    switch self {
    case .boolean(let bool):
      return apply(bool)
    default:
      return nil
    }
  }

  func ifInt<T>(_ apply: (Int) -> T?) -> T? {
    switch self {
    case .int(let int):
      return apply(int)
    default:
      return nil
    }
  }

  func ifDouble<T>(_ apply: (Double) -> T?) -> T? {
    switch self {
    case .double(let double):
      return apply(double)
    default:
      return nil
    }
  }

  func ifObject<T>(_ apply: (JSON) throws -> T?) -> T? {
    switch self {
    case .object(let json):
      do { return try apply(json) }
      catch { return nil }
    default:
      return nil
    }
  }

  func ifString<T>(_ apply: (String) -> T?) -> T? {
    switch self {
    case .string(let str):
      return apply(str)
    default:
      return nil
    }
  }
}

func id<T>(_ value: T) -> T {
  return value
}

extension Optional {
  func orThrow(_ throwError: () -> Error) throws -> Wrapped {
    guard let value = self else {
      throw throwError()
    }

    return value
  }
}
