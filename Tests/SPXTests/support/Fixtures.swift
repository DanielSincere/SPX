import Foundation

enum Fixtures: String {
  case singleTargetFixture = "single-target-fixture"

  var dir: String {
    Bundle.module.resourcePath! + "/Fixtures/" + rawValue
  }
}
