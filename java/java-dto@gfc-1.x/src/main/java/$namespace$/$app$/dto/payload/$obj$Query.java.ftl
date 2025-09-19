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
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;
<#list modelbase4java.get_imports(obj)?sort as imp>
import ${imp};
</#list>

/*!
** 【${modelbase.get_object_label(obj)}】
*/
public class ${java.nameType(obj.name)}Query extends AbstractQuery implements Serializable {

  private static long serialVersionNumber = -1L;
<#assign processedAttrs = {}>
<@modelbase4java.print_object_query_members obj=obj processedAttrs=processedAttrs />    
<#assign processedAttrs = {}>
<@modelbase4java.print_object_query_xetters obj=obj processedAttrs=processedAttrs />   
<@modelbase4java.print_object_query_to_query obj=obj root=obj />
<#-- pivot的master可以不定义 -->
<#if obj.isLabelled("pivot")>
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterOrDetailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  <#else>
    <#assign masterOrDetailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  </#if>  
  
  public ${java.nameType(masterOrDetailObj.name)}Query to${java.nameType(masterOrDetailObj.name)}Query() {
    ${java.nameType(masterOrDetailObj.name)}Query retVal = new ${java.nameType(masterOrDetailObj.name)}Query();
  <#list obj.attributes as attr>
    <#if attr.isLabelled("redefined")><#continue></#if>
    <#if attr.type.collection>
    retVal.${modelbase4java.name_getter(attr)}().addAll(${modelbase4java.name_getter(attr)}());
    <#else>
    retVal.${modelbase4java.name_setter(attr)}(${modelbase4java.name_getter(attr)}());
    </#if>
  </#list>  
    return retVal;
  }
</#if>

  public Map<String,Object> toMap() {
    Map<String,Object> retVal = new HashMap();
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
  
  public static void setDefaultValues(${java.nameType(obj.name)}Query query) {
<@modelbase4java.print_query_default_setters obj=obj varname="query" indent=4 /> 
  }
  
}