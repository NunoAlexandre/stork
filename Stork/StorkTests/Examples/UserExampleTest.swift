import XCTest

class UserExampleTest: XCTestCase {

}


/// Model

struct User {
  let id: Int
  let name: String
  let email: String?
  let subscription: Subscription
  let favouriteSongs: [Song]
}

enum Subscription: String {
  case free
  case bronze
  case silver
  case gold
}

struct Song {
  let name: String
  let band: String
}




/// Comply to the 'FromJson' protocol

extension User: FromJson {
  static func from(value: JsonValue) -> User? {
    return value.ifObject { json in
      User(
        id:             try json .! "id",
        name:           try json .! "name",
        email:          json .? "email",
        subscription:   try json .! "subscription",
        favouriteSongs: (json ..? "favouriteSongs") ?? []
      )
    }
  }
}

extension Subscription: FromJson {
  static func from(value: JsonValue) -> Subscription? {
    return value
      .stringValue()
      .flatMap(Subscription.init(rawValue:))
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
