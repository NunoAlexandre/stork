import XCTest

@testable import Stork

/* TODO:(nuno) implement replacement for "Bundle" to import types.json
*  Bundle(for: ) is not implemented on the Swift open source project 7/5/2019
*/

extension XCTestCase {
  func getJSON(fromFile file: String) -> Any {
    let inventoryFileURL = Bundle(for: type(of: self)).url(
      forResource: file,
      withExtension: "json"
    )
    let jsonData = try! Data(contentsOf: inventoryFileURL!)
    return try! JSONSerialization.jsonObject(with: jsonData)
  }
}
