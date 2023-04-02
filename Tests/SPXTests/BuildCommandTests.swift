import XCTest
@testable import SPXLib

final class BuildCommandTests: XCTestCase {

  func testSingleTargetFixture() throws {
    let dir = Fixtures.singleTargetFixture.dir

    let fakeRunner = FakeRunner()

    try BuildCommand(announcer: nil, runner: fakeRunner, spxDir: dir)
      .exec()

    XCTAssertEqual(fakeRunner.receivedCommands.count, 1)
    XCTAssertEqual(fakeRunner.receivedCommands.first, "swift build --package-path \(dir)")
  }
}
