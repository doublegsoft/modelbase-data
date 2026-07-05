<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", obj, model)>
<#assign flow = typeDef.flow>
<#assign idAttrs = typeDef.getIdentifiableAttributes()>
<#assign existings = {}>
<#macro print_variables flow>
  <#local existings = {}>
  <#list flow.types as typeObj>
    <#if existings[typeObj.variable]??><#continue></#if>
    ${java.nameType(typeObj.name)}Query ${java.nameVariable(typeObj.variable)}Query = null;
    <#local existings = {typeObj.variable: typeObj}>
  </#list>
  <#local existings = {}>
  <#list flow.types as typeObj>
    <#if existings[typeObj.variable]??><#continue></#if>
    ${java.nameType(typeObj.name)} ${java.nameVariable(typeObj.variable)} = null;
    <#local existings = {typeObj.variable: typeObj}>
  </#list>
  <#local existings = {}>
  <#list flow.types as typeObj>
    <#if existings[typeObj.variable]??><#continue></#if>
    List<${java.nameType(typeObj.name)}Query> ${java.nameVariable(typeObj.variable)}Queries = null;
    <#local existings = {typeObj.variable: typeObj}>
  </#list>
  <#local existings = {}>
  <#list idAttrs as idAttr>
    <#if existings[modelbase.get_attribute_sql_name(idAttr)]??><#continue></#if>
    ${modelbase4java.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)} = null;
    <#local existings = {modelbase.get_attribute_sql_name(idAttr): idAttr}>
  </#list>
</#macro>
package <#if namespace??>${namespace}.</#if>${app.name}.service.impl;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.math.BigDecimal;
import java.io.Serializable;
import java.util.Date;
import java.sql.Timestamp;
import jakarta.inject.*;
import jakarta.transaction.*;

import org.apache.ibatis.session.RowBounds;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.orm.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dao.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.valid.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;

/**
 * 【${typeDef.label!""}】存储事务化的服务实现。
 */
@Named("<#if namespace??>${namespace}.</#if>${app.name}.service.${java.nameType(typeDef.name)}Service") 
public class ${java.nameType(typeDef.name)}ServiceImpl extends QueryHandlerService implements ${java.nameType(typeDef.name)}Service {
<#if obj.isLabelled("composite")><#-- FIXME: 是不是最好的设计 -->

  @Inject
  private ${java.nameType(obj.name)}DataAccess ${java.nameVariable(obj.name)}DataAccess;
</#if>
<#list flow.types as typeObj>
  <#if existings[typeObj.variable]??><#continue></#if>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#------------------------------------------->
  <#-- 说明当前的类型定义就是数据对象，这个非常重要 -->
  <#------------------------------------------->
  <#if typeRefType == "SREF">

  @Inject
  private ${java.nameType(typeDef.name)}DataAccess ${java.nameVariable(typeDef.name)}DataAccess;

  @Inject
  private ${java.nameType(typeDef.name)}Validation ${java.nameVariable(typeDef.name)}Validation;
  <#else>

  @Inject
  private ${java.nameType(typeObj.name)}Service ${java.nameVariable(typeObj.variable)}Service;
  </#if>
  <#assign existings += {typeObj.variable: typeObj}>
</#list>

  @Transactional(rollbackOn = Exception.class)
  public void save${java.nameType(modelbase.get_object_plural(obj))}(List<${java.nameType(obj.name)}Query> queries) throws ServiceException {
    for (${java.nameType(obj.name)}Query query : queries) {
      save${java.nameType(obj.name)}(query);
    }
  }

