<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:intl/intl.dart';
import '/model/dto.dart';

const Duration delayed = Duration(seconds: 0, milliseconds: 200,);
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  
///
/// 保存【${modelbase.get_object_label(obj)}】数据。
///
Future<${dart.nameType(obj.name)}Query> save${dart.nameType(obj.name)}({
  required ${dart.nameType(obj.name)}Query ${dart.nameVariable(obj.name)},
}) async {
  await Future.delayed(delayed);
  <#list idAttrs as idAttr>
  ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase4dart.test_unit_value(idAttr)};
  </#list>
  return ${dart.nameVariable(obj.name)};
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
  await Future.delayed(delayed);
  ${dart.nameType(obj.name)}Query ret = ${dart.nameType(obj.name)}Query();
  <#list obj.attributes as attr>
    <#if attr.type.collection><#continue></#if>
    <#if attr.type.name == 'json'><#continue></#if>
  ret.${modelbase.get_attribute_sql_name(attr)} = ${modelbase4dart.test_unit_value(attr)};
  </#list>
  return ret;
}

///
/// 加载【${modelbase.get_object_label(obj)}】数据。
///
Future<Pagination<${dart.nameType(obj.name)}Query>> find${dart.nameType(inflector.pluralize(obj.name))}({
  ${dart.nameType(obj.name)}Query? query,
}) async {
  await Future.delayed(delayed);
  List<${dart.nameType(obj.name)}Query> items = [];
  ${dart.nameType(obj.name)}Query item;
  <#list 0..9 as i>
  item = ${dart.nameType(obj.name)}Query();
    <#list obj.attributes as attr>
      <#if attr.type.collection><#continue></#if>
      <#if attr.type.name == 'json'><#continue></#if>
  item.${modelbase.get_attribute_sql_name(attr)} = ${modelbase4dart.test_unit_value(attr)};
    </#list>
  items.add(item);
  </#list>
  return Pagination(100, items);
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
  await Future.delayed(delayed);
  return true;
}
</#list>