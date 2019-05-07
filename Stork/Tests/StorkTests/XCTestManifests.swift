import XCTest

@testable import Stork

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    /* TODO:(nuno) implement replacement for "Bundle" to import types.json
    *  Then implement FromJsonItegrationTests with: testCase(FromJsonItegrationTests.allTests),
    */
    return [
        testCase(FilmExampleTest.allTests),
        testCase(UserExampleTest.allTests),
    ]
}
#endif
