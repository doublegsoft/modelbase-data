<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>

import 'dart:convert';
import 'package:intl/intl.dart';
import 'poco.dart';
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
///
/// 【${modelbase.get_object_label(obj)}】JSON转换工具类。
///
class ${dart.nameType(obj.name)}Json {
   
  static ${dart.nameType(obj.name)} from(Map<String,dynamic> json) {
    ${dart.nameType(obj.name)} ret = ${dart.nameType(obj.name)}();
    <#list obj.attributes as attr>  
      <#if attr.isLabelled("redefined")><#continue></#if>
      <#if attr.type.custom>
        <#assign refObj = model.findObjectByName(attr.type.name)>
        <#if refObj.isLabelled("generated")>
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {
      ret.${modelbase.get_attribute_sql_name(attr)} = json['${modelbase.get_attribute_sql_name(attr)}'];
    }
        <#else>
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {
      ret.${modelbase.get_attribute_sql_name(attr)} = json['${modelbase.get_attribute_sql_name(attr)}'];
    }
        </#if>
      <#elseif attr.type.collection>
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {  
      List ${dart.nameVariable(attr.name)} = json['${modelbase.get_attribute_sql_name(attr)}'];
      ${dart.nameVariable(attr.name)}.forEach((row) {
        ret.${modelbase.get_attribute_sql_name(attr)}.add(${dart.nameType(attr.type.componentType.name)}Json.from(row));
      });
    }
      <#elseif attr.type.name == "int" || attr.type.name == "integer">
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {
      ret.${modelbase.get_attribute_sql_name(attr)} = json['${modelbase.get_attribute_sql_name(attr)}'];
    }   
      <#elseif attr.type.name == "number">
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {
      ret.${modelbase.get_attribute_sql_name(attr)} = json['${modelbase.get_attribute_sql_name(attr)}'];
    }   
      <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {
      ret.${modelbase.get_attribute_sql_name(attr)} = DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['${modelbase.get_attribute_sql_name(attr)}'] as String);
    }   
      <#else>
    if (json.containsKey('${modelbase.get_attribute_sql_name(attr)}')) {
      ret.${modelbase.get_attribute_sql_name(attr)} = json['${modelbase.get_attribute_sql_name(attr)}'] as String;
    }  
      </#if>
    </#list>
    <#-- META -->
    <#if obj.isLabelled("meta")>
    List jsonMetas = json['metas']??[];
    jsonMetas.forEach((jsonMeta) {
      <#list obj.attributes as attr>
        <#if !attr.isLabelled("redefined")><#continue></#if>
      if (jsonMeta['propertyName'] == '${modelbase.get_attribute_sql_name(attr)}') {
        ret.${modelbase.get_attribute_sql_name(attr)} = jsonMeta['propertyValue'];
      }
      </#list>
    });
    <#-- PIVOT -->
    <#elseif obj.isLabelled("pivot")>
      <#assign detail = obj.getLabelledOptions("pivot")["detail"]>
      <#assign key = obj.getLabelledOptions("pivot")["key"]>
      <#assign value = obj.getLabelledOptions("pivot")["value"]>
    List json${dart.nameType(inflector.pluralize(detail))} = json['${dart.nameVariable(inflector.pluralize(detail))}']??[];
    json${dart.nameType(inflector.pluralize(detail))}.forEach((jsonRow) {
      <#list obj.attributes as attr>
        <#if !attr.isLabelled("redefined")><#continue></#if>
      if (jsonRow['${dart.nameVariable(key)}'] == '${modelbase.get_attribute_sql_name(attr)}') {
        ret.${modelbase.get_attribute_sql_name(attr)} = jsonRow['${dart.nameVariable(value)}'];
      }
      </#list>
    });     
    </#if>
    return ret;
  }
  
  static Map<String,dynamic> to(${dart.nameType(obj.name)} ${dart.nameVariable(obj.name)}) {
    Map<String,dynamic> ret = Map<String,dynamic>();
    <#list obj.attributes as attr>  
      <#if attr.isLabelled("redefined")><#continue></#if>
      <#if attr.type.custom>
        <#assign refObj = model.findObjectByName(attr.type.name)>
        <#if refObj.isLabelled("generated")>
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      ret['${modelbase.get_attribute_sql_name(attr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
    }
        <#else>
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      ret['${modelbase.get_attribute_sql_name(attr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
    }
        </#if>
      <#elseif attr.type.collection>
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      List rows = [];
      ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}.forEach((row) {
        rows.add(${dart.nameType(attr.type.componentType.name)}Json.to(row));
      });
      ret['${modelbase.get_attribute_sql_name(attr)}'] = rows;
    }     
      <#elseif attr.type.name == "int" || attr.type.name == "integer">
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      ret['${modelbase.get_attribute_sql_name(attr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
    }   
      <#elseif attr.type.name == "number">
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != double.infinity) {
      ret['${modelbase.get_attribute_sql_name(attr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
    }   
      <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      ret['${modelbase.get_attribute_sql_name(attr)}'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}!);
    }   
      <#else>
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      ret['${modelbase.get_attribute_sql_name(attr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
    }  
      </#if>
    </#list>
    <#-- META -->
    <#if obj.isLabelled("meta")>
    List metas = [];
      <#list obj.attributes as attr>
        <#if !attr.isLabelled("redefined")><#continue></#if>
        <#assign idAttrs = modelbase.get_id_attributes(obj)>
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      Map meta = {};
        <#list idAttrs as idAttr>
      if ((${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)}??'') == '') {
        meta['${modelbase.get_attribute_sql_name(idAttr)}'] = '${r"\${"}${modelbase.get_attribute_sql_name(idAttr)}${r"}"}'; 
      } else {   
        meta['${modelbase.get_attribute_sql_name(idAttr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)};
      }
        </#list>
      meta['propertyName'] = '${modelbase.get_attribute_sql_name(attr)}';
      meta['propertyValue'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
      metas.add(meta);
    }
      </#list>
    ret['metas'] = metas;  
    <#-- PIVOT -->
    <#elseif obj.isLabelled("pivot")>
      <#assign master = obj.getLabelledOptions("pivot")["master"]>
      <#assign masterObj = model.findObjectByName(master)>
      <#assign detail = obj.getLabelledOptions("pivot")["detail"]>
      <#assign key = obj.getLabelledOptions("pivot")["key"]>
      <#assign value = obj.getLabelledOptions("pivot")["value"]>
      <#assign idAttrs = modelbase.get_id_attributes(masterObj)>
    List ${dart.nameVariable(inflector.pluralize(detail))} = [];  
      <#list obj.attributes as attr>
        <#if !attr.isLabelled("redefined")><#continue></#if>
    if (${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != null) {
      Map ${dart.nameVariable(detail)} = {};
        <#list idAttrs as idAttr>
      if ((${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)}??'') == '') {  
        ${dart.nameVariable(detail)}['${modelbase.get_attribute_sql_name(idAttr)}'] = '${r"\${"}${modelbase.get_attribute_sql_name(idAttr)}${r"}"}'; 
      } else {
        ${dart.nameVariable(detail)}['${modelbase.get_attribute_sql_name(idAttr)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)};
      }  
        </#list>
      ${dart.nameVariable(detail)}['${dart.nameVariable(key)}'] = '${modelbase.get_attribute_sql_name(attr)}';
      ${dart.nameVariable(detail)}['${dart.nameVariable(value)}'] = ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)};
      ${dart.nameVariable(inflector.pluralize(detail))}.add(${dart.nameVariable(detail)});
    }
      </#list>
    ret['${dart.nameVariable(inflector.pluralize(detail))}'] = ${dart.nameVariable(inflector.pluralize(detail))};
    </#if>
    return ret;
  }
}
</#list>