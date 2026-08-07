<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", obj, model)>
<#assign rootObj = typeDef.definition>
<#assign flow = typeDef.flow>
package ${namespace}.${app.name}.dto.payload;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;
<#list modelbase4java.get_imports(obj)?sort as imp>
import ${imp};
</#list>
import ${namespace}.${app.name}.util.Dates;
import ${namespace}.${app.name}.util.Safe;
/**
 * 【${modelbase.get_object_label(obj)}】
 */
public class ${java.nameType(obj.name)}Query extends AbstractQuery implements Serializable {

  private static final long serialVersionUID = -1L;
<#assign processedAttrs = {}>
<@modelbase4java.print_object_query_members obj=obj processedAttrs=processedAttrs />    
<#assign processedAttrs = {}>
<@modelbase4java.print_object_query_xetters obj=obj processedAttrs=processedAttrs />   
<#------------------------------------------------------------------------------>
<#-- PIVOT、META、EXTENSION对象通常都是可持久化的，同时PIVOT可以不定义MASTER，自身就是 -->
<#------------------------------------------------------------------------------>
<#if obj.isLabelled("pivot")>
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#assign keyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["key"])>
  <#assign valAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["value"])>
  <#assign masterObjIdAttr = modelbase.get_id_attributes(masterObj)?first>
<#elseif obj.isLabelled("meta")>
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("meta")["master"])>
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("meta")["detail"])>
  <#if model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("meta")["key"])??>
    <#assign keyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("meta")["key"])>
  <#else>
    <#assign keyAttr = model.findAttributeByNames(detailObj.name, "property_name")>
  </#if>
  <#if model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("meta")["value"])??>
    <#assign valAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("meta")["value"])>
  <#else>
    <#assign valAttr = model.findAttributeByNames(detailObj.name, "property_value")>
  </#if>
  <#assign masterObjIdAttr = modelbase.get_id_attributes(masterObj)?first>
<#elseif obj.isLabelled("extension")>
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("extension")["master"])>
  <#assign detailObjNames = obj.getLabelledOptions("extension")["details"]!"">
<#-------------------------------------------------------------------------->
<#-- COMPOSITE、AGGREGATE对象本身通常都是不持久化的，它的属性按照各自所属对象持久化 -->
<#-------------------------------------------------------------------------->
<#elseif obj.isLabelled("aggregate")>
  <#list obj.attributes as attr>
    <#if !attr.type.custom><#continue></#if>
    <#assign refObj = model.findObjectByName(attr.type.name)>

  public ${java.nameType(refObj.name)}Query to${java.nameType(refObj.name)}Query() {
    <#--  ${java.nameType(refObj.name)}Query retVal = new ${java.nameType(refObj.name)}Query();  -->
    ${java.nameType(refObj.name)}Query retVal = get${java.nameType(attr.name)}();
    if (retVal == null) {
      retVal = new ${java.nameType(refObj.name)}Query();
    }
    <#list flow.types as typeObj>
      <#if typeObj.reference??>
        <#assign predicate = typeObj.reference.joinPredicates[0]>
        <#assign leftObj = predicate.leftObject>
        <#assign leftAttr = predicate.leftAttribute>
        <#assign rightObj = predicate.rightObject>
        <#assign rightAttr = predicate.rightAttribute>
        <#if leftObj.name == refObj.name && leftAttr.type.custom>
        <#-- 正向引用 A->B -->
    retVal.${modelbase4java.name_setter(leftAttr)}(${modelbase4java.name_getter(rightAttr, predicate.rightObjectAlias)}());
    if (get${java.nameType(typeObj.variable)}() != null) {
      retVal.${modelbase4java.name_setter(leftAttr)}(get${java.nameType(typeObj.variable)}().${modelbase4java.name_getter(rightAttr)}());
      retVal.set${java.nameType(leftAttr.name)}(get${java.nameType(typeObj.variable)}());
    }
        <#elseif rightObj.name == refObj.name && rightAttr.type.custom> 
        <#-- 反向引用 B->A -->
    retVal.${modelbase4java.name_setter(rightAttr)}(${modelbase4java.name_getter(leftAttr, predicate.leftObjectAlias)}());
    if (get${java.nameType(typeObj.variable)}() != null) {
      retVal.${modelbase4java.name_setter(rightAttr)}(get${java.nameType(typeObj.variable)}().${modelbase4java.name_getter(leftAttr)}());
    }
        </#if>
      <#else>
      </#if>
    </#list>
    return retVal;
  }

  public void from${java.nameType(refObj.name)}Query(${java.nameType(refObj.name)}Query query) {
    
  }
  </#list>
