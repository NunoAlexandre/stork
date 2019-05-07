import XCTest

@testable import Stork

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