  /**
   * 保存【${typeDef.label!""}】对象实例
   *
   * @param query
   *        【${typeDef.label!""}】对象查询条件
   *
   * @return 保存后的【${typeDef.label!""}】对象查询条件，包含了标识属性等默认值
   */
  @Transactional(rollbackOn = Exception.class)
  public ${java.nameType(typeDef.name)}Query save${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
<#------------------->    
<#-- 涉及到的变量定义 -->
<#------------------->      
    boolean existing = true;
<@print_variables flow />    
<#list flow.types as typeObj>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#if typeRefType == "SREF">
    <#------------------------------------------------------------------------------------------------>
    <#-- 这个意味着是妥妥的数据对象，或者直接继承的数据对象（下划线结尾，比如：meta_），就是这个服务类的主要操作对象 -->
    <#------------------------------------------------------------------------------------------------>
    <#------------------------------------------------------------------------------------>
    <#-- 1. 验证标识属性是否有值，如果没有则认为是新数据需要生成标识值，如果有则认为是已有数据需要更新 -->
    <#------------------------------------------------------------------------------------>
    <#list idAttrs as idAttr>    
    ${modelbase.get_attribute_sql_name(idAttr)} = query.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}();
      <#if modelbase.type_attribute_primitive(idAttr) != "Long"><#continue></#if>
    if (Strings.isBlank(${modelbase.get_attribute_sql_name(idAttr)})) {
      <#if idAttr.type.name == "long" || idAttr.type.name == "string">    
      ${modelbase.get_attribute_sql_name(idAttr)} = IdGenerator.id();
      query.${modelbase4java.name_setter(idAttr)}(${modelbase.get_attribute_sql_name(idAttr)});
      </#if>     
      existing = false;
    }
    </#list>
    <#----------------------------------------------------------------------------->
    <#-- 2. 即使标识属性存在值也要验证是否真的存在，避免前端传入一个不存在的标识值导致保存失败 -->
    <#----------------------------------------------------------------------------->
    if (existing) {
      ${java.nameType(typeDef.name)}Query existingQuery = new ${java.nameType(typeDef.name)}Query();
    <#list idAttrs as idAttr>
      existingQuery.set${java.nameType(modelbase.get_attribute_sql_name(idAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}());
    </#list>
      existing = ${java.nameVariable(typeDef.name)}DataAccess.isExisting${java.nameType(typeDef.name)}(existingQuery);
    }
    <#------------------------------------------------->
    <#-- 3. 根据数据模型定义，设置默认值并且校验数据的合法性 --> 
    <#------------------------------------------------->
    ${java.nameType(typeObj.name)}Query.setDefaultValues(query, !existing); 
    ValidationResult res = ${java.nameVariable(typeObj.variable)}Validation.validate(query, !existing);
    if (!res.isValid()) {
      throw new ServiceException(res.getCode(), res.getMessage());
    }
  <#else>
    <#assign refTypeName = typeDef.getReferenceType(typeObj)>
    <#---------------------------------------------------------------------------------------->
    <#-- 类型对象是非持久化的，说明这个对象可能是聚合对象（aggregate root）、合成对象（composite row） -->
    <#-- 或者是非持久化的数据对象 （data object），最后一个也是重点对象。                            -->
    <#---------------------------------------------------------------------------------------->
    <#-- 次对象和主对象的关系来确定，采用什么方式处理 -->
    <#if refTypeName == "PREF">
      <#assign refObj = model.findObjectByName(typeObj.name)>
      <#assign refObjIdAttr = refObj.getIdentifiableAttribute()>
    ${java.nameVariable(typeObj.variable)}Query = query.get${java.nameType(typeObj.variable)}();
    if (${java.nameVariable(typeObj.variable)}Query != null) {
      ${java.nameVariable(typeObj.variable)}Service.save${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
      query.${modelbase4java.name_setter(refObjIdAttr, typeObj.variable)}(${java.nameVariable(typeObj.variable)}Query.${modelbase4java.name_getter(refObjIdAttr)}());
    }
    <#elseif refTypeName == "AREF">
      <#assign refObj = model.findObjectByName(typeObj.name)>
      <#assign refObjIdAttr = refObj.getIdentifiableAttribute()>
    ${java.nameVariable(typeObj.variable)}Query = query.to${java.nameType(typeObj.name)}Query();
    if (${java.nameVariable(typeObj.variable)}Query != null) {
      ${java.nameVariable(typeObj.variable)}Service.save${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
      query.${modelbase4java.name_setter(refObjIdAttr, typeObj.variable)}(${java.nameVariable(typeObj.variable)}Query.${modelbase4java.name_getter(refObjIdAttr)});
    }
    <#-- 集合对象应该在主对象保存后才保存 -->
    <#--  <#elseif refTypeName == "CREF">
      <#asssign collObj = model.findObjectByName(typeObj.name)>
    ${java.nameVariable(typeObj.variable)}Queries = query.to${java.nameType(typeObj.name)}Queries();
    ${java.nameVariable(typeObj.variable)}Service.save${java.nameType(typeObj.plural)}(${java.nameVariable(typeObj.variable)}Queries);  -->
    </#if>
  </#if>
</#list>
<#-- FIXME: 此处逻辑可以设计得更好 -->
<#-- 特殊处理OREF，倒序处理，此处的设计不够好 -->
<#if typeDef.definition.attributes[0].isLabelled("original")>
  <#list (flow.types?size-1)..0 as idx>
    <#assign typeObj = flow.types[idx]>
    <#assign refTypeName = typeDef.getReferenceType(typeObj)>
    <#if refTypeName != "OREF"><#continue></#if>
    ${java.nameVariable(typeObj.variable)}Query = query.to${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.variable)}Service.save${java.nameType(typeObj.variable)}(${java.nameVariable(typeObj.variable)}Query);
    query.from${java.nameType(typeObj.name)}Query(${java.nameVariable(typeObj.variable)}Query);
  </#list>
</#if>
<#if typeDef.persistence>
  <#------------------------------------------------------>
  <#-- 4. 插入或者更新主要对象的数据，方法末尾才调用对自身的保存 -->
  <#------------------------------------------------------>
    ${java.nameVariable(typeDef.name)} = ${java.nameType(typeDef.name)}Assembler.assemble${java.nameType(typeDef.name)}FromQuery(query);
    if (!existing) {
      ${java.nameVariable(typeDef.name)}DataAccess.insert${java.nameType(typeDef.name)}(${java.nameVariable(typeDef.name)});
    } else {
      ${java.nameVariable(typeDef.name)}DataAccess.updatePartial${java.nameType(typeDef.name)}(${java.nameVariable(typeDef.name)});      
    }
</#if>
<#if typeDef.definition.attributes[0].isLabelled("original")>
  <#list (flow.types?size-1)..0 as idx>
    <#assign typeObj = flow.types[idx]>
    <#assign refTypeName = typeDef.getReferenceType(typeObj)>
    <#if refTypeName != "CREF"><#continue></#if>
    ${java.nameVariable(typeObj.variable)}Queries = query.to${java.nameType(typeObj.name)}Queries();
    ${java.nameVariable(typeObj.variable)}Service.save${java.nameType(inflector.pluralize(typeObj.variable))}(${java.nameVariable(typeObj.variable)}Queries);
  </#list>
</#if>
    return query;   
  }
  
  /**
   * 读取【${typeDef.label!""}】对象实例
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 【${typeDef.label!""}】对象实例
   */
  public ${java.nameType(typeDef.name)}Query read${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException { 
    ${java.nameType(typeDef.name)}Query retVal = new ${java.nameType(typeDef.name)}Query();
    List<Map<String, Object>> results = null;
<@print_variables flow />
<#list flow.types as typeObj>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#if typeRefType == "SREF">
    boolean areAllIdsEmpty = true;
    <#list idAttrs as idAttr>
    if (!Strings.isBlank(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}())) {
      areAllIdsEmpty = false;
    }
    </#list>
    if (areAllIdsEmpty) {
      throw new ServiceException(400, "缺少必要的参数：${idAttrs?map(att->modelbase.get_attribute_sql_name(att))?join(",")}");
    }
    try {
      results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query);  
    } catch (Throwable cause) {
      throw new ServiceException(500, "查询${typeDef.label!""}失败", cause);
    }
    if (results == null || results.size() == 0) {
      throw new ServiceException(404, "没有找到【${modelbase.get_object_label(obj)}】对象实例。");
    }
    if (results.size() > 1) {
      throw new ServiceException(400, "找到多个【${modelbase.get_object_label(obj)}】对象实例，请检查查询条件。");
    }
    retVal = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(results.get(0));
  <#elseif typeRefType == "AREF">
    <#assign idAttrs = modelbase.get_id_attributes(model.findObjectByName(typeObj.name))>
    ${java.nameVariable(typeObj.variable)}Query = new ${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.variable)}Query.set${java.nameType(modelbase.get_attribute_sql_name(idAttrs?first))}(query.${modelbase4java.name_getter(idAttrs?first, typeObj.variable)}());
    ${java.nameVariable(typeObj.variable)}Query = ${java.nameVariable(typeObj.variable)}Service.get${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
    retVal.from${java.nameType(typeObj.name)}Query(${java.nameVariable(typeObj.variable)}Query);
  <#elseif typeRefType == "PREF">
    <#if typeObj.reference??>
      <#assign leftAttr = typeObj.getLeftAttributeFromReference()>
      <#assign rightAttr = typeObj.getRightAttributeFromReference()>
    ${java.nameVariable(typeObj.variable)}Query = new ${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.variable)}Query.set${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}(query.${modelbase4java.name_getter(leftAttr)}());
    ${java.nameVariable(typeObj.variable)}Query = ${java.nameVariable(typeObj.variable)}Service.get${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
    retVal.set${java.nameType(typeObj.variable)}(${java.nameVariable(typeObj.variable)}Query);
    <#else>
    ${java.nameVariable(typeObj.variable)}Query = new ${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.variable)}Query = ${java.nameVariable(typeObj.variable)}Service.get${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
    retVal.set${java.nameType(typeObj.variable)}(${java.nameVariable(typeObj.variable)}Query);
    </#if>
  <#elseif typeRefType == "CREF">
    <#assign leftAttr = typeObj.getLeftAttributeFromReference()>
    <#assign rightAttr = typeObj.getRightAttributeFromReference()>
    ${java.nameVariable(typeObj.variable)}Query = new ${java.nameType(typeObj.name)}Query();
    <#-- 注意此处这个补丁 -->
    <#if modelbase.match_aggregate_attribute(typeDef.definition, leftAttr)??>
      <#assign leftAttr = modelbase.match_aggregate_attribute(typeDef.definition, leftAttr)>
    </#if>  
    ${java.nameVariable(typeObj.variable)}Query.set${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}(query.${modelbase4java.name_getter(leftAttr)}());
    
    ${java.nameVariable(typeObj.variable)}Queries = ${java.nameVariable(typeObj.variable)}Service.find${java.nameType(inflector.pluralize(typeObj.variable))}(${java.nameVariable(typeObj.variable)}Query).getData();
    retVal.from${java.nameType(typeObj.name)}Queries(${java.nameVariable(typeObj.variable)}Queries);
  </#if>
</#list>
    return retVal;
  }

