import XCTest

@testable import Stork

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FilmExampleTest.allTests),
    ]
}
#endif