<#else><#-- 没有任何标注的任意对象 -->  
  <#assign origObjNames = {}>
  <#list obj.attributes as attr>
    <#if attr.isLabelled("original")>
      <#assign origObjName = attr.getLabelledOption("original", "object")>
      <#if origObjNames[origObjName]??><#continue></#if>
      <#assign origObj = model.findObjectByName(origObjName)>
    <#else>
      <#continue>
    </#if>
    <#if !origObj??><#continue></#if>
    <#assign origObjNames += {origObjName:origObj}>

  public ${java.nameType(origObj.name)}Query to${java.nameType(origObj.name)}Query() {
    ${java.nameType(origObj.name)}Query retVal = new ${java.nameType(origObj.name)}Query();
    <#list obj.attributes as innerAttr>
      <#if (innerAttr.getLabelledOption("original", "object")!"") == origObj.name>
        <#assign origAttr = origObj.getAttribute(innerAttr.getLabelledOption("original", "attribute"))>
    retVal.${modelbase4java.name_setter(origAttr)}(${modelbase4java.name_getter(innerAttr)}());
      </#if>
    </#list>
    <#list flow.types as typeObj>
      <#if typeObj.reference??>
        <#assign predicate = typeObj.reference.joinPredicates[0]>
        <#assign leftObj = predicate.leftObject>
        <#assign leftAttr = predicate.leftAttribute>
        <#assign rightObj = predicate.rightObject>
        <#assign rightAttr = predicate.rightAttribute>
        <#if leftObj.name == origObjName && modelbase.get_attribute_proxy(obj,rightAttr)??>
    retVal.${modelbase4java.name_setter(leftAttr)}(${modelbase4java.name_getter(modelbase.get_attribute_proxy(obj,rightAttr))}());
          <#break>
        </#if>
      </#if>
    </#list>
    return retVal;
  }

  public void from${java.nameType(origObj.name)}Query(${java.nameType(origObj.name)}Query query) {
    <#list obj.attributes as innerAttr>
      <#if (innerAttr.getLabelledOption("original", "object")!"") == origObj.name>
        <#assign origAttr = origObj.getAttribute(innerAttr.getLabelledOption("original", "attribute"))>
    ${modelbase4java.name_setter(innerAttr)}(query.${modelbase4java.name_getter(origAttr)}());
      </#if>
    </#list>  
    <#list flow.types as typeObj>
      <#if typeObj.reference??>
        <#assign predicate = typeObj.reference.joinPredicates[0]>
        <#assign leftObj = predicate.leftObject>
        <#assign leftAttr = predicate.leftAttribute>
        <#assign rightObj = predicate.rightObject>
        <#assign rightAttr = predicate.rightAttribute>
        <#if leftObj.name == origObjName && modelbase.get_attribute_proxy(obj,rightAttr)??>
    ${modelbase4java.name_setter(modelbase.get_attribute_proxy(obj,rightAttr))}(query.${modelbase4java.name_getter(leftAttr)}());
          <#break>
        </#if>
      </#if>
    </#list>
  }
    <#assign origObjNames += {origObjName:origObjName}>
  </#list>
</#if>
<#if masterObj??>

  public ${java.nameType(masterObj.name)}Query to${java.nameType(masterObj.name)}Query() {
    ${java.nameType(masterObj.name)}Query retVal = new ${java.nameType(masterObj.name)}Query();
  <#list masterObj.attributes as attr>
    <#if attr.type.collection>
    retVal.${modelbase4java.name_getter(attr)}().addAll(${modelbase4java.name_getter(attr)}());
    <#else>
    retVal.${modelbase4java.name_setter(attr)}(${modelbase4java.name_getter(attr)}());
    </#if>
  </#list>  
    return retVal;
  }

  public void from${java.nameType(masterObj.name)}Query(${java.nameType(masterObj.name)}Query query) {
  <#list masterObj.attributes as attr>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      ${modelbase4java.name_setter(attr)}(query.${modelbase4java.name_getter(attr)}());
    }
  </#list>  
  }
