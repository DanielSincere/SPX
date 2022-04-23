import Foundation

extension AddCommand.Errors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .scriptNameMissing:
      return "Specify name of script to add as the first argument."
    }
  }
}