  /**
   * 读取【${typeDef.label!""}】对象实例
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 【${typeDef.label!""}】对象实例
   */
  public ${java.nameType(typeDef.name)}Query get${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
    ${java.nameType(typeDef.name)}Query retVal = new ${java.nameType(typeDef.name)}Query();
    List<Map<String, Object>> results = null;
<@print_variables flow />
<#list flow.types as typeObj>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#if typeRefType == "SREF">
    try {
      results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query);  
    } catch (Throwable cause) {
      throw new ServiceException(500, "查询${typeDef.label!""}失败", cause);
    }
    if (results == null || results.size() == 0) {
      return null;
    }
    retVal = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(results.get(0));
  <#elseif typeRefType == "AREF">
    ${java.nameVariable(typeObj.variable)}Query = query.to${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.variable)}Query = ${java.nameVariable(typeObj.variable)}Service.get${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
    retVal.from${java.nameType(typeObj.name)}Query(${java.nameVariable(typeObj.variable)}Query);  
  <#elseif typeRefType == "PREF">
    <#assign idAttr = modelbase.get_id_attributes(model.findObjectByName(typeObj.name))?first>
    ${java.nameVariable(typeObj.variable)}Query = new ${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.variable)}Query.${modelbase4java.name_setter(idAttr)}(query.${modelbase4java.name_getter(idAttr, typeObj.variable)}());
    ${java.nameVariable(typeObj.variable)}Query = ${java.nameVariable(typeObj.variable)}Service.get${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
    retVal.set${java.nameType(typeObj.variable)}(${java.nameVariable(typeObj.variable)}Query);
  <#elseif typeRefType == "CREF">  
    // TODO
  </#if>
</#list>
    return retVal;
  }

  /**
   * 查询符合条件的【${typeDef.label!""}】对象实例列表
   *
   * @param query
   *        查询条件
   * @return 符合条件的【${typeDef.label!""}】对象实例列表
   */
  public Pagination<${java.nameType(typeDef.name)}Query> find${java.nameType(inflector.pluralize(typeDef.name))}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
    <#------------------->    
    <#-- 涉及到的变量定义 -->
    <#------------------->
    Pagination<${java.nameType(typeDef.name)}Query> retVal = new Pagination<>();
    List<Map<String, Object>> results = null;
