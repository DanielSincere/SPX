import XCTest
@testable import SPXLib

final class AddCommandTests: XCTestCase {

  func testThrowWhenMissingScriptName() {
    XCTAssertThrowsError(try AddCommand(announcer: .init(), spxDir: "/tmp").exec(arguments: []))
  }
}
