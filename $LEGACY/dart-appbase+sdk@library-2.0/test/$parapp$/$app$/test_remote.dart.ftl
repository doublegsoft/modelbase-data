<#import '/$/modelbase.ftl' as modelbase>
import "package:test/test.dart";
import "package:intl/intl.dart";

import "package:sdk_${parentApplication}_${app.name}/${parentApplication}/${app.name}/model.dart";
import "package:sdk_${parentApplication}_${app.name}/${parentApplication}/${app.name}/remote.dart";
import "package:sdk_${parentApplication}_${app.name}/${parentApplication}/common.dart";

const String HOST = "http://localhost:8880";

void main() {

<#list model.objects as obj>  
  <#if !obj.isLabelled('entity')><#continue></#if>
  <#assign entity = obj>
  <#assign attrId = modelbase.get_id_attributes(entity)[0]>
  /// ${modelbase.get_object_label(entity)}测试
  test("${modelbase.get_object_label(entity)}保存", () async {
    AppbaseHttpClient.host = HOST;
    ${java.nameType(app.name)?upper_case}AppbaseHttpClient client = ${java.nameType(app.name)?upper_case}AppbaseHttpClient();
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = ${java.nameType(entity.name)}();
  <#list entity.attributes as attr>
    <#if attr.constraint.identifiable || !attr.persistenceName??><#continue></#if>
    <#if attr.type.name == 'string'>
    ${java.nameVariable(entity.name)}.${java.nameVariable(attr.name)} = "测试";
    <#elseif (attr.type.name == 'date' || attr.type.name == 'datetime') && attr.name != 'last_modified_time'>
    ${java.nameVariable(entity.name)}.${java.nameVariable(attr.name)} = new DateFormat("yyyy-MM-dd HH:mm:ss").parse("2022-01-01 00:00:00");
    </#if>
  </#list>
    // 保存
    ${java.nameVariable(entity.name)} = await client.save${java.nameType(entity.name)}(${java.nameVariable(entity.name)}: ${java.nameVariable(entity.name)});
    // 读取
    ${java.nameVariable(entity.name)} = await client.read${java.nameType(entity.name)}(${modelbase.get_attribute_sql_name(attrId)}: ${java.nameVariable(entity.name)}.${java.nameVariable(attrId.name)}!);
    // 验证
    <#list entity.attributes as attr>
    <#if attr.constraint.identifiable || !attr.persistenceName??><#continue></#if>
    <#if attr.type.name == 'string'>
    expect(${java.nameVariable(entity.name)}.${java.nameVariable(attr.name)}, "测试");
    <#elseif (attr.type.name == 'date' || attr.type.name == 'datetime') && attr.name != 'last_modified_time'>
    expect(${java.nameVariable(entity.name)}.${java.nameVariable(attr.name)}, new DateFormat("yyyy-MM-dd HH:mm:ss").parse("2022-01-01 00:00:00"));
    </#if>
  </#list>
  });

</#list>
}