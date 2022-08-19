import Foundation

extension ExecCommand.Errors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .targetNotFound(named: let targetName, _):
      return "Target not found with name: \(targetName)."
    case .errorRunning(target: let targetName, error: let error):
      return "Error while running target \(targetName): \(error.localizedDescription)"
    }
  }

  var recoverySuggestion: String? {
    switch self {
    case .errorRunning: return nil
    case .targetNotFound(named: _, availableTargets: let availableTargets):
      return "Available targets:\n\t\(availableTargets.joined(separator: "\n\t"))"
    }
  }
}
