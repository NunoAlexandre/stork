import Foundation

/*
 Stork > JsonValue

 A 'JsonValue' is a type-safe capture of what any value in
 a JSON object can be, following to the JSON specification.

*/
enum JsonValue {
  case boolean(Bool)
  case int(Int)
  case number(NSNumber)
  case string(String)
  case object(JSON)
  case array([JsonValue])

  init?(fromAny anyValue: Any) {
    switch anyValue {
    case let value as NSNumber:
      self = value.isBool()
        ? .boolean(value.boolValue)
        : .number(value)
    case let value as String:
      self = .string(value)
    case let value as JSON:
      self = .object(value)
    default:
      return nil
    }
  }

  func boolValue() -> Bool? {
    return self.ifBool(id)
  }

  func numberValue() -> NSNumber? {
    return self.ifNumber(id)
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

  func ifNumber<T>(_ apply: (NSNumber) -> T?) -> T? {
    switch self {
    case let .number(x):
      return apply(x)
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
