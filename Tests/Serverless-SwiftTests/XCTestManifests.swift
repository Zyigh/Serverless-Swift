import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Serverless_SwiftTests.allTests),
    ]
}
#endif
