import XCTest
@testable import SwishLib

final class AddCommandTests: XCTestCase {

  func testThrowWhenMissingScriptName() {
    XCTAssertThrowsError(try AddCommand(announcer: .init(), swishDir: "/tmp").exec(arguments: []))
  }
}
