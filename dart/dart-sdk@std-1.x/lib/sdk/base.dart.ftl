<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import '/model/dto.dart';

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
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

typedef Save${dart.nameType(modelbase.get_object_plural(obj))}Fn = Future<List<${dart.nameType(obj.name)}Query>> Function({
  required List<${dart.nameType(obj.name)}Query> queries,
});

typedef Save${dart.nameType(obj.name)}Fn = Future<${dart.nameType(obj.name)}Query> Function({
  required ${dart.nameType(obj.name)}Query query,
});

typedef Read${dart.nameType(obj.name)}Fn = Future<${dart.nameType(obj.name)}Query?> Function({
  <#list idAttrs as idAttr>
  required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
});

typedef Find${dart.nameType(modelbase.get_object_plural(obj))}Fn = Future<Pagination<${dart.nameType(obj.name)}Query>> Function({
  ${dart.nameType(obj.name)}Query? query,
});

typedef Delete${dart.nameType(obj.name)}Fn = Future<bool> Function({
  <#list idAttrs as idAttr>
  required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
});
</#list>