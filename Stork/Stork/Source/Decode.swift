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

func .?<T>(json: JSON, key: String) -> T? where T: FromJson {
  return json[key].flatMap(decodeValue)
}

func .!<T>(json: JSON, key: String) -> T where T: FromJson {
  return (json .? key)!
}

func ..?<T>(json: JSON, key: String) -> [T]? where T: FromJson {
  return json[key]
    .map { value in
      (value as? Array<Any>)?.compactMap(decodeValue) ?? []
    }
}

func ..!<T>(json: JSON, key: String) -> [T] where T: FromJson {
  return (json ..? key)!
}

func decodeValue<T>(_ value: Any) -> T? where T: FromJson {
  switch value {
  case is Bool:
    return T.from(value: .boolean(value as! Bool))
  case is Int:
    return T.from(value: .int(value as! Int))
  case is String:
    return T.from(value: .string(value as! String))
  case is JSON:
    return T.from(value: .object(value as! JSON))
  default:
    return nil
  }
}