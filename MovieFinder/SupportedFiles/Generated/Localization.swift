// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum LocalizationKeys {
  /// You do not have an internet connection right now! Please try again.
  internal static var connectionError: String { return LocalizationKeys.tr("Localizable", "connection_error") }
  /// Error
  internal static var error: String { return LocalizationKeys.tr("Localizable", "error") }
  /// Movie Finder
  internal static var movieFinder: String { return LocalizationKeys.tr("Localizable", "movie_finder") }
  /// Successful
  internal static var successful: String { return LocalizationKeys.tr("Localizable", "successful") }
  /// Warning
  internal static var warning: String { return LocalizationKeys.tr("Localizable", "Warning") }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension LocalizationKeys {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = translate(key, table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
