<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", obj, model)>
<#assign flow = typeDef.flow>
<#assign idFields = typeDef.getIdentifiableFields()>
<#assign idAttrs = []>
<#list idFields as idField>
  <#if !idField.definition??>
    <#stop "无法找到【${modelbase.get_object_label(obj)}】对象的标识属性，请检查数据模型定义。">
  </#if>
  <#assign idAttrs += [idField.definition]>
</#list>
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

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.*;
import org.springframework.transaction.annotation.*;
import org.springframework.stereotype.*;

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
@Service("<#if namespace??>${namespace}.</#if>${app.name}.service.${java.nameType(typeDef.name)}Service") 
public class ${java.nameType(typeDef.name)}ServiceImpl extends QueryHandlerService implements ${java.nameType(typeDef.name)}Service {
 <#list flow.types as typeObj>
  <#------------------------------------------->
  <#-- 说明当前的类型定义就是数据对象，这个非常重要 -->
  <#------------------------------------------->
  <#if typeDef.persistence && typeDef.name == typeObj.name>

  @Inject
  private ${java.nameType(typeDef.name)}DataAccess ${java.nameVariable(typeDef.name)}DataAccess;

  @Inject
  private ${java.nameType(typeDef.name)}Validation ${java.nameVariable(typeDef.name)}Validation;
  <#elseif typeDef.name != typeObj.name>

  @Inject
  private ${java.nameType(typeObj.name)}Service ${java.nameVariable(typeObj.name)}Service;
  </#if>
</#list>   

  /**
   * 保存【${typeDef.label!""}】对象实例
   *
   * @param query
   *        【${typeDef.label!""}】对象查询条件
   *
   * @return 保存后的【${typeDef.label!""}】对象查询条件，包含了标识属性等默认值
   */
  @Transactional(readOnly = false, rollbackFor = Exception.class)
  public ${java.nameType(typeDef.name)}Query save${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
<#------------------->    
<#-- 涉及到的变量定义 -->
<#------------------->      
<#list flow.types as typeObj>
    ${java.nameType(typeObj.name)}Query ${java.nameVariable(typeObj.name)}Query = null;
</#list>
    boolean existing = true;
<#list flow.types as typeObj>
  <#if typeDef.persistence && typeDef.name == typeObj.name>
    <#---------------------------------------------------->
    <#-- 这个意味着是妥妥的数据对象，就是这个服务类的主要操作对象 -->
    <#---------------------------------------------------->
    <#------------------------------------------------------------------------------------>
    <#-- 1. 验证标识属性是否有值，如果没有则认为是新数据需要生成标识值，如果有则认为是已有数据需要更新 -->
    <#------------------------------------------------------------------------------------>
    <#list idAttrs as idAttr>    
    ${modelbase4java.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)} = query.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}();
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
    ValidationResult res = ${java.nameVariable(typeObj.name)}Validation.validate(query, !existing);
    if (!res.isValid()) {
      throw new ServiceException(res.getCode(), res.getMessage());
    }
  <#elseif !typeDef.persistence && typeDef.name != typeObj.name>
    <#---------------------------------------------------------------------------------------->
    <#-- 类型对象是非持久化的，说明这个对象可能是聚合对象（aggregate root）、合成对象（composite row） -->
    <#-- 或者是非持久化的数据对象 （data object），最后一个也是重点对象。                            -->
    <#---------------------------------------------------------------------------------------->
    <#if typeObj.collection>
    // TODO: 建立关联关系
    ${java.nameVariable(typeObj.name)}Service.save${java.nameType(inflector.pluralize(typeObj.name))}(null/* TODO */);
    <#else>
    // TODO: 建立关联关系
    ${java.nameVariable(typeObj.name)}Query = query.to${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.name)}Service.save${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.name)}Query);
    </#if>
  <#elseif typeDef.persistence && typeDef.name != typeObj.name>
    <#------------------------------------------------------------------------------------>
    <#-- 类型对象是持久化的，说明是数据对象的包装，通过variable（实际上就是属性名称）在父对象中获得它 -->
    <#------------------------------------------------------------------------------------>
    if (query.get${java.nameType(typeObj.variable)}() != null) {
    <#--  <#assign refObjIdAttr = typeObj.getIdentifiableAttribute()>
    <#assign attrRefObj = typeDef.getAttributeByName(typeObj.variable)>  -->
      ${java.nameVariable(typeObj.name)}Query = query.get${java.nameType(typeObj.variable)}();
      ${java.nameVariable(typeObj.name)}Service.save${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.name)}Query);
      <#--  query.set${modelbase4java.name_setter(attrRefObj)}Query.get${modelbase4java.name_getter(refObjIdAttr)}());  -->
    }
  </#if>
  <#if typeDef.persistence>
    <#------------------------------------------------------>
    <#-- 4. 插入或者更新主要对象的数据，方法末尾才调用对自身的保存 -->
    <#------------------------------------------------------>
    ${java.nameType(typeObj.name)} ${java.nameVariable(typeDef.name)} = ${java.nameType(typeObj.name)}Assembler.assemble${java.nameType(typeDef.name)}FromQuery(query);
    if (!existing) {
      ${java.nameVariable(typeObj.name)}DataAccess.insert${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.name)});
    } else {
      ${java.nameVariable(typeDef.name)}DataAccess.updatePartial${java.nameType(typeDef.name)}(${java.nameVariable(typeDef.name)});      
    }
  </#if>
