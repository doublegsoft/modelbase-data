<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.dto.payload;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;
<#--  import <#if namespace??>${namespace}.</#if>${app.name}.util.*;  -->
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
<@modelbase4java.print_object_query_to_query obj=obj root=obj />
<#-- pivot的master可以不定义 -->

<#if obj.isLabelled("pivot") || obj.isLabelled("meta") || obj.isLabelled("extension")>
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
  </#if>  
  
  public ${java.nameType(masterObj.name)}Query to${java.nameType(masterObj.name)}Query() {
    ${java.nameType(masterObj.name)}Query retVal = new ${java.nameType(masterObj.name)}Query();
  <#list obj.attributes as attr>
    <#if (attr.getLabelledOption("original", "object")!"") != masterObj.name><#continue></#if>
    <#if attr.isLabelled("redefined")><#continue></#if>
    <#if attr.type.collection>
    retVal.${modelbase4java.name_getter(attr)}().addAll(${modelbase4java.name_getter(attr)}());
    <#else>
    retVal.${modelbase4java.name_setter(attr)}(${modelbase4java.name_getter(attr)}());
    </#if>
  </#list>  
    return retVal;
  }

  public void from${java.nameType(masterObj.name)}Query(${java.nameType(masterObj.name)}Query query) {
  <#list obj.attributes as attr>
    <#if (attr.getLabelledOption("original", "object")!"") != masterObj.name><#continue></#if>
    <#if attr.isLabelled("redefined")><#continue></#if>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      ${modelbase4java.name_setter(attr)}(query.${modelbase4java.name_getter(attr)}());
    }
  </#list>  
  }
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
</#if>

  public Map<String,Object> toMap() {
    Map<String,Object> retVal = new HashMap<>();
<#assign processedAttrs = {}>    
<@modelbase4java.print_object_query_to_map obj=obj processedAttrs=processedAttrs />    
    if (!this.results.isEmpty()) {
      Map<String, Object> results = new HashMap<>();
      for (Map.Entry<String, Object> entry : this.results.entrySet()) {
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
  
  public static void setDefaultValues(${java.nameType(obj.name)}Query query, boolean isCreating) {
<@modelbase4java.print_query_default_setters obj=obj varname="query" indent=4 />     
  }

  public static void setDefaultValues(${java.nameType(obj.name)}Query query) {
    setDefaultValues(query, true);
  }
  
}