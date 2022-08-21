import XCTest
@testable import SwishLib

final class ExecCommandTests: XCTestCase {

  func testSingleTargetFixture() throws {

    let dir = Fixtures.singleTargetFixture.dir

    let fakeRunner = FakeRunner()
    try ExecCommand(announcer: nil, runner: fakeRunner, swishDir: dir).exec(targetName: "example", targetArguments: [])

    XCTAssertEqual(fakeRunner.receivedCommands.count, 1)
    XCTAssertEqual(fakeRunner.receivedCommands.first, "xcrun --sdk macosx swift run --package-path \(dir) example")
  }

  func testSingleTargetFixtureWithArguments() throws {

    let dir = Fixtures.singleTargetFixture.dir

    let fakeRunner = FakeRunner()
    try ExecCommand(announcer: nil, runner: fakeRunner, swishDir: dir).exec(targetName: "example", targetArguments: ["a", "b", "c"])

    XCTAssertEqual(fakeRunner.receivedCommands.count, 1)
    XCTAssertEqual(fakeRunner.receivedCommands.first, "xcrun --sdk macosx swift run --package-path \(dir) example a b c")
  }
}
