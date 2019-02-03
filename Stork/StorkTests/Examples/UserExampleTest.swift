import XCTest

class UserExampleTest: XCTestCase {

  func testUserFromJson() {
    let user: JSON =
      [ "id": 123
      , "name": "Nuno"
      , "subscription": "free"
      , "favouriteSongs":
        [
          [ "name": "Freedom Is A Voice"
          , "band": "Bobby Mcferrin"
          ]
        , [ "name": "On Tour"
          , "band": "Kurt Vile"
          ]
        , [ "name": "Joana Transmontana"
          , "band": "B Fachada"
          ]
        ]
      ]

    if let user = User.from(json: user) {
      XCTAssertEqual(user.id, 123)
      XCTAssertEqual(user.name, "Nuno")
      XCTAssertEqual(user.email, nil)
      XCTAssertEqual(user.subscription, Subscription.free)
      XCTAssertEqual(
        user.favouriteSongs,
        [ Song(name: "Freedom Is A Voice", band: "Bobby Mcferrin")
        , Song(name: "On Tour", band: "Kurt Vile")
        , Song(name: "Joana Transmontana", band: "B Fachada")
        ]
      )
    }
    else {
      XCTFail("The JSON object failed to be decoded to 'User'")
    }
  }
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

struct Song: Equatable {
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
