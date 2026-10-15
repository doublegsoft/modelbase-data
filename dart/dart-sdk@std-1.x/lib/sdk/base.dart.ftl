<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>

///
/// Represents a selectable key-value option, commonly used in dropdowns,
/// select widgets, radio groups, and cascade selectors.
///
class Option {
  /// The user-facing display text or label shown in the UI.
  final String text;

  /// The underlying value or identifier associated with this option.
  final String value;

  /// Creates an immutable [Option] instance with the specified [text] and [value].
  const Option({
    required this.text,
    required this.value,
  });
}

///
/// Exception thrown when a remote API or SDK network operation fails.
///
class SdkException implements Exception {
  /// A human-readable description of what went wrong.
  final String message;

  /// The HTTP status code returned by the server (e.g., 400, 404, 500),
  /// or `null` if the error occurred before receiving a response.
  final int? statusCode;

  /// The raw response payload or error body returned by the server,
  /// useful for debugging or parsing business error details.
  final dynamic body;

  /// Creates a new [SdkException] with an error [message], and optional
  /// [statusCode] and raw response [body].
  SdkException(
    this.message, {
    this.statusCode,
    this.body,
  });

  @override
  String toString() => 'SdkException: $message (status: $statusCode)';
}