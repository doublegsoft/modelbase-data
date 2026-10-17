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

// ==========================================
// 全局配置与状态（无 class 类型定义）
// ==========================================

String _baseUrl = '';
http.Client _client = http.Client();
Map<String, String> _defaultHeaders = {'Content-Type': 'application/json'};

/// 初始化或修改网络配置
void initRemote({
  String? baseUrl,
  http.Client? client,
  Map<String, String>? headers,
}) {
  if (baseUrl != null) _baseUrl = baseUrl;
  if (client != null) _client = client;
  if (headers != null) _defaultHeaders = headers;
}

/// 关闭网络连接
void closeRemote() {
  _client.close();
}

/// 内部 URI 构建工具函数
Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
  final cleanBase = _baseUrl.endsWith('/')
      ? _baseUrl.substring(0, _baseUrl.length - 1)
      : _baseUrl;

  final cleanPath = path.startsWith('/') ? path : '/$path';
  final baseUri = Uri.parse('$cleanBase$cleanPath');

  if (queryParameters == null || queryParameters.isEmpty) {
    return baseUri;
  }

  final query = <String, String>{};
  queryParameters.forEach((key, value) {
    if (value != null) {
      query[key] = value.toString();
    }
  });

  return baseUri.replace(queryParameters: query);
}

// ==========================================
// 业务 API 函数定义（全部为顶层纯函数）
// ==========================================

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

Future<List<${dart.nameType(obj.name)}Query>> save${dart.nameType(modelbase.get_object_plural(obj))}({
  required List<${dart.nameType(obj.name)}Query> queries,
}) async {
  List<Map<String, dynamic>> payload = [];
  for (final query in queries) {
    payload.add(query.to());
  }
  final uri = _buildUri('/api/${modelbase.get_object_module(obj)}/${modelbase.get_object_plural(obj)}/batch');
  final response = await _client.post(
    uri,
    headers: _defaultHeaders,
    body: jsonEncode(payload),
  );
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return [];
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
  Map<String, dynamic> payload = query.to();
  final uri = _buildUri('/api/${modelbase.get_object_module(obj)}/${modelbase.get_object_module(obj)}/${obj.name}/save');
  final response = await _client.post(
    uri,
    headers: _defaultHeaders,
    body: jsonEncode(payload),
  );
  if (response.statusCode >= 200 && response.statusCode < 300) {
    final dynamic decoded = jsonDecode(response.body);

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
  final response = await _client.get(uri, headers: _defaultHeaders);

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
    headers: _defaultHeaders,
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
    return Pagination(0, []);
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
Future<bool> delete${dart.nameType(obj.name)}({
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
    headers: _defaultHeaders,
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