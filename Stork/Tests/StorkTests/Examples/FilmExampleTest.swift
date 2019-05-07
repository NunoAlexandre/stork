import XCTest

@testable import Stork

class FilmExampleTest: XCTestCase {

  func testFilmFromJson() {
    let film: JSON =
      [ "title": "The Godfather"
      , "genres": ["crime", "drama"]
      , "yearOfRelease": 1972
      , "actors": ["Al Pacino", "Marlon Brando"]
      , "languages": ["en", "it", "lat"]
      , "imdbRating": 9.2
      , "streamURL": "https://github.com/NunoAlexandre/stork"
      ]

    if let parsedFilm = Film.from(json: film) {
      XCTAssertEqual(
        parsedFilm,
        Film(
          title: "The Godfather",
          genres: [.crime, .drama],
          yearOfRelease: 1972,
          actors: [Actor(name: "Al Pacino"), Actor(name: "Marlon Brando")],
          languages: [.english, .italian, .latin],
          isKidsProof: false,
          imdbRating: 9.2,
          streamURL: URL(string: "https://github.com/NunoAlexandre/stork")!
        )
      )
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

  func testFilmFromJsonWithTypeMismatchOnTitle() {
    /// Confirm that when a JSON with a type mismatch
    /// is given, nil is obtained on decoding that value.
    let malformedFilm: JSON =
      [ "title": 1928 // expected to be a String
      , "genres": ["crime", "drama"]
      , "yearOfRelease": 1972
      , "actors": ["Al Pacino", "Marlon Brando"]
      , "languages": ["en", "it", "lat"]
      , "imdbRating": 9.2
      , "streamURL": "https://github.com/NunoAlexandre/stork"
      ]

    let maybeFilm = Film.from(json: malformedFilm)
    XCTAssertNil(maybeFilm)
  }

  func testFilmFromJsonWithTypeMismatchOnArray() {
    /// Confirm that when a JSON with a type mismatch
    /// on an array, nil is obtained on decoding that value.
    let malformedFilm: JSON =
      [ "title": "The Godfather"
      , "genres": 123 // expected to be [String]
      , "yearOfRelease": 1972
      , "actors": ["Al Pacino", "Marlon Brando"]
      , "languages": ["en", "it", "lat"]
      , "imdbRating": 9.2
      , "streamURL": "https://github.com/NunoAlexandre/stork"
      ]

    let maybeFilm = Film.from(json: malformedFilm)
    XCTAssertNil(maybeFilm)
  }

  func testFilmFromJsonWithTypeMismatchOnArrayElements() {
    /// Confirm that when a JSON with a type mismatch
    /// on the array elements type, an empty array is
    // obtained instead. This is not ideal but for now
    // it works this way and must be tested.
    let malformedFilm: JSON =
      [ "title": "The Godfather"
      , "genres": [1,2,3] // expected to be [String]
      , "yearOfRelease": 1972
      , "actors": ["Al Pacino", "Marlon Brando"]
      , "languages": ["en", "it", "lat"]
      , "imdbRating": 9.2
      , "streamURL": "https://github.com/NunoAlexandre/stork"
      ]

    if let parsedFilm = Film.from(json: malformedFilm) {
      XCTAssertEqual(
        parsedFilm,
        Film(
          title: "The Godfather",
          genres: [],
          yearOfRelease: 1972,
          actors: [Actor(name: "Al Pacino"), Actor(name: "Marlon Brando")],
          languages: [.english, .italian, .latin],
          isKidsProof: false,
          imdbRating: 9.2,
          streamURL: URL(string: "https://github.com/NunoAlexandre/stork")!
        )
      )
    }
    else {
      XCTFail("The JSON object failed to be decoded to 'Film'")
    }

  }
  static var allTests = [
    ("testFilmFromJson", testFilmFromJson),
    ("testFilmFromJsonWithMissingField", testFilmFromJsonWithMissingField),
    ("testFilmFromJsonWithTypeMismatchOnTitle", testFilmFromJsonWithTypeMismatchOnTitle),
    ("testFilmFromJsonWithTypeMismatchOnArray", testFilmFromJsonWithTypeMismatchOnArray),
    ("testFilmFromJsonWithTypeMismatchOnArrayElements", testFilmFromJsonWithTypeMismatchOnArrayElements)
  ]
}


/// Model
struct Film: Equatable {
  let title: String
  let genres: [Genre]
  let yearOfRelease: Int
  let actors: [Actor]
  let languages: [Language]
  let isKidsProof: Bool
  let imdbRating: Double?
  let streamURL: URL
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
        imdbRating:    json .? "imdbRating",
        streamURL:     try json .! "streamURL"
      )
    }
  }
}

extension Genre: FromJson {}

extension Actor: FromJson {
  static func from(value: JsonValue) -> Actor? {
    return value.ifString(Actor.init(name:))
  }
}

extension Language: FromJson {
  static func from(value: JsonValue) -> Language? {
    return value.ifString { str in
      switch str {
      case "en":  return .english
      case "it":  return .italian
      case "lat": return .latin
      case "pt":  return .portuguese
      case "nl":  return .dutch
      default:    return nil
      }
    }
  }
}
