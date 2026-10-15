<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '/model/dto.dart';
import 'base.dart';

///
/// A client responsible for handling remote HTTP network requests,
/// endpoint URI construction, and request execution.
///
class Remote {

  /// The base URL prepended to all relative endpoint paths
  /// (e.g., `'https://api.example.com'`).
  final String baseUrl;

  /// The underlying HTTP client used to dispatch network requests.
  final http.Client _client;

  /// Default HTTP headers included with every outgoing request
  /// (defaults to `{'Content-Type': 'application/json'}`).
  final Map<String, String> defaultHeaders;

  /// Creates a new [Remote] instance.
  ///
  /// - [baseUrl]: The root URL for API calls. Defaults to an empty string.
  /// - [client]: An optional custom [http.Client] (useful for testing or mocking).
  /// - [headers]: Custom default headers to override or supplement [defaultHeaders].
  Remote({
    this.baseUrl = '',
    http.Client? client,
    Map<String, String>? headers,
  })  : _client = client ?? http.Client(),
        defaultHeaders = headers ?? {'Content-Type': 'application/json'};

  /// Constructs a full [Uri] by joining [baseUrl] and the endpoint [path],
  /// appending any provided [queryParameters].
  ///
  /// - Automatically handles leading and trailing slashes to avoid double slashes.
  /// - Strips out any `null` values from [queryParameters].
  /// - Returns the parsed and normalized [Uri].
  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    // Strip trailing slash from baseUrl if present
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    // Ensure leading slash on path
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final baseUri = Uri.parse('$cleanBase$cleanPath');

    if (queryParameters == null || queryParameters.isEmpty) {
      return baseUri;
    }

    // Convert non-null values to strings for query parameters
    final query = <String, String>{};
    queryParameters.forEach((key, value) {
      if (value != null) {
        query[key] = value.toString();
      }
    });

    return baseUri.replace(queryParameters: query);
  }

  /// Close the client connection
  void close() {
    _client.close();
  }
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

  Future<void> save${dart.nameType(modelbase.get_object_plural(obj))}({
    required List<${dart.nameType(obj.name)}Query> queries,
  }) async {
    List<Map<String,dynamic>> payload = [];
    for (final query in queries) {
      payload.add(query.to());
    }
    final uri = _buildUri('/api/${modelbase.get_object_module(obj)}/${modelbase.get_object_plural(obj)}/batch');
    final response = await _client.post(
      uri,
      headers: defaultHeaders,
      body: jsonEncode(payload),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw SdkException(
        'Failed to save ${modelbase.get_object_plural(obj)}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  ///
  /// 保存【${modelbase.get_object_label(obj)}】数据。
  ///
  Future<${dart.nameType(obj.name)}Query> save${dart.nameType(obj.name)}({
    required ${dart.nameType(obj.name)}Query query,
  }) async {
    Map<String,dynamic> payload = query.to();
    final uri = _buildUri('/api/${modelbase.get_object_module(obj)}/${modelbase.get_object_module(obj)}/${obj.name}/save');
    final response = await _client.post(
      uri,
      headers: defaultHeaders,
      body: jsonEncode(payload),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic decoded = jsonDecode(response.body);

      // Handles both direct object response and envelope responses ({ "data": { ... } })
      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'] is Map<String, dynamic>
            ? decoded['data'] as Map<String, dynamic>
            : decoded;
        return ${dart.nameType(obj.name)}Query.from(data);
      }

      throw SdkException(
        'Unexpected response format when saving ${obj.name}',
        statusCode: response.statusCode,
        body: response.body,
      );
    } else {
      throw SdkException(
        'Failed to save ${obj.name}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  ///
  /// 读取【${modelbase.get_object_label(obj)}】数据。
  ///
  Future<${dart.nameType(obj.name)}Query?> read${dart.nameType(obj.name)}({
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == "datetime"><#continue></#if>
    required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
    </#list>
  }) async {
    final Map<String, dynamic> payload = {};
    bool hasIdValue = false;
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == "datetime"><#continue></#if>
    if (${modelbase.get_attribute_sql_name(idAttr)}.toString().isNotEmpty) {
      hasIdValue = true;
      payload['${modelbase.get_attribute_sql_name(idAttr)}'] = ${modelbase.get_attribute_sql_name(idAttr)};
    }
    </#list>

    if (!hasIdValue) {
      throw SdkException('There is no given id value to read ${dart.nameType(obj.name)} object.');
    }

    final uri = _buildUri('/v1/${modelbase.get_object_module(obj)}/${obj.name}/read', payload);
    final response = await _client.get(uri, headers: defaultHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'] is Map<String, dynamic>
            ? decoded['data'] as Map<String, dynamic>
            : decoded;
        return ${dart.nameType(obj.name)}Query.from(data);
      }
      return null;
    } else {
      throw SdkException(
        'Failed to read ${dart.nameType(obj.name)}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  ///
  /// 加载【${modelbase.get_object_label(obj)}】数据。
  ///
  Future<Pagination<${dart.nameType(obj.name)}Query>> find${dart.nameType(inflector.pluralize(obj.name))}({
    ${dart.nameType(obj.name)}Query? query,
  }) async {
    final effectiveQuery = query ?? ${dart.nameType(obj.name)}Query();
    final Map<String, dynamic> payload = effectiveQuery.to();

    <#if obj.isLabelled("pivot")>
      <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    final uri = _buildUri('/v1/${modelbase.get_object_module(obj)}/${masterObj.name}/find');
    <#else>
    final uri = _buildUri('/v1/${modelbase.get_object_module(obj)}/${obj.name}/find');
    </#if>

    final response = await _client.post(
      uri,
      headers: defaultHeaders,
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return Pagination.fromJson(
          decoded,
          (item) => ${dart.nameType(obj.name)}Query.from(item as Map<String, dynamic>),
        );
      }
      return Pagination(total: 0, data: []);
    } else {
      throw SdkException(
        'Failed to find ${dart.nameType(inflector.pluralize(obj.name))}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  ///
  /// 删除【${modelbase.get_object_label(obj)}】数据。
  ///
  Future<bool> remove${dart.nameType(obj.name)}({
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == 'datetime'><#continue></#if>
    required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
    </#list>
  }) async {
    final Map<String, dynamic> payload = {
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == 'datetime'><#continue></#if>
      '${modelbase.get_attribute_sql_name(idAttr)}': ${modelbase.get_attribute_sql_name(idAttr)},
    </#list>
    };

    <#if obj.isLabelled("pivot")>
      <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    final uri = _buildUri('/${app.name}/${masterObj.name}/remove');  
    <#else>
    final uri = _buildUri('/${app.name}/${obj.name}/remove');
    </#if>

    final response = await _client.delete(
      uri,
      headers: defaultHeaders,
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw SdkException(
        'Failed to remove ${dart.nameType(obj.name)}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
</#list>

}

/// Global default instance
final remote = Remote();