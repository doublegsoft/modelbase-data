<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package com.hk.abpms.model.dto.${java.nameVariable(modelbase.get_object_module(obj))};

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;

/*!
** 【${modelbase.get_object_label(obj)}】
*/
public class ${java.nameType(obj.name)}Query implements Serializable {

  private static long serialVersionNumber = -1L;
<#assign processedAttrs = {}>
<@modelbase4java.print_object_query_members obj=obj processedAttrs=processedAttrs />    
<#assign processedAttrs = {}>
<@modelbase4java.print_object_query_xetters obj=obj processedAttrs=processedAttrs />   
<@modelbase4java.print_object_query_to_query obj=obj root=obj />
<#if obj.isLabelled("pivot")>
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  
  public ${java.nameType(masterObj.name)}Query to${java.nameType(masterObj.name)}Query() {
    ${java.nameType(masterObj.name)}Query retVal = new ${java.nameType(masterObj.name)}Query();
  <#list obj.attributes as attr>
    <#if attr.isLabelled("redefined")><#continue></#if>
    retVal.${modelbase4java.name_setter(attr)}(${modelbase4java.name_getter(attr)}());
  </#list>  
    return retVal;
  }
</#if>
  
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
  
  public static void setDefaultValues(${java.nameType(obj.name)}Query query) {
<#list obj.attributes as attr>
<@modelbase4java.print_query_default_setters obj=obj varname="query" indent=4 />   
</#list>  
  }
  
}