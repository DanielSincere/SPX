import Foundation

extension BuildCommand.Errors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .build(error: let error):
      return "Error while building scripts package: \(error.localizedDescription)"
    }
  }
}
