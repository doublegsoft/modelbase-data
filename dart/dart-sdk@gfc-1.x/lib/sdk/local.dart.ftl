<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import '/common/error.dart';
import '/common/db.dart';
import '/model/dto.dart';
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  
///
/// 保存【${modelbase.get_object_label(obj)}】数据。
///
Future<${dart.nameType(obj.name)}Query> save${dart.nameType(obj.name)}({
  required ${dart.nameType(obj.name)}Query query,
}) async {
  ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
  await db.save${dart.nameType(obj.name)}(query);
  return query;
}

///
/// 读取【${modelbase.get_object_label(obj)}】数据。
///
Future<${dart.nameType(obj.name)}Query?> read${dart.nameType(obj.name)}({
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == 'datetime'><#continue></#if>
  required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
}) async {
  ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
  ${dart.nameType(obj.name)}Query query = new ${dart.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == 'datetime'><#continue></#if>
  query.${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase.get_attribute_sql_name(idAttr)};
  </#list>
  return await db.read${dart.nameType(obj.name)}(query);
}

///
/// 加载【${modelbase.get_object_label(obj)}】数据。
///
Future<Pagination<${dart.nameType(obj.name)}Query>> find${dart.nameType(inflector.pluralize(obj.name))}({
  ${dart.nameType(obj.name)}Query? query,
}) async {
  query = query ?? ${dart.nameType(obj.name)}Query();
  ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
  List<${dart.nameType(obj.name)}Query> rows = await db.find${dart.nameType(inflector.pluralize(obj.name))}(query);
  return Pagination(rows.length, rows);
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
  ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
  ${dart.nameType(obj.name)}Query query = ${dart.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == 'datetime'><#continue></#if>
  query.${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase.get_attribute_sql_name(idAttr)};
  </#list>
  int count = await db.remove${dart.nameType(obj.name)}(query);
  return count > 0;
}
</#list>