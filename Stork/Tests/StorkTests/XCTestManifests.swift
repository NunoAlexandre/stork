import XCTest

@testable import Stork

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StorkTests.allTests),
    ]
}
#endif
