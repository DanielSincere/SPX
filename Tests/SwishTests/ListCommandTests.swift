import XCTest
@testable import SwishLib

final class ListCommandTests: XCTestCase {

  func testSingleTargetFixture() throws {

    let dir = Bundle.module.resourcePath! + "/Fixtures/single-target-fixture"
    let targets = try ListCommand(announcer: nil, swishDir: dir)
      .exec()

    XCTAssertEqual(targets.count, 1)
    XCTAssertEqual(targets.first?.name, "example")
    XCTAssertEqual(targets.first?.type, "executable")
  }
}
