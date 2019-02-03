import XCTest

class FilmExampleTest: XCTestCase {

  func testFilmFromJson() {
    let film: JSON =
      [ "title": "The Godfather"
      , "genres": ["crime", "drama"]
      , "yearOfRelease": 1972
      , "actors": ["Al Pacino", "Marlon Brando"]
      , "languages": ["english", "italian", "latin"]
      , "imdbRating": 9.2
      ]

    if let film = Film.from(json: film) {
      XCTAssertEqual(film.title, "The Godfather")
      XCTAssertEqual(film.genres, [Genre.crime, Genre.drama])
      XCTAssertEqual(film.yearOfRelease, 1972)
      XCTAssertEqual(film.actors, [Actor(name: "Al Pacino"),
                                   Actor(name: "Marlon Brando")])
      XCTAssertEqual(film.isKidsProof, false)
      XCTAssertEqual(film.imdbRating, 9.2)

    }
    else {
      XCTFail("The JSON object failed to be decoded to 'Film'")
    }
  }

  func testFilmFromJsonWithMissingField() {
    /// Confirm that when a JSON with a missing required
    /// fields is given, nil is obtained on decoding that value.
    let malformedFilm: JSON = [:]

    let maybeFilm = Film.from(json: malformedFilm)
    XCTAssertNil(maybeFilm)
  }

  func testFilmFromJsonWithTypeMismatch() {
    /// Confirm that when a JSON with a type mismatch
    /// is given, nil is obtained on decoding that value.
    let malformedFilm: JSON =
      [ "title": "The Godfather"
      , "genres": 123             // expected to be a [String]
      , "yearOfRelease": "Hello"  // expected to be Int
      , "actorz": [1,2,3]         // expected to be [String]
      , "languages": false        // expected to be [String]
      ]

    let maybeFilm = Film.from(json: malformedFilm)
    XCTAssertNil(maybeFilm)
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
  let imdbRating: Double?
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
        title:         try json .! "title",
        genres:        try json ..! "genres",
        yearOfRelease: try json .! "yearOfRelease",
        actors:        try json ..! "actors",
        languages:     try json ..! "languages",
        isKidsProof:   (json .? "isKidsProof") ?? false,
        imdbRating:    json .? "imdbRating"
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
