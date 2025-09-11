<#import '/$/modelbase.ftl' as modelbase>

import 'dart:collection';
import "dart:core";
import "dart:convert";
import "dart:async";
import "dart:io";

import "package:intl/intl.dart";

import "../common.dart";
import "./model.dart";

class ${java.nameType(app.name)?upper_case}AppbaseHttpClient extends AppbaseHttpClient {

<#list model.objects as obj>  
  <#if obj.isLabelled('entity')>
    <#assign attrIds = modelbase.get_id_attributes(obj)>
  /// 
  /// Gets the unique ${java.nameType(obj.name)} instance or null (if not found).
  ///
  Future<${java.nameType(obj.name)}> save${java.nameType(obj.name)}({${java.nameType(obj.name)}? ${java.nameVariable(obj.name)}, Map<String, dynamic>? extra}) async {
    final params = HashMap();
    
    if (${java.nameVariable(obj.name)} != null) {
    <#list obj.attributes as attr>
      <#if attr.type.name == 'date' || attr.type.name == 'datetime'>
      if (${java.nameVariable(obj.name)}.${java.nameVariable(attr.name)} != null) {
        params["${modelbase.get_attribute_sql_name(attr)}"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(${java.nameVariable(obj.name)}.${java.nameVariable(attr.name)}!);
      }
      <#else>
      if (${java.nameVariable(obj.name)}.${java.nameVariable(attr.name)} != null) {
        params["${modelbase.get_attribute_sql_name(attr)}"] = ${java.nameVariable(obj.name)}.${java.nameVariable(attr.name)};
      }
      </#if>
    </#list>
    }

    if (extra != null) {
      params.addAll(extra);
    }

    AppbaseHttpClientResponse response = await post(
      uri: "/api/v3/common/script/stdbiz/${app.name}/${obj.name}/save", 
      params: params
    );
    
    if (response.hasError) {
      throw response.error!;
    }

    return ${java.nameType(obj.name)}.fromJson(response.getDataAsMap());
  }

  /// 
  /// Gets the unique ${java.nameType(obj.name)} instance or null (if not found).
  ///
  Future<${java.nameType(obj.name)}> read${java.nameType(obj.name)}({String ${modelbase.get_attribute_sql_name(attrIds[0])} = ""}) async {
    final params = <String, dynamic>{
    <#list attrIds as attrId>
      "${modelbase.get_attribute_sql_name(attrId)}": ${modelbase.get_attribute_sql_name(attrId)},
    </#list>
    };

    AppbaseHttpClientResponse response = await post(
      uri: "/api/v3/common/script/stdbiz/${app.name}/${obj.name}/read", 
      params: params
    );
    
    if (response.hasError) {
      throw response.error!;
    }

    return ${java.nameType(obj.name)}.fromJson(response.getDataAsMap());
  }

  /// 
  /// Gets the collection of ${java.nameType(obj.name)} instances or empty (if not found).
  ///
  Future<List<${java.nameType(obj.name)}>> find${java.nameType(modelbase.get_object_plural(obj))}({Map<String, dynamic>? params}) async {
    if (params == null) {
      params = HashMap();
    }
    AppbaseHttpClientResponse response = await post(
      uri: "/api/v3/common/script/stdbiz/${app.name}/${obj.name}/find", 
      params: params
    );

    if (response.hasError) {
      throw response.error!;
    }

    List<${java.nameType(obj.name)}> retVal = [];
    for (var i = 0; i < response.getDataAsList().length; i++) {
      retVal.add(${java.nameType(obj.name)}.fromJson(response.getDataAsList()[i]));
    }
    return retVal;
  }

  ///
  /// Gets paginating collection of ${java.nameType(obj.name)} instances or empty (if not found).
  /// 
  Future<Pagination> paginate${java.nameType(modelbase.get_object_plural(obj))}({int start = 0, int limit = 15, Map<String, dynamic>? params}) async {
    if (params == null) {
      params = HashMap();
    }
    params["start"] = start;
    params["limit"] = limit;
    AppbaseHttpClientResponse response = await post(
      uri: "/api/v3/common/script/stdbiz/${app.name}/${obj.name}/paginate", 
      params: params
    );

    if (response.hasError) {
      throw response.error!;
    }

    Pagination retVal = Pagination();
    Pagination page = response.getDataAsPagination();
    List<${java.nameType(obj.name)}> data = [];
    for (var i = 0; i < page.data.length; i++) {
      data.add(${java.nameType(obj.name)}.fromJson(page.data[i]));
    }
    retVal.total = page.total;
    retVal.data = data;
    return retVal;
  }

  </#if>
</#list>
}

