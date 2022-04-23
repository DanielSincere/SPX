import XCTest
@testable import Swish

final class AddCommandTests: XCTestCase {

  func testThrowWhenMissingScriptName() {
    XCTAssertThrowsError(try AddCommand(announcer: .init(), swishDir: "/tmp").exec(arguments: []))
  }
}
