import XCTest
@testable import SwishLib

final class ListCommandTests: XCTestCase {

  func testList() throws {

    class FakeAnnouncer: Announcing {
      var receivedPackage: SwiftPackageDump?
      func listTargets(of package: SwiftPackageDump) {
        self.receivedPackage = package
      }
    }
    let fake = FakeAnnouncer()
    let dir = Bundle.module.resourcePath! + "/Fixtures/a"
    try ListCommand(announcer: fake, swishDir: dir).exec()

    XCTAssertNotNil(fake.receivedPackage)
    XCTAssertNotNil(fake.receivedPackage?.executableTarget(named: "a"))
  }
}
