import Foundation

extension InitCommand.Errors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .templateNameMissing:
      return "Specify name of template to scaffold as the first argument. \(currentTemplatesMessage)"
    case .noTemplate(named: let name):
      return "No template found with name \(name). \(currentTemplatesMessage)"
    }
  }

  var currentTemplatesMessage: String {
    "Current templates are "
    + Templates.allCases
      .map { $0.rawValue.cyan }
      .joined(separator: ", ")
    + "."
  }
}
