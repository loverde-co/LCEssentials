import XCTest
@testable import Repositorio

final class RepositorioTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Repositorio().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