</#if>
<#if detailObj??>

  public List<${java.nameType(detailObj.name)}Query> to${java.nameType(detailObj.name)}Queries() {
    List<${java.nameType(detailObj.name)}Query> retVal = new ArrayList<>();
    ${java.nameType(detailObj.name)}Query item = null;
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
    <#if attr.type.collection>
    retVal.${modelbase4java.name_getter(attr)}().addAll(${modelbase4java.name_getter(attr)}());
    <#else>
    item = new ${java.nameType(detailObj.name)}Query();
      <#list detailObj.attributes as detailAttr>
        <#if detailAttr.type.name == masterObj.name>
    item.${modelbase4java.name_setter(detailAttr)}(${modelbase.get_attribute_sql_name(masterObjIdAttr)});   
          <#break>
        </#if>
      </#list>
    item.${modelbase4java.name_setter(keyAttr)}("${attr.name?upper_case}");
      <#if attr.type.name == "date">
    item.${modelbase4java.name_setter(valAttr)}(Dates.format(${modelbase.get_attribute_sql_name(attr)}, "yyyy-MM-dd"));
      <#elseif modelbase4java.type_attribute_primitive(attr) != "String">
    item.${modelbase4java.name_setter(valAttr)}(Safe.safeString(${modelbase.get_attribute_sql_name(attr)}));
      <#else>
    item.${modelbase4java.name_setter(valAttr)}(${modelbase.get_attribute_sql_name(attr)});
      </#if>
    ${java.nameType(detailObj.name)}Query.setDefaultValues(item, true);
    retVal.add(item);
    </#if>
  </#list>  
    return retVal;
  }

  public void from${java.nameType(detailObj.name)}Query(${java.nameType(detailObj.name)}Query query) {
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
    if ("${attr.name?upper_case}".equals(query.${modelbase4java.name_getter(keyAttr)}())) {
    <#if attr.type.name == "date">
      set${java.nameType(modelbase.get_attribute_sql_name(attr))}(Dates.parseDate(query.${modelbase4java.name_getter(valAttr)}(), "yyyy-MM-dd"));
    <#elseif modelbase4java.type_attribute_primitive(attr) != "String">
      set${java.nameType(modelbase.get_attribute_sql_name(attr))}(Safe.safe${modelbase4java.type_attribute_primitive(attr)}(query.${modelbase4java.name_getter(valAttr)}()));
    <#else>
      set${java.nameType(modelbase.get_attribute_sql_name(attr))}(query.${modelbase4java.name_getter(valAttr)}());
    </#if>
    }
  </#list>  
  }

  public void from${java.nameType(detailObj.name)}Queries(List<${java.nameType(detailObj.name)}Query> queries) {
    if (queries == null || queries.isEmpty()) {
      return;
    }
    for (${java.nameType(detailObj.name)}Query row : queries) {
      from${java.nameType(detailObj.name)}Query(row);
    }
  }
</#if><#-- detailObj?? -->
<#if detailObjNames?? && detailObjNames != ""><#-- 多个详细对象 -->
  <#assign origObjNames = {}>
  <#list detailObjNames?split(";") as detailObjName>
    <#if detailObjName?contains("(")>
      <#assign objName = detailObjName?substring(0, detailObjName?index_of("("))>
      <#assign detailObj = model.findObjectByName(objName)>
    <#else>  
      <#assign detailObj = model.findObjectByName(detailObjName)>
    </#if>
  
  public ${java.nameType(detailObj.name)}Query to${java.nameType(detailObj.name)}Query() {
    ${java.nameType(detailObj.name)}Query retVal = new ${java.nameType(detailObj.name)}Query();
    <#list detailObj.attributes as attr>
      <#if attr.type.collection>
    retVal.${modelbase4java.name_getter(attr)}().addAll(${modelbase4java.name_getter(attr)}());
      <#else>
    retVal.${modelbase4java.name_setter(attr)}(${modelbase4java.name_getter(attr)}());
      </#if>
    </#list>  
    return retVal;
  }

  public void from${java.nameType(detailObj.name)}Query(${java.nameType(detailObj.name)}Query query) {
    <#list detailObj.attributes as attr>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      ${modelbase4java.name_setter(attr)}(query.${modelbase4java.name_getter(attr)}());
    }
    </#list>  
  }
  </#list>
