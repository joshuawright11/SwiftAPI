import XCTest

import SwiftAPITests

var tests = [XCTestCaseEntry]()
tests += DecodingTests.allTests()
tests += EncodingTests.allTests()
XCTMain(tests)