<@print_variables flow />
<#list flow.types as typeObj>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#if typeRefType == "SREF">
    RowBounds rowBounds = new RowBounds(query.getStart(), query.getLimit() == -1 ? Integer.MAX_VALUE : query.getLimit());
    try {
      results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query, rowBounds);  
    } catch (Throwable cause) {
      throw new ServiceException(500, "查询${typeDef.label!""}失败", cause);
    }
    if (results == null || results.size() == 0) {
      return retVal;
    }
    for (Map<String, Object> row : results) {
      retVal.getData().add(${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(row));   
    }
  <#elseif typeRefType == "AREF">
    ${java.nameVariable(typeObj.variable)}Query = query.to${java.nameType(typeObj.name)}Query();
    <#if typeObj.reference??>
      <#assign leftAttr = typeObj.getLeftAttributeFromReference()>
      <#assign rightAttr = typeObj.getRightAttributeFromReference()>
      <#-- TODO: 继续查询 -->
    <#else>
      <#assign idAttr = modelbase.get_id_attributes(model.findObjectByName(typeObj.name))?first>
    </#if>
    ${java.nameVariable(typeObj.variable)}Queries = ${java.nameVariable(typeObj.name)}Service.find${java.nameType(typeObj.definition.plural)}(${java.nameVariable(typeObj.variable)}Query).getData();
    <#if typeObj?index == 0>
      <#list flow.types as innerTypeObj>
        <#if innerTypeObj?index == 0><#continue></#if>
    ${java.nameVariable(innerTypeObj.variable)}Query = new ${java.nameType(innerTypeObj.name)}Query();    
      </#list>
    for (${java.nameType(typeObj.name)}Query row : ${java.nameVariable(typeObj.variable)}Queries) {
      <#list flow.types as innerTypeObj>
        <#if innerTypeObj?index == 0><#continue></#if>
        <#assign innerTypeObjIdAttr = modelbase.get_id_attributes(model.findObjectByName(innerTypeObj.name))?first>
        <#if innerTypeObj.reference??>
          <#assign innerTypeObjLeftAttr = innerTypeObj.getLeftAttributeFromReference()>
          <#assign innerTypeObjRightAttr = innerTypeObj.getRightAttributeFromReference()>
      ${java.nameVariable(innerTypeObj.variable)}Query.add${java.nameType(modelbase.get_attribute_sql_name(innerTypeObjRightAttr))}(row.${modelbase4java.name_getter(innerTypeObjLeftAttr)}());
        <#else>
      ${java.nameVariable(innerTypeObj.variable)}Query.add${java.nameType(modelbase.get_attribute_sql_name(innerTypeObjIdAttr))}(row.${modelbase4java.name_getter(innerTypeObjIdAttr)}());
        </#if>
      </#list>
    }
      <#-- TODO: 继续查询 -->
    </#if>
  <#elseif typeRefType == "PREF">
    <#if !typeObj.getLeftAttributeFromReference()??><#continue></#if>
    ${java.nameVariable(typeObj.variable)}Queries = ${java.nameVariable(typeObj.variable)}Service.find${inflector.pluralize(java.nameType(typeObj.name))}(${java.nameVariable(typeObj.variable)}Query).getData();
    for (${java.nameType(typeObj.name)}Query row : ${java.nameVariable(typeObj.variable)}Queries) {
      for (${java.nameType(typeDef.name)}Query retRow : retVal.getData()) {
        <#assign leftAttr = typeObj.getLeftAttributeFromReference()>
        <#assign rightAttr = typeObj.getRightAttributeFromReference()>
        if (row.${modelbase4java.name_getter(rightAttr)}().equals(retRow.${modelbase4java.name_getter(leftAttr)}())) {
          retRow.set${java.nameType(typeObj.variable)}(row);
          break;
        }
      }
    }
  <#elseif typeRefType == "CREF" && typeDef.definition.isLabelled("meta")>
    ${java.nameVariable(typeObj.variable)}Queries = ${java.nameVariable(typeObj.variable)}Service.find${java.nameType(inflector.pluralize(typeObj.name))}(${java.nameVariable(typeObj.variable)}Query).getData();
    for (${java.nameType(typeObj.name)}Query row : ${java.nameVariable(typeObj.variable)}Queries) {
      for (${java.nameType(typeDef.name)}Query retRow : retVal.getData()) {
        <#assign leftAttr = typeObj.getLeftAttributeFromReference()>
        <#assign rightAttr = typeObj.getRightAttributeFromReference()>
        if (row.${modelbase4java.name_getter(rightAttr)}().equals(retRow.${modelbase4java.name_getter(leftAttr)}())) {
          retRow.from${java.nameType(typeObj.name)}Query(row);
          break;
        }
      }
    }
  </#if>  
</#list>
    return retVal;
  }

  /**
   * 删除【${typeDef.label!""}】对象实例
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   */
  @Transactional(rollbackOn = Exception.class)
  public void delete${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
<#list flow.types as typeObj>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#if typeRefType == "SREF">
    <#------------->
    <#-- 参数校验 -->
    <#------------->
    boolean areAllIdsEmpty = true;
    <#list idAttrs as idAttr>
    if (!Strings.isBlank(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}())) {
      areAllIdsEmpty = false;
    }
    </#list>
    if (areAllIdsEmpty) {
      throw new ServiceException(400, "缺少必要的参数：${idAttrs?map(att->modelbase.get_attribute_sql_name(att))?join(",")}");
    }
    try {
      ${java.nameVariable(typeDef.name)}DataAccess.delete${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Assembler.assemble${java.nameType(typeDef.name)}FromQuery(query));  
    } catch (Throwable cause) {
      throw new ServiceException(500, "删除${typeDef.label!""}失败", cause);
    }
  <#elseif typeRefType == "AREF">
    ${java.nameVariable(typeObj.variable)}Service.delete${java.nameType(typeObj.name)}(query.to${java.nameType(typeObj.name)}Query());
  <#elseif typeRefType == "PREF">
    <#assign idAttr = modelbase.get_id_attributes(model.findObjectByName(typeObj.name))?first>
    ${java.nameType(typeObj.name)}Query ${java.nameVariable(typeObj.variable)}Query = new ${java.nameType(typeObj.name)}Query();
    <#if typeObj.reference??>
      <#assign leftAttr = typeObj.getLeftAttributeFromReference()>
      <#assign rightAttr = typeObj.getRightAttributeFromReference()>
    if (query.${modelbase4java.name_getter(leftAttr)}() != null) {
      ${java.nameVariable(typeObj.variable)}Query.set${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}(query.${modelbase4java.name_getter(leftAttr)}());
      ${java.nameVariable(typeObj.variable)}Service.delete${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);  
    }  
    <#else>
    ${java.nameVariable(typeObj.variable)}Query.${modelbase4java.name_setter(idAttr)}(query.${modelbase4java.name_getter(idAttr, typeObj.variable)}());
    </#if>
  <#elseif typeRefType == "CREF">
    <#assign dataObj = model.findObjectByName(typeObj.name)>
    List<${java.nameType(typeObj.name)}Query> ${java.nameVariable(typeObj.variable)}Queries = query.to${java.nameType(typeObj.name)}Queries();
    for (${java.nameType(typeObj.name)}Query ${java.nameVariable(typeObj.variable)}Query : ${java.nameVariable(typeObj.variable)}Queries) {
      ${java.nameVariable(typeObj.variable)}Service.delete${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.variable)}Query);
    }
  </#if>
</#list>  
  }
}
