<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import '/common/xhr.dart' as xhr;
import '/common/error.dart';
import '/model/dto.dart';
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign pluralTypeName = inflector.pluralize(dart.nameType(obj.name))>
  <#assign singularTypeName = dart.nameType(obj.name)>
  <#if pluralTypeName == singularTypeName>
    <#assign pluralTypeName += "List">
  </#if>
  
///
/// 保存【${modelbase.get_object_label(obj)}】多个数据。
///
Future<void> save${pluralTypeName}({
  required List<${dart.nameType(obj.name)}Query> queries,
}) async {
  List<Map<String,dynamic>> payload = [];
  for (final query in queries) {
    payload.add(query.to());
  }
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  Map<String,dynamic> data = await xhr.post('/${app.name}/${masterObj.name}/batch', payload);  
  <#else>
  Map<String,dynamic> data = await xhr.post('/${app.name}/${obj.name}/batch', payload);
  </#if>
}
    
///
/// 保存【${modelbase.get_object_label(obj)}】数据。
///
Future<${dart.nameType(obj.name)}Query> save${dart.nameType(obj.name)}({
  required ${dart.nameType(obj.name)}Query query,
}) async {
  Map<String,dynamic> payload = query.to();
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  Map<String,dynamic> data = await xhr.post('/${app.name}/${masterObj.name}/save', payload);  
  <#else>
  Map<String,dynamic> data = await xhr.post('/${app.name}/${obj.name}/save', payload);
  </#if>
  <#list idAttrs as idAttr>
  query.${modelbase.get_attribute_sql_name(idAttr)} = data['${modelbase.get_attribute_sql_name(idAttr)}'];
  </#list>
  return query;
}

///
/// 部分保存【${modelbase.get_object_label(obj)}】数据。
///
Future<${dart.nameType(obj.name)}Query> modify${dart.nameType(obj.name)}({
  required ${dart.nameType(obj.name)}Query query,
}) async {
  Map<String,dynamic> payload = query.to();
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  Map<String,dynamic> data = await xhr.patch('/${app.name}/${masterObj.name}/modify', payload);  
  <#else>
  Map<String,dynamic> data = await xhr.patch('/${app.name}/${obj.name}/modify', payload);
  </#if>
  <#list idAttrs as idAttr>
  query.${modelbase.get_attribute_sql_name(idAttr)} = data['${modelbase.get_attribute_sql_name(idAttr)}'];
  </#list>
  return query;
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
  Map<String,dynamic> payload = {};
  bool hasIdValue = false;
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == "datetime"><#continue></#if>
  if (${modelbase.get_attribute_sql_name(idAttr)} != '') {
    hasIdValue = true;
    payload['${modelbase.get_attribute_sql_name(idAttr)}'] = ${modelbase.get_attribute_sql_name(idAttr)};
  }
  </#list>
  if (!hasIdValue) {
    throw Exception('there is no given id value to read ${dart.nameType(obj.name)} object.');
  }
  Map<String,dynamic> data = await xhr.get('/${app.name}/${obj.name}/read', payload);
  return ${dart.nameType(obj.name)}Query.from(data);
}

///
/// 加载【${modelbase.get_object_label(obj)}】数据。
///
Future<Pagination<${dart.nameType(obj.name)}Query>> find${dart.nameType(inflector.pluralize(obj.name))}({
  ${dart.nameType(obj.name)}Query? query,
}) async {
  List<${dart.nameType(obj.name)}Query> rows = [];
  query = query ?? ${dart.nameType(obj.name)}Query();
  Map<String,dynamic> payload = query.to();
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  Map<String,dynamic> data = await xhr.post('/${app.name}/${masterObj.name}/find', payload);  
  <#else>
  Map<String,dynamic> data = await xhr.post('/${app.name}/${obj.name}/find', payload);
  </#if>
  data['data'].forEach((item) {
    rows.add(${dart.nameType(obj.name)}Query.from(item));
  });
  return new Pagination(data['total'], rows);
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
  Map<String,dynamic> payload = {
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == 'datetime'><#continue></#if>
    '${modelbase.get_attribute_sql_name(idAttr)}': ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
  };
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  Map<String,dynamic> data = await xhr.delete('/${app.name}/${masterObj.name}/remove', payload);  
  <#else>
  Map<String,dynamic> data = await xhr.delete('/${app.name}/${obj.name}/remove', payload);
  </#if>
  return true;
}

  <#list obj.attributes as attr>
    <#if attr.isLabelled("incrementable")>

///
/// 自增【${modelbase.get_object_label(obj)}】【${modelbase.get_object_label(attr)}】数据。
///    
Future<bool> increment${dart.nameType(attr.name)}({
  required ${dart.nameType(obj.name)}Query query,
}) async {
  Map<String,dynamic> payload = query.to();
  Map<String,dynamic> resp = await xhr.patch('/${app.name}/${obj.name}/${attr.name}/increment', payload);  
  return true;
}  
    </#if>
  </#list>
</#list>