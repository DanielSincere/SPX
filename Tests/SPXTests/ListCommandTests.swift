import XCTest
@testable import SPXLib

final class ListCommandTests: XCTestCase {

  func testSingleTargetFixture() throws {

    let dir = Fixtures.singleTargetFixture.dir
    let runner = Runner()
    let targets = try ListCommand(announcer: nil, runner: runner, spxDir: dir)
      .exec()

    XCTAssertEqual(targets.count, 1)
    XCTAssertEqual(targets.first?.name, "example")
    XCTAssertEqual(targets.first?.type, "executable")
  }
}
