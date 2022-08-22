import XCTest
@testable import SwishLib

final class ListCommandTests: XCTestCase {

  func testSingleTargetFixture() throws {

    let dir = Fixtures.singleTargetFixture.dir
    let runner = Runner()
    let targets = try ListCommand(announcer: nil, runner: runner, swishDir: dir)
      .exec()

    XCTAssertEqual(targets.count, 1)
    XCTAssertEqual(targets.first?.name, "example")
    XCTAssertEqual(targets.first?.type, "executable")
  }
}