</#if><#-- detailObjNames != "" -->
<#--------------------->
<#-- 集合属性的单独处理 -->
<#--------------------->
<#list flow.types as typeObj>
  <#if !typeObj.collection><#continue></#if>
  <#if obj.isLabelled("meta") || obj.isLabelled("pivot")><#continue></#if>
  <#assign collObj = typeObj.definition>
  <#if processedAttrs[collObj.name]??><#continue></#if>

  public List<${java.nameType(collObj.name)}Query> to${java.nameType(collObj.name)}Queries() {
    ${java.nameVariable(typeObj.variable)}.forEach(q -> {
  <#if typeObj.reference??>
    <#assign predicate = typeObj.reference.joinPredicates[0]>
    <#assign leftObj = predicate.leftObject>
    <#assign leftAttr = predicate.leftAttribute>
    <#assign rightObj = predicate.rightObject>
    <#assign rightAttr = predicate.rightAttribute>
      q.${modelbase4java.name_setter(rightAttr)}(${modelbase4java.name_getter(leftAttr, predicate.leftObjectAlias)}());
  </#if>
    });
    return ${java.nameVariable(typeObj.variable)};
  }

  public void from${java.nameType(collObj.name)}Queries(List<${java.nameType(collObj.name)}Query> queries) {
    ${java.nameVariable(typeObj.variable)}.clear();
    ${java.nameVariable(typeObj.variable)}.addAll(queries);
  }
</#list>

  public Map<String,Object> toMap() {
    Map<String,Object> retVal = new HashMap<>();
<#assign processedAttrs = {}>    
<@modelbase4java.print_object_query_to_map obj=obj processedAttrs=processedAttrs />    
    if (!this.queryResults.isEmpty()) {
      Map<String, Object> results = new HashMap<>();
      for (Map.Entry<String, Object> entry : this.queryResults.entrySet()) {
        List list = (List) entry.getValue();
        List maps = new ArrayList();
        for (Object obj : list) {
          maps.add(((AbstractQuery) obj).toMap());
        }
        results.put(entry.getKey(), maps);
      }
      retVal.put("results", results);
    }
    return retVal;
  }
  
  public Object getValue(String field) {
<#list obj.attributes as attr>
    if ("${modelbase.get_attribute_sql_name(attr)}".equals(field)) {
      return get${java.nameType(modelbase.get_attribute_sql_name(attr))}();
    }
</#list>  
    return null;
  }
  
  /**
   * 通过字段比较是否和其他对象是否相等，1表示不相等；0表示相等；-1表示字段中存在null值，无法比较。
   *
   * @param another
   *        another ${java.nameType(obj.name)}Query instance
   *
   * @param fields
   *        choosing fields to compare
   *
   * @return 1表示不相等；0表示相等；-1表示字段中存在null值，无法比较。
   */
  public int compareTo(${java.nameType(obj.name)}Query another, List<String> fields) {
    if (another == null) {
      return -1;
    }
    int retVal = 0;
    for (String field : fields) {
      Object v1 = getValue(field);
      Object v2 = another.getValue(field);
      if (v1 == null || v2 == null) {
        return -1;
      }
      if (!v1.equals(v2)) {
        return 1;
      }
    }
    return retVal;
  }

  public boolean equals(${java.nameType(obj.name)}Query another) {
    if (another == null) {
      return false;
    }
<#list obj.attributes as attr>
  <#if attr.type.collection><#continue></#if>
  <#if !attr.identifiable><#continue></#if>
    if (${modelbase.get_attribute_sql_name(attr)} == null && another.${modelbase4java.name_getter(attr)}() != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)} != null && !${modelbase.get_attribute_sql_name(attr)}.equals(another.${modelbase4java.name_getter(attr)}())) {
      return false;
    }
</#list>
    return equalsWithoutId(another);
  }

  public boolean equalsWithoutId(${java.nameType(obj.name)}Query another) {
    if (another == null) {
      return false;
    }
<#list obj.attributes as attr>
  <#if attr.type.collection><#continue></#if>
  <#if attr.identifiable><#continue></#if>
    if (${modelbase.get_attribute_sql_name(attr)} == null && another.${modelbase4java.name_getter(attr)}() != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)} != null && !${modelbase.get_attribute_sql_name(attr)}.equals(another.${modelbase4java.name_getter(attr)}())) {
      return false;
    }
</#list>
    return true;
  }
  
  public static void setDefaultValues(${java.nameType(obj.name)}Query query, boolean isCreating) {
<@modelbase4java.print_query_default_setters obj=obj varname="query" indent=4 />     
  }

  public static void setDefaultValues(${java.nameType(obj.name)}Query query) {
    setDefaultValues(query, true);
  }
  
}