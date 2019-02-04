# Stork
Stork is a lightweight library focused on making the flight from JSON to Types as smooth as possible. Stork believes in simplicity, explicitness, and control.

Based on functional programming principles and mildly inspired in [Aeson](http://hackage.haskell.org/package/aeson), Stork is the middle sweet between JSON parsers such as Argo - full-fledged but requiring extra dependencies and too functional for some - and other parsers that require your types to be mutable, to throw on `init`, or that take the control away from you.

## How it works

To go from JSON to types, all you need to do is to state what fields you want to parse. Stork infers their type and parses them for you. To make that possible, your types _must_ follow the `FromJson` protocol.

``` swift
protocol FromJson {
  static func from(value: JsonValue) -> Self?
}
```

In practice, this means that for a type to be parseable from JSON, it needs to provide a way of being constructed from a `JsonValue`, i.e., from either:

- `String`
- `Int`
- `Double`
- `Bool`
- `JSON`  (i.e., `[String: Any]`)
- `[JsonValue]`.

At compile-time, Storks requires the types you want to get from JSON to be `FromJson` compliant. Otherwise, you encounter the following compile error message on Xcode:

```
Generic parameter 'T' could not be infered
```

## Examples

Say that we want to retrieve values of type `User` from some JSON input, where `User` and its nested types are defined as follows:

``` swift
struct User {
  let id: Int
  let name: String
  let email: String?
  let country: Country?
  let subscription: Subscription
  let favouriteSongs: [Song]
}

enum Subscription: String {
  case free
  case bronze
  case silver
  case gold
}

enum Country: String {
  case netherlands
  case portugal
}

struct Song: Equatable {
  let name: String
  let band: String
}
```

With Stork, to go from JSON to this model all we need to do is to have these types complying to our `FromJson` protocol.

``` swift
extension User: FromJson {
  static func from(value: JsonValue) -> User? {
    return value.ifObject { json in
      User(
        id:             try json .! "id",
        name:           try json .! "name",
        email:          json .? "email",
        country:        json .? "country",
        subscription:   try json .! "subscription",
        favouriteSongs: (json ..? "favouriteSongs") ?? []
      )
    }
  }
}

// That's all you need for String/Int RawRepresentable Enums!
extension Subscription: FromJson {}

// Or you get to say how it's done!
// In this case, the country in JSON is short-coded and
// thus needs to be translated to the right Country case.
extension Country: FromJson {
  static func from(value: JsonValue) -> Country? {
    return value.stringValue().flatMap { str in
      switch str {
      case "nl": return .netherlands
      case "pt": return .portugal
      default:   return nil
      }
    }
  }
}

extension Song: FromJson {
  static func from(value: JsonValue) -> Song? {
    return value.ifObject { json in
      Song(
        name: try json .! "name",
        band: try json .! "band"
      )
    }
  }
}
```

Now that we have everything, let's get Stork to deliver that baby:

``` swift
// Single user
let maybeUser: User? = User.from(json: userJSON)

// List of users
let users: [User] = [User].from(jsonList: usersJSON)
```

See more, unit-tested examples at the [Examples directory](/Stork/StorkTests/Examples)

## Installation

- `TODO`: I [plan to support](https://github.com/NunoAlexandre/stork/issues/6) `CocoaPods`, `Carthage`, and the `Swift Package Manager`.

Help is rather appreciated!
