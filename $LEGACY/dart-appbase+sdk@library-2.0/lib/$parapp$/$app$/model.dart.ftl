<#import '/$/modelbase.ftl' as modelbase>
import "dart:core";
import "dart:convert";

import "package:intl/intl.dart";
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';

<#list model.objects as obj>  
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value') && !obj.isLabelled('constant')><#continue></#if>
  <#assign entity = obj>
class ${java.nameType(entity.name)} {

  ${java.nameType(entity.name)}({
  <#list entity.attributes as attr>
    <#assign typename = modelbase.type_attribute(attr)>
    <#if typename == 'Timestamp' || typename == 'Date'>
    DateTime? ${java.nameVariable(attr.name)},
    <#elseif (typename == 'BigDecimal')>
    Decimal? ${java.nameVariable(attr.name)},
    <#elseif (typename == 'Integer')>
    int? ${java.nameVariable(attr.name)},
    <#elseif (typename == 'Long')>
    Bigint? ${java.nameVariable(attr.name)},
    <#elseif (typename == 'Boolean')>
    bool ${java.nameVariable(attr.name)} = false,
    <#else>
    ${typename}? ${java.nameVariable(attr.name)},
    </#if>
  </#list>
  }) {
  <#list entity.attributes as attr>
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  </#list>
  }

  <#list entity.attributes as attr>
  /// ${modelbase.get_attribute_label(attr)}<#if !attr.type.collection> —— ${attr.persistenceName!'TODO'}</#if>.
    <#assign typename = modelbase.type_attribute(attr)>
    <#if typename == 'Timestamp' || typename == 'Date'>
  DateTime? ${java.nameVariable(attr.name)};
    <#elseif (typename == 'BigDecimal')>
  Decimal? ${java.nameVariable(attr.name)};
    <#elseif (typename == 'Integer')>
  int? ${java.nameVariable(attr.name)};
    <#elseif (typename == 'Long')>
  Bigint? ${java.nameVariable(attr.name)};
    <#elseif (typename == 'Boolean')>
  bool ${java.nameVariable(attr.name)} = false;
    <#else>
  ${typename}? ${java.nameVariable(attr.name)};
    </#if>
  </#list>
  <#assign implicitReferences = modelbase.get_object_implicit_references(entity)>
  <#list implicitReferences as implicitReferenceName, implicitReference>

  dynamic? ${js.nameVariable(implicitReferenceName)};
  </#list>  

  static ${java.nameType(entity.name)} fromJson(Map json) {
    ${java.nameType(entity.name)} retVal = ${java.nameType(entity.name)}();
  <#list entity.attributes as attr>
    <#assign typename = modelbase.type_attribute(attr)>
    <#if typename == 'Timestamp' || typename == 'Date'>
    if (json["${java.nameVariable(attr.name)}"] != null) {
      if (json["${modelbase.get_attribute_sql_name(attr)}"] is int) 
        retVal.${java.nameVariable(attr.name)} = DateTime.fromMillisecondsSinceEpoch(json["${modelbase.get_attribute_sql_name(attr)}"]);
      else
        retVal.${java.nameVariable(attr.name)} = DateFormat("yyyy-MM-dd HH:mm:ss").parse(json["${modelbase.get_attribute_sql_name(attr)}"]);
    }
    <#else>
    retVal.${java.nameVariable(attr.name)} = json["${modelbase.get_attribute_sql_name(attr)}"];
    </#if>
  </#list>
    return retVal;
  }
}

</#list>
