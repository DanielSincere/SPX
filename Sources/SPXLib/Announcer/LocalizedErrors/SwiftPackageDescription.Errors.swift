import Foundation

extension SwiftPackageDescription.Errors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .couldNotFindPackageDotSwift(path: let path):
      return "Could not find `Package.swift` at `\(path)`"
    }
  }
}
