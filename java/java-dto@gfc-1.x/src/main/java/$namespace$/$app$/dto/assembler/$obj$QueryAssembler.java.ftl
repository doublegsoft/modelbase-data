<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#--  -->
<#macro print_hierarchy_assemble obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[attr.name]??><#continue></#if>
    <#assign attrname = modelbase.get_attribute_sql_name(attr)>
    <#assign attrtype = modelbase4java.type_attribute_primitive(attr)>  
    <#if attr.type.custom || attr.constraint.domainType.name?starts_with("enum")>
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), ${attrtype}.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), ${attrtype}.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), ${attrtype}.class));
      if (params.get("${inflector.pluralize(attrname)}") != null) {     
        retVal.get${java.nameType(inflector.pluralize(attrname))}().addAll((List<${attrtype}>)params.get("${inflector.pluralize(attrname)}"));
      }
      <#if attr.type.custom>
      retVal.set${java.nameType(attr.name)}(${java.nameType(attr.type.name)}QueryAssembler.assemble${java.nameType(attr.type.name)}Query(params, "${java.nameVariable(attr.name)}"));  
      </#if>
    <#elseif attr.constraint.domainType.name == "id">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), Long.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), Long.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), Long.class));   
    <#elseif attr.type.name == "int" || attr.type.name == "integer">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), Integer.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), Integer.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), Integer.class));
    <#elseif attr.type.name == "long">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), Long.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), Long.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), Long.class)); 
    <#elseif attr.type.name == "number">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), BigDecimal.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), BigDecimal.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), BigDecimal.class));    
    <#elseif attr.type.name == "datetime">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), Timestamp.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), Timestamp.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), Timestamp.class));
    <#elseif attr.type.name == "date">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), java.sql.Date.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), java.sql.Date.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), java.sql.Date.class));
    <#elseif attr.type.name == "time">  
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), java.sql.Time.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), java.sql.Time.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}1"), java.sql.Time.class));
    <#elseif attr.type.name == "string">
      retVal.set${java.nameType(attrname)}(Safe.safe(params.get(prefix + "${attrname}"), ${attrtype}.class));
      retVal.set${java.nameType(attrname)}0(Safe.safe(params.get("${attrname}0"), ${attrtype}.class));
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}0"), ${attrtype}.class));
    </#if>  
    <#if attr.identifiable>
      if (params.get("${inflector.pluralize(attrname)}") != null) {     
        retVal.get${java.nameType(inflector.pluralize(attrname))}().addAll(Safe.safeMore((List<Object>)params.get("${inflector.pluralize(attrname)}"), ${attrtype}.class));
      }
    <#elseif attr.type.name == "string" && !attr.type.custom && !attr.constraint.domainType.name?starts_with("enum")>
      retVal.set${java.nameType(attrname)}1(Safe.safe(params.get("${attrname}2"), ${attrtype}.class));
    </#if>   
    <#local processedAttrs += {attr.name:attr}> 
  </#list>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#-- 值体对象主键中引用的实体对象，不需要再Query（查询对象）中出现 -->
  <#if idAttrs?size == 1>
    <#list obj.attributes as attr>
      <#if attr.constraint.identifiable && attr.type.custom>
        <#local refObj = model.findObjectByName(attr.type.name)> 
<@print_hierarchy_assemble obj=refObj processedAttrs=processedAttrs /> 
      </#if>
    </#list>
  <#else>
    <#list obj.attributes as attr>
      <#if attr.constraint.identifiable && attr.type.custom>
        <#local refObj = model.findObjectByName(attr.type.name)> 
      retVal.set${java.nameType(attr.name)}(${java.nameType(refObj.name)}QueryAssembler.assemble${java.nameType(refObj.name)}Query(params, "${java.nameVariable(attr.name)}"));
      </#if>
    </#list>
  </#if>
</#macro>
<#assign typename = java.nameType(obj.name)>
package <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler;

import java.util.List;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import <#if namespace??>${namespace}.</#if>${app.name}.util.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

/**
 * 【${modelbase.get_object_label(obj)}】实体各层对象的装配器。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public final class ${typename}QueryAssembler {

  /**
   * 从数据库存储的数据对象中装配【${modelbase.get_object_label(obj)}】实体对象。
   *
   * @param params
   *        数据库返回的行列对象
   *
   * @return 装配后的【${modelbase.get_object_label(obj)}】实体对象
   */
  public static ${typename}Query assemble${typename}Query(Map<String,Object> params) {
    return assemble${typename}Query(params, null);
  }
   
  public static ${typename}Query assemble${typename}Query(Map<String,Object> params, String prefix) {
    if (prefix == null || prefix.trim().isEmpty()) {
      prefix = "";
    } else {
      prefix = prefix.trim() + "_";
    }
    ${typename}Query retVal = new ${typename}Query();
    if (params == null || params.isEmpty()) {
      return retVal;
    }
    if (!"".equals(prefix)) {
      boolean found = false;
      for (String key : params.keySet()) {
        if (key.startsWith(prefix)) {
          found = true;
          break;
        }
      }
      if (!found) {
        return retVal;
      }
    }
    List<${typename}Query> queries = assemble${typename}Queries(params);
    if (queries.size() > 0) {
      retVal.getQueries().addAll(queries);
    } else {
<@print_hierarchy_assemble obj=obj processedAttrs={} />  
    } 
    if (params.containsKey("orderByList")) {
      retVal.getOrderByList().addAll((List<String>)params.get("orderByList"));
    }
    if (params.containsKey("groupByList")) {
      retVal.getGroupByList().addAll((List<String>)params.get("groupByList"));
    }
    if (params.containsKey("columnList")) {
      retVal.getColumnList().addAll((List<String>)params.get("columnList"));
    }
    List<QueryHandler> handlers = QueryHandlerAssembler.extractQueryHandlers(params);
    retVal.getQueryHandlers().addAll(handlers);
    return retVal;
  }
  
  public static List<${typename}Query> assemble${typename}Queries(Map<String,Object> params) {
    List<${typename}Query> retVal = new ArrayList<>();
    if (!params.containsKey("${java.nameVariable(inflector.pluralize(obj.name))}")) {
      return retVal;
    }
    List<Map<String,Object>> rows = (List<Map<String,Object>>)params.get("${java.nameVariable(inflector.pluralize(obj.name))}");
    for (Map<String,Object> row : rows) {
      retVal.add(assemble${typename}Query(row));
    }
    return retVal;
  }

  private ${typename}QueryAssembler() {}
}
