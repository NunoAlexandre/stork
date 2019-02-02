import XCTest

class FilmExampleTest: XCTestCase {

  func testFilmFromJson() {
    let film: JSON =
      [ "title": "The Godfather"
      , "genres": ["crime", "drama"]
      , "yearOfRelease": 1972
      , "actors": ["Al Pacino", "Marlon Brando"]
      , "languages": ["english", "italian", "latin"]
      ]

    if let film = Film.from(json: film) {
      XCTAssertEqual(film.title, "The Godfather")
      XCTAssertEqual(film.genres, [Genre.crime, Genre.drama])
      XCTAssertEqual(film.yearOfRelease, 1972)
      XCTAssertEqual(film.actors, [Actor(name: "Al Pacino"),
                                   Actor(name: "Marlon Brando")])
      XCTAssertEqual(film.isKidsProof, false)
    }
    else {
      XCTFail("The JSON object failed to be decoded to 'Film'")
    }

  }
}


/// Model
struct Film {
  let title: String
  let genres: [Genre]
  let yearOfRelease: Int
  let actors: [Actor]
  let languages: [Language]
  let isKidsProof: Bool
}

enum Genre: String {
  case comedy
  case crime
  case drama
  case horror
}

struct Actor: Equatable {
  let name: String
}

enum Language: String {
  case english
  case italian
  case latin
  case portuguese
  case dutch
}

/// Comply to the 'FromJson' protocol
extension Film: FromJson {
  static func from(value: JsonValue) -> Film? {
    return value.ifObject { json in
      return Film(
        title:         json .! "title",
        genres:        json ..! "genres",
        yearOfRelease: json .! "yearOfRelease",
        actors:        (json ..! "actors"),
        languages:     json ..! "languages",
        isKidsProof:   (json .? "isKidsProof") ?? false
      )
    }
  }
}

extension Genre: FromJson {
  static func from(value: JsonValue) -> Genre? {
    return value
      .stringValue()
      .flatMap(Genre.init(rawValue:))
  }
}

extension Actor: FromJson {
  static func from(value: JsonValue) -> Actor? {
    return value.ifString(Actor.init(name:))
  }
}

extension Language: FromJson {
  static func from(value: JsonValue) -> Language? {
    return value
      .stringValue()
      .flatMap(Language.init(rawValue:))
  }
}
