import XCTest

/*
 When parsing real json, this data has potentially
 been coerced to 'Data' and then / or as a JSON,
 i.e., [String: Any], which causes Boolean's and
 Int's to get confused through the NSNumber type.
 See the following stackOverflow thread to learn
 more about this problem: http://tinyurl.com/y2u9zmxw.

 This test suite therefore focuses on verifying
 Stork's decoding of scalar JsonValue's from real
 json, as well as specifying its behaviour when
 coercions could be expected or needed.
*/
class FromJsonItegrationTests: XCTestCase {

  func inputJson() -> JSON {
    return getJSON(fromFile: "types") as! JSON
  }

  // Check whether parsing 'Types' from types.json
  // produces the exact expected Types instance.
  func testFromJsonTypesParsing() {
    XCTAssertEqual(
      Types.from(json: inputJson()),
      Types(
          text: "Delivering types from JSON like a Stork"
        , char: "a"
        , boolTrue: true
        , boolFalse: false
        , zero: 0
        , one: 1
        , two: 2
        , int: 1299
        , zeroDouble: 0.0
        , oneDouble: 1.0
        , double: 62.8
      )
    )
  }

  func testExpectingBoolFromNumber() {
    let json = inputJson()

    ["zero", "one", "int", "zeroDouble", "oneDouble", "double"]
      .forEach { numberField in
        XCTAssertEqual(
          json .? numberField,
          Optional<Bool>.none
        )
      }
  }

  func testExpectingIntFromBool() {
    let json = inputJson()

    ["false", "true"].forEach { booleanField in
      XCTAssertEqual(
        json .? booleanField,
        Optional<Int>.none
      )
    }
  }

  func testExpectingDoubleFromBool() {
    let json = inputJson()

    ["false", "true"].forEach { booleanField in
      XCTAssertEqual(
        json .? booleanField,
        Optional<Double>.none
      )
    }
  }

  func testExpectingDoubleFromInt() {
    let json = inputJson()

    XCTAssertEqual(json .? "zero", 0.0)
    XCTAssertEqual(json .? "one", 1.0)
    XCTAssertEqual(json .? "two", 2.0)
    XCTAssertEqual(json .? "int", 1299.0)
  }

  func testExpectingIntFromDouble() {
    let json = inputJson()

    XCTAssertEqual(json .? "zeroDouble", 0)
    XCTAssertEqual(json .? "oneDouble", 1)
    XCTAssertEqual(json .? "double", 62)
  }
}

struct Types: Equatable {
  let text: String
  let char: String

  let boolTrue: Bool
  let boolFalse: Bool

  let zero: Int
  let one: Int
  let two: Int
  let int: Int

  let zeroDouble: Double
  let oneDouble: Double
  let double: Double
}

extension Types: FromJson {
  static func from(value: JsonValue) -> Types? {
    return value.ifObject { json in
      Types(
        text: try json .! "text"
      , char: try json .! "char"
      , boolTrue: try json .! "true"
      , boolFalse: try json .! "false"
      , zero: try json .! "zero"
      , one: try json .! "one"
      , two: try json .! "two"
      , int: try json .! "int"
      , zeroDouble: try json .! "zeroDouble"
      , oneDouble: try json .! "oneDouble"
      , double: try json .! "double"
      )
    }
  }
}