</#list>   
  }
  
  /**
   * 读取【${typeDef.label!""}】对象实例
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 【${typeDef.label!""}】对象实例
   */
  public ${typeDef.name}Query read${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
<#------------->    
<#-- 变量定义 -->
<#------------->    
    ${java.nameType(typeDef.name)}Query retVal = null;
    List<Map<String, Object>> results = null;
<#list flow.types as typeObj>
    ${java.nameType(typeObj.name)}Query ${java.nameVariable(typeObj.name)}Query = null;
</#list>
<#list flow.types as typeObj>
    ${java.nameType(typeObj.name)} ${java.nameVariable(typeObj.name)} = null;
</#list>
<#list flow.types as typeObj>
  <#if typeDef.persistence && typeDef.name == typeObj.name>      
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
      throw new ServiceException("400", "缺少必要的参数：${idAttrs?map(att->modelbase.get_attribute_sql_name(att))?join(",")}");
    }
    <#------------------>    
    <#-- 主要对象的查询 -->    
    <#------------------>
    try {
      results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query);  
    } catch (Throwable cause) {
      throw new ServiceException("500", "查询${typeDef.label!""}失败", cause);
    }
    if (results == null || results.size() == 0) {
      throw new ServiceException(404, "没有找到【${modelbase.get_object_label(obj)}】对象实例。");
    }
    if (results.size() > 1) {
      throw new ServiceException(400, "找到多个【${modelbase.get_object_label(obj)}】对象实例，请检查查询条件。");
    }
    retVal = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(results.get(0));
    <#break>
  <#elseif typeDef.name != typeObj.name>
    <#assign typeRef = typeObj.reference>
    <#assign leftAttr = typeRef.getLeftAttributeFromReference()>
    <#assign rightAttr = typeRef.getRightAttributeFromReference()>
    ${java.nameVariable(typeObj.name)}Query = new ${java.nameType(typeObj.name)}Query();
    ${java.nameVariable(typeObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}(${java.nameType(leftAttr.parent.name)}Query.get${java.nameType(modelbase.get_attribute_sql_name(leftAttr))}());
    <#if typeObj.collection>
    ${java.nameVariable(inflector.pluralize(typeObj.name))} = ${java.nameVariable(typeObj.name)}Service.find${java.nameType(inflector.pluralize(typeObj.name))}(${java.nameVariable(typeObj.name)}Query);
    retVal.get${java.nameType(inflector.pluralize(typeObj.name))}().addAll(${java.nameVariable(inflector.pluralize(typeObj.name))});
    <#else>
    ${java.nameVariable(typeObj.name)} = ${java.nameVariable(typeObj.name)}Service.read${java.nameType(typeObj.name)}(${java.nameVariable(typeObj.name)}Query.get${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}());
    retVal.from${java.nameType(typeObj.name)}Query(${java.nameVariable(typeObj.name)});
    </#if>
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
  public List<${java.nameType(typeDef.name)}Query> find${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
    <#------------------->    
    <#-- 涉及到的变量定义 -->
    <#------------------->
    List<${java.nameType(typeDef.name)}Query> retVal = new ArrayList<>();
    List<Map<String, Object>> results = null;
<#list flow.types as typeObj>
    ${java.nameType(typeObj.name)}Query ${java.nameVariable(typeObj.name)}Query = null;
</#list>
<#list flow.types as typeObj>
    ${java.nameType(typeObj.name)} ${java.nameVariable(typeObj.name)} = null;
</#list>
<#list flow.types as typeObj>
  <#if typeDef.persistence>       
    <#------------------>    
    <#-- 主要对象的查询 -->    
    <#------------------>
    try {
      results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query);  
    } catch (Throwable cause) {
      throw new ServiceException("500", "查询${typeDef.label!""}失败", cause);
    }
    if (results == null || results.size() == 0) {
      throw new ServiceException(404, "没有找到【${modelbase.get_object_label(obj)}】对象实例。");
    }
    if (results.size() > 1) {
      throw new ServiceException(400, "找到多个【${modelbase.get_object_label(obj)}】对象实例，请检查查询条件。");
    }
    ${java.nameVariable(typeDef.name)} = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(results.get(0));
    <#break>
  <#else>
    <#assign typeRef = typeObj.reference>
    <#assign leftAttr = typeRef.getLeftAttributeFromReference()>
    <#assign rightAttr = typeRef.getRightAttributeFromReference()>
    ${java.nameVariable(typeObj.name)}Query = new ${java.nameType(typeObj.name)}Query();
    for (${java.nameType(leftAttr.parent.name)}Query row : ${java.nameVariable(inflector.pluralize(leftAttr.parent.name))}) {
      ${java.nameVariable(typeObj.name)}Query.add${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}(row.get${java.nameType(modelbase.get_attribute_sql_name(leftAttr))}());
    }
    ${java.nameVariable(inflector.pluralize(typeObj.name))} = ${java.nameVariable(typeObj.name)}Service.find${java.nameType(inflector.pluralize(typeObj.name))}(${java.nameVariable(typeObj.name)}Query.get${java.nameType(modelbase.get_attribute_sql_name(rightAttr))}());
    <#-- TODO -->
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
  @Transactional(readOnly = false, rollbackFor = Exception.class)
  public void delete${java.nameType(typeDef.name)}(${java.nameType(typeDef.name)}Query query) throws ServiceException {
<#list flow.types as typeObj>
  <#if typeDef.persistence>               
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
      throw new ServiceException("400", "缺少必要的参数：${idAttrs?map(att->modelbase.get_attribute_sql_name(att))?join(",")}");
    }
    try {
      ${java.nameVariable(typeDef.name)}DataAccess.delete${java.nameType(typeDef.name)}(query);  
    } catch (Throwable cause) {
      throw new ServiceException("500", "删除${typeDef.label!""}失败", cause);
    }
    <#break>
  <#else>
    ${typeObj.name}Service.delete${java.nameType(typeObj.name)}(query.to${java.nameType(typeObj.name)}Query());
    <#break>  
  </#if>
</#list>  
  }
}
