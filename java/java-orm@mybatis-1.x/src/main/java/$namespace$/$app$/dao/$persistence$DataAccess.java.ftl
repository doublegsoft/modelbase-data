<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = persistence>
<#macro print_reference_assemble attr objname attrname indent>
  <#local refObj = model.findObjectByName(attr.type.name)>
  <#local idAttrs = modelbase.get_id_attributes(refObj)>
${""?left_pad(indent)}${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});  
  <#if idAttrs[0].type.custom>
<@print_reference_assemble attr=idAttrs[0] objname=java.nameVariable(refObj.name) attrname=attrname indent=indent />  
  <#else>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(idAttrs[0].name)}(${attrname});  
  </#if>
</#macro>
package <#if namespace??>${namespace}.</#if>${app.name}.dao;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.annotations.*;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
/**
 * 【${modelbase.get_object_label(obj)}】实体各层对象的装配器。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
@Mapper 
public interface ${typename}DataAccess {
  
  void insert${typename}(${typename} ${varname});
  
  void update${typename}(${typename} ${varname});
  
  void updatePartial${typename}(${typename} ${varname});
  
  void delete${typename}(${typename} ${varname});
  
  List<Map<String,Object>> select${typename}(${typename}Query query);
  
  Long selectCountOf${typename}(${typename}Query query);
  
  List<Map<String,Object>> selectAggregateOf${typename}(${typename}Query query);
  
  List<Map<String,Object>> select${typename}(${typename}Query query, RowBounds rowBounds);
<#-- 
 ### 带有【观察者】定义的对象，会根据操作符来执行相应的操作
 -->  
<#list obj.attributes as attr>
  <#if attr.isLabelled("incrementable")>
  
  void increment${java.nameType(attr.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, @Param("value") int value);
  </#if>
  <#if attr.isLabelled("decrementable")>
  
  void decrement${java.nameType(attr.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, @Param("value") int value);
  </#if>
  <#if attr.isLabelled("multipliable")>
  
  void multiply${java.nameType(attr.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, @Param("value") BigDecimal value);
  </#if>
  <#if attr.isLabelled("divisible")>
  
  void divide${java.nameType(attr.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, @Param("value") BigDecimal value);
  </#if>
  <#if attr.isLabelled("arithmeticable")>
  
  void sum${java.nameType(attr.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, @Param("value") BigDecimal value);
  
  void average${java.nameType(attr.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, @Param("value") BigDecimal value);
  </#if>
</#list>
<#-- 
 ### 含有state属性的自然带有【禁用】和【恢复】操作 
 -->
<#--   
<#list obj.attributes as attr>
  <#if attr.name == "state">  
-->
  
  /**
   * 恢复【${modelbase.get_object_label(obj)}】对象
   *
   * @param ${varname}
   *        【${modelbase.get_object_label(obj)}】对象
   */    
  void enable${java.nameType(obj.name)}(${typename} ${varname});
  
  /**
   * 禁用【${modelbase.get_object_label(obj)}】对象
   *
   * @param ${varname}
   *        【${modelbase.get_object_label(obj)}】对象
   */ 
  void disable${java.nameType(obj.name)}(${typename} ${varname});
<#--   
    </#if>
</#list>
-->
<#-- 
 ### 主键个数是一个的实体对象，自然带有通过主键查询判断存不存在的操作
 -->
<#if idAttrs?size == 1>
  
  /**
   * 判断【${modelbase.get_object_label(obj)}】实体对象是否存在
   *
   * @param ${modelbase.get_attribute_sql_name(idAttrs[0])}
   *        【${modelbase.get_object_label(obj)}】对象标识
   *
   * @return 存在为，不存在为false
   */ 
  boolean isExisting${java.nameType(obj.name)}(@Param("${modelbase.get_attribute_sql_name(idAttrs[0])}") ${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])});
<#else>  

  /**
   * 判断【${modelbase.get_object_label(obj)}】值体对象是否存在
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 存在为，不存在为false
   */ 
  boolean isExisting${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
</#if> 
<#-- 观察属性 -->  
<#--
<#assign existingAttrExprs = {}>
<#list model.objects as checkingObj>
  <#list checkingObj.attributes as checkingAttr>
    <#if !checkingAttr.isLabelled("observer")><#continue></#if>
    <#assign operator = checkingAttr.getLabelledOptions("observer")["operator"]>
    <#assign attrexpr = checkingAttr.getLabelledOptions("observer")["attribute"]>
    <#if existingAttrExprs[attrexpr]??><#continue></#if>
    <#assign existingAttrExprs += {attrexpr:attrexpr}>
    <#if attrexpr?contains("(") && attrexpr?ends_with(")")>
      <#assign attrname = attrexpr?substring(attrexpr?index_of("(")+1,attrexpr?index_of(")"))>
      <#if checkingAttr.type.name == obj.name && model.findAttributeByNames(checkingAttr.type.name, attrname)??>
        <#assign observableAttr = model.findAttributeByNames(checkingAttr.type.name, attrname)>
        <#assign observableIdAttr = modelbase.get_id_attributes(observableAttr.parent)[0]>
        <#if operator == "max">
      
  Map<String,Object> selectMax${java.nameType(attrname)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
        <#elseif operator == "min">
    
  Map<String,Object> selectMin${java.nameType(attrname)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
        <#elseif operator == "sum">
    
  ${modelbase4java.type_attribute_primitive(observableAttr)} selectSum${java.nameType(attrname)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
        </#if>
      </#if>
    </#if>
  </#list>
</#list>
-->
<#list obj.attributes as attr>
  <#if attr.isLabelled("comparable")>  
  
  ${java.nameType(obj.name)}Query selectMax${java.nameType(attr.name)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
  
  ${java.nameType(obj.name)}Query selectMin${java.nameType(attr.name)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
  </#if>  
  <#if attr.isLabelled("arithmeticable")>
  
  ${modelbase4java.type_attribute_primitive(attr)} selectAverage${java.nameType(attr.name)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
  
  ${modelbase4java.type_attribute_primitive(attr)} selectSum${java.nameType(attr.name)}Of${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
  </#if>
</#list> 
  
}
