<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:intl/intl.dart';
import '/common/safe.dart';

class Pagination<T> {
  
  Pagination(int total, List<T> data) {
    _total = total;
    _data.addAll(data);
  }
  
  List<T> _data = [];
  
  int _total = 0;
  
  List<T> get data => _data;
  
  int get total => _total;

}

class QueryHandler {

  String? handler;

  AbstractQuery? query;
  
  QueryHandler({
    this.handler,
    this.query,
  });
}

class AbstractQuery {

  int? start;
  
  int? limit;
  
  List<QueryHandler> queryHandlers = <QueryHandler>[];
  
  Map<String,dynamic> results = {};
  
  AbstractQuery({
    this.start = 0,
    this.limit = 10,
    this.queryHandlers = const <QueryHandler>[],
  });
  
  Map<String,dynamic> to({List<String>? fields = const <String>[]}) {
    Map<String,dynamic> retVal = new Map<String,dynamic>();
    return retVal;
  }
}
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 【${modelbase.get_object_label(obj)}】
*/
class ${java.nameType(obj.name)}Query extends AbstractQuery {

<#assign processedAttrs = {}>
<@modelbase4dart.print_object_query_members obj=obj processedAttrs=processedAttrs />    
<#assign processedAttrs = {}> 

  ${java.nameType(obj.name)}Query({
    super.start,
    super.limit,
    super.queryHandlers = const <QueryHandler>[],
<#assign processedAttrs = {}>
<@modelbase4dart.print_object_query_init obj=obj processedAttrs=processedAttrs />     
  });
  
<#--
<@modelbase4dart.print_object_query_to_query obj=obj root=obj />
-->
<#if obj.isLabelled("pivot")>
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
</#if>

<#------------------------>
<#-- 集合对象属性的特有方法 -->
<#------------------------>
<#assign processedAttrs = {}> 
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign refObjIdAttrs = modelbase.get_id_attributes(refObj)>
  
  void addOrSet${java.nameType(modelbase.get_attribute_singular(attr))}(${java.nameType(refObj.name)}Query ${java.nameVariable(refObj.name)}) {
    <#list refObjIdAttrs as attr>
    ${modelbase4dart.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)} = ${java.nameVariable(refObj.name)}.${modelbase.get_attribute_sql_name(attr)}!;
    </#list>  
    ${java.nameType(refObj.name)}Query? found = null;
    for (${java.nameType(refObj.name)}Query child in ${java.nameVariable(attr.name)}) {
      if (
    <#list refObjIdAttrs as attr>
        ${modelbase.get_attribute_sql_name(attr)} == child.${modelbase.get_attribute_sql_name(attr)}<#if attr?index != refObjIdAttrs?size - 1> &&</#if>
    </#list>    
      ) {
        found = child;
        break;
      }
    }
    if (found == null) {
      ${java.nameVariable(attr.name)}.add(${java.nameVariable(refObj.name)});
    } else {
      
    }
  }
  
  void remove${java.nameType(modelbase.get_attribute_singular(attr))}(${java.nameType(refObj.name)}Query ${java.nameVariable(refObj.name)}) {
    <#list refObjIdAttrs as attr>
    ${modelbase4dart.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)} = ${java.nameVariable(refObj.name)}.${modelbase.get_attribute_sql_name(attr)}!;
    </#list>  
    for (${java.nameType(refObj.name)}Query child in ${java.nameVariable(attr.name)}) {
      if (
    <#list refObjIdAttrs as attr>
        ${modelbase.get_attribute_sql_name(attr)} == child.${modelbase.get_attribute_sql_name(attr)}<#if attr?index != refObjIdAttrs?size - 1> &&</#if>
    </#list>    
      ) {
        ${java.nameVariable(attr.name)}.remove(child);
        break;
      }
    }
   
  }
</#list>  
  
  @override
  Map<String,dynamic> to({List<String>? fields = const <String>[]}) {
    Map<String,dynamic> retVal = new Map<String,dynamic>();
<#assign processedAttrs = {}>     
<@modelbase4dart.print_object_query_to obj=obj processedAttrs=processedAttrs />         
    if (!fields!.isEmpty) {
      Map<String,dynamic> optionalRet = new Map<String,dynamic>();
      for (String field in fields!) {
        optionalRet[field] = retVal[field];
      }
      return optionalRet;
    }
    List<Map<String,dynamic>> queryHandlerMaps = [];
    for (final queryHandler in queryHandlers) {
      Map<String,dynamic> queryHandlerMap = {};
      queryHandlerMap['handler'] = queryHandler.handler!;
      queryHandlerMap['query'] = queryHandler.query!.to();
      queryHandlerMaps.add(queryHandlerMap);
    }
    retVal['queryHandlers'] = queryHandlerMaps;
    return retVal;
  }
  
  Map<String,dynamic> sql({List<String>? fields = const <String>[]}) {
    Map<String,dynamic> retVal = new Map<String,dynamic>();
<#assign processedAttrs = {}>     
<@modelbase4dart.print_object_query_sql obj=obj />         
    if (!fields!.isEmpty) {
      Map<String,dynamic> optionalRet = new Map<String,dynamic>();
      for (String field in fields!) {
        optionalRet[field] = retVal[field];
      }
      return optionalRet;
    }
    return retVal;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ${dart.nameType(obj.name)}Query) return false;
<#assign processedAttrs = {}>     
<@modelbase4dart.print_object_query_equal obj=obj processedAttrs=processedAttrs />        
    return true;
  }

  static ${dart.nameType(obj.name)}Query from(Map<String,dynamic> map) {
    ${dart.nameType(obj.name)}Query retVal = new ${dart.nameType(obj.name)}Query();
<#assign processedAttrs = {}>     
<@modelbase4dart.print_object_query_from obj=obj processedAttrs=processedAttrs />     
    if (map['results'] != null) {
      retVal.results.addAll(map['results'] as Map<String,dynamic>);
    }
    return retVal;
  }
  
  static List<${dart.nameType(obj.name)}Query> fromList(List<Map<String,dynamic>> rows) {
    List<${dart.nameType(obj.name)}Query> retVal = [];
    for (Map<String,dynamic> row in rows) {
      retVal.add(from(row));
    }
    return retVal;
  }
}
</#list>