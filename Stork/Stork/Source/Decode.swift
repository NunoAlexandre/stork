/*
  Stork > Decode

  This module offers tools to:
    - decode a value of type T from 'Any'            [Top-Level]
    - decode values of type T from a JSON object     [Nested]

  Such type 'T' is required, at compile time, to comply
  to the 'FromJson' protocol.
*/

infix operator .?   // Maybe get a scalar or custom type
infix operator .!   // Same as .? but expects the value to be present
infix operator ..?  // Maybe get an array of scalar or custom types
infix operator ..!  // Same as ..? but expects the array to be present

public func .?<T>(json: JSON, key: String) -> T? where T: FromJson {
  return json[key].flatMap(decodeValue)
}

public func .!<T>(json: JSON, key: String) throws -> T where T: FromJson {
  return try (json .? key).orThrow {
    StorkDecodeError.couldNotDecode(field: key)
  }
}

public func ..?<T>(json: JSON, key: String) -> [T]? where T: FromJson {
  return json[key]
    .flatMap{ $0 as? Array<Any> }
    .map { $0.compactMap(decodeValue) }
}

public func ..!<T>(json: JSON, key: String) throws -> [T] where T: FromJson {
  return try
    (json ..? key)
    .orThrow { StorkDecodeError.couldNotDecode(field: key) }
}

func decodeValue<T>(_ value: Any) -> T? where T: FromJson {
  return JsonValue(fromAny: value)
    .flatMap(T.from(value:))
}

public enum StorkDecodeError: Error {
  case couldNotDecode(field: String)
}
