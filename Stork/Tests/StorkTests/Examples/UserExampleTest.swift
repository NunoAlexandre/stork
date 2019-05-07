import XCTest

@testable import Stork

class UserExampleTest: XCTestCase {

  func testUserFromJson() {
    let user: JSON =
      [ "id": 123
      , "name": "Nuno"
      , "country": "nl"
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
      XCTAssertEqual(user.country, Country.netherlands)
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
  static var allTests = [
    ("testUserFromJson", testUserFromJson)
  ]
}


/// Model

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


/// Comply to the 'FromJson' protocol

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
    return value.ifString { str in
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
