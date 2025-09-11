<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service.impl;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
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

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign groupUniqueAttrs = modelbase.get_group_unique_attributes(obj)>
<#assign uniqueGroups = modelbase.group_unique_attributes(obj)>
<#assign extObjs = modelbase.get_extension_objects(obj)>
<#assign existingObjs = {}>
<#assign existingDaos = {}>
/**
 * 【${modelbase.get_object_label(obj)}】存储事务化的服务实现。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
@Service("<#if namespace??>${namespace}.</#if>${app.name}.service.${typename}Service") 
@Transactional
public class ${typename}ServiceImpl extends QueryHandlerService implements ${typename}Service {
<#if obj.isLabelled("pivot")>
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign existingObjs += {masterObj.name:masterObj}>
  </#if>
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#assign existingObjs += {detailObj.name:detailObj}>
  <#if obj.getLabelledOptions("pivot")["master"]?? && !existingDaos[masterObj.name]??>
    <#assign existingDaos += {masterObj.name: masterObj}>
    
  @Autowired
  ${java.nameType(masterObj.name)}DataAccess ${java.nameVariable(masterObj.name)}DataAccess;
  </#if>
  <#if !existingDaos[detailObj.name]??>
    <#assign existingDaos += {detailObj.name: detailObj}>
    
  @Autowired
  ${java.nameType(detailObj.name)}DataAccess ${java.nameVariable(detailObj.name)}DataAccess;
  
  @Autowired
  ${java.nameType(detailObj.name)}Service ${java.nameVariable(detailObj.name)}Service;
  </#if>
<#else>
  <#assign existingObjs += {obj.name:obj}>
  <#if !existingDaos[obj.name]??>
    <#assign existingDaos += {obj.name: obj}>
    
  @Autowired
  ${java.nameType(obj.name)}DataAccess ${java.nameVariable(obj.name)}DataAccess;
  </#if>
</#if>    

  @Autowired
  ReferenceService referenceService;
<#-- 一对一显示扩展 -->
<#list extObjs?keys as extObjName>
  <#assign extObj = model.findObjectByName(extObjName)>
  <#assign existingObjs += {extObj.name:extObj}>
  <#if !existingDaos[extObj.name]??>
    <#assign existingDaos += {extObj.name: obj}>
    
  @Autowired
  ${java.nameType(extObj.name)}DataAccess ${java.nameVariable(extObj.name)}DataAccess;
  </#if>
</#list>  
<#-- 一对一元型扩展 -->
<#if obj.isLabelled("meta")>

  @Autowired
  ${java.nameType(obj.name)}MetaDataAccess ${java.nameVariable(obj.name)}MetaDataAccess;
</#if>
<@modelbase4java.print_object_o2m_members obj=obj existings=existingObjs/> 
<@modelbase4java.print_object_o2o_members obj=obj existings=existingObjs/>    
  
  @Autowired
  ${typename}Validation ${varname}Validation;    
<#---------------->
<#-- 观察扩展成员 -->
<#---------------->
<#list model.objects as innerObj>
  <#list innerObj.attributes as attr>
    <#if modelbase.has_observer_for_attribute(innerObj, attr) && 
         !existingObjs[innerObj.name]?? &&
         attr.type.componentType.name == obj.name>
      <#assign existingObjs += {innerObj.name:innerObj}>
      
  @Autowired
  private ${java.nameType(innerObj.name)}DataAccess ${java.nameVariable(innerObj.name)}DataAccess;     
    </#if>
  </#list>
</#list>

  /**
   * 批处理（插入、更新、删除）【${modelbase.get_object_label(obj)}】对象，专门针对集合数据。
   */
  public void batch${inflector.pluralize(typename)}(${typename}Query existingQuery, List<String> compareFields, List<${typename}Query> queries) throws ServiceException {
    existingQuery.setLimit(-1);
    Pagination<${typename}Query> existing = find${inflector.pluralize(typename)}(existingQuery);
    // 先判断是否需要删除已经持久化的数据
    for (${typename}Query persisted : existing.getData()) {
      boolean found = false;
      for (${typename}Query editing : queries) {
        if (editing == persisted) {
          found = true;
          break;
        }
      }
      if (!found) {
        delete${typename}(persisted);
      }
    }
    // 在判断用户编辑集合中，是否已经持久化，持久化的就更新，未持久化的就插入
    for (${typename}Query editing : queries) {
      ${typename}Query found = null;
      for (${typename}Query persisted : existing.getData()) {
        if (persisted.compareTo(editing, compareFields) == 0) {
          found = persisted;
          break;
        }
      }
      if (found != null) {
<#list idAttrs as idAttr>
        editing.set${java.nameType(modelbase.get_attribute_sql_name(idAttr))}(found.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}());
</#list>        
        modify${typename}(editing);
      } else {
        ${typename}Query.setDefaultValues(editing);
<#if obj.isLabelled("pivot")>   
        save${typename}(editing);   
<#else>  
        create${typename}(editing);
</#if>        
      }
    }
  }
  
  <#-- 【保存】部分 -->
<#include "/$/service/save.ftl">
<#if obj.persistenceName??>
  
  @Override
  @Transactional(rollbackFor = Throwable.class)
  public ${typename}Query create${typename}(${typename}Query query) throws ServiceException {
    if (query == null) {
      return null;
    }
    ValidationResult res = ${varname}Validation.validate(query);
    if (!res.isValid()) {
      throw new ServiceException(res.getCode(), res.getMessage());
    }
    try {
<#if obj.isLabelled("pivot")>    
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
<#-- 行列对象的创建 -->
<@modelbase4java.print_object_entity_create obj=obj indent=6 />  
<#elseif idAttrs?size == 1> 
<#-- 实体对象的创建 -->     
<@modelbase4java.print_object_entity_create obj=obj indent=6 />
<#else>     
<#-- 值体对象的创建 -->    
<@modelbase4java.print_object_value_create obj=obj indent=6 />    
</#if>     
      return query;
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  }
  
  /**
   * 修改【${modelbase.get_object_label(obj)}】对象的部分信息，全部更新，如果没有值的属性则置为空。
   */
  @Override
  @Transactional(rollbackFor = Throwable.class)
  public ${typename}Query update${typename}(${typename}Query query) throws ServiceException {
    if (query == null) {
      return null;
    }
    ValidationResult res = ${varname}Validation.validate(query);
    if (!res.isValid()) {
      throw new ServiceException(res.getCode(), res.getMessage());
    }
    try {
<#if obj.isLabelled("pivot")>    
  <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
<#-- 行列对象的创建 -->
<@modelbase4java.print_object_entity_update obj=obj indent=6 />  
<#elseif idAttrs?size == 1> 
<#-- 实体对象的创建 -->     
<@modelbase4java.print_object_entity_update obj=obj indent=6 />
<#else>     
<#-- 值体对象的创建 -->    
<@modelbase4java.print_object_value_update obj=obj indent=6 />    
</#if>
      return query; 
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }    
  }
</#if>
  
  /**
   * 修改【${modelbase.get_object_label(obj)}】对象的部分信息，不更新空值属性。
   */
  @Override
  @Transactional(rollbackFor = Throwable.class)
  public ${typename}Query modify${typename}(${typename}Query query) throws ServiceException {
    if (query == null) {
      return null;
    }
    ValidationResult res = ${varname}Validation.validate(query);
    if (!res.isValid()) {
      throw new ServiceException(res.getCode(), res.getMessage());
    }
    try {
<#if obj.isLabelled("pivot")>    
<#-- 行列对象的创建 -->
<@modelbase4java.print_object_entity_update obj=obj indent=6 />  
<#elseif idAttrs?size == 1> 
<#-- 实体对象的创建 -->     
<@modelbase4java.print_object_entity_update obj=obj indent=6 />
<#else>     
<#-- 值体对象的创建 -->    
<@modelbase4java.print_object_value_update obj=obj indent=6 />    
</#if>
      transact(query);
      return query; 
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }    
  }
      
  /**
   * 查找多个【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public Pagination<${typename}Query> find${inflector.pluralize(typename)}(${typename}Query query) throws ServiceException {
    Pagination<${typename}Query> retVal = new Pagination<>();
<#if obj.isLabelled("pivot")>  
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#assign existingObjs += {detailObj.name:detailObj}> 
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign existingObjs += {masterObj.name:masterObj}>
    ${js.nameType(masterObj.name)}Query ${js.nameVariable(masterObj.name)}Query = new ${js.nameType(masterObj.name)}Query();
    try {    
      List<Map<String,Object>> results;
      if (query.getLimit() == -1) {
        results = ${js.nameVariable(masterObj.name)}DataAccess.select${js.nameType(masterObj.name)}(${js.nameVariable(masterObj.name)}Query);
      } else {
        RowBounds rowBounds = new RowBounds(query.getStart(), query.getLimit());
        results = ${js.nameVariable(masterObj.name)}DataAccess.select${js.nameType(masterObj.name)}(${js.nameVariable(masterObj.name)}Query, rowBounds);
      }
      long total = ${js.nameVariable(masterObj.name)}DataAccess.selectCountOf${js.nameType(masterObj.name)}(${js.nameVariable(masterObj.name)}Query);
      retVal.setTotal(total);
      for (Map<String,Object> res : results) {
        retVal.getData().add(${typename}QueryAssembler.assemble${typename}Query(res));
      }
      hierarchize(retVal.getData(), query);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  <#else>
    <#-- TODO: 是否支持对不拥有master的pivot对象 -->
  </#if> 
<#else> 
    try {    
      List<Map<String,Object>> results;
      if (query.getLimit() == -1) {
        results = ${varname}DataAccess.select${typename}(query);
      } else {
        RowBounds rowBounds = new RowBounds(query.getStart(), query.getLimit());
        results = ${varname}DataAccess.select${typename}(query, rowBounds);
      }
      long total = ${varname}DataAccess.selectCountOf${typename}(query);
      retVal.setTotal(total);
      for (Map<String,Object> res : results) {
        retVal.getData().add(${typename}QueryAssembler.assemble${typename}Query(res));
      }
      hierarchize(retVal.getData(), query);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
</#if> 
    return retVal;
  }
  
  <#--
   ### 完整对象的读取：
   ###    包括一对一扩展的读取，集合子属性的读取 
   -->
  /**
   * 读取一个【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public ${typename}Query read${typename}(${typename}Query query) throws ServiceException {
<@modelbase4java.print_object_entity_read obj=obj indent=4 />
<#if obj.isLabelled("extension")>
<@modelbase4java.print_object_extension_read obj=obj indent=4 />
</#if> 
<#if obj.isLabelled("meta")>
<@modelbase4java.print_object_meta_read obj=obj indent=4 />  
</#if>
<#if obj.isLabelled("pivot")>
<@modelbase4java.print_object_pivot_read obj=obj indent=4 />   
</#if> 
<#if idAttrs?size == 1 && idAttrs[0].type.custom>
<@modelbase4java.print_object_o2o_read obj=obj root=obj indent=4 />   
</#if> 
<#------------------------->
<#-- 通用：含有集合对象属性 -->    
<#------------------------->
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
    ${java.nameType(attr.type.componentType.name)}Query ${modelbase4java.singularize_coll_attr(attr)}Query = new ${java.nameType(attr.type.componentType.name)}Query();
  <#list collObj.attributes as collObjAttr>
    <#if obj.name == collObjAttr.type.name>
    ${modelbase4java.singularize_coll_attr(attr)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
    </#if>
  </#list>
    // 封装关联的【${modelbase.get_object_label(collObj)}】集合数据  
    List<Map<String,Object>> ${java.nameVariable(attr.name)} = ${java.nameVariable(attr.type.componentType.name)}DataAccess.select${java.nameType(attr.type.componentType.name)}(${modelbase4java.singularize_coll_attr(attr)}Query);
    for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
      retVal.get${java.nameType(attr.name)}().add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
    }
  <#-- TODO:  -->  
  <#-- 规则1：如果集合对象是值域对象，则需要查找下一级的非父对象的引用对象的集合 -->
  <#-- 规则2（可能有BUG）：如果集合对象是实体对象，则需要通过属性中conjunction的定义，查找关联的实体对象集合 -->
  <#if collObj.isLabelled("value")>
    <#list collObj.attributes as collObjAttr>
      <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if>
      <#assign collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)>
      <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
    // 封装关联中明细的【${modelbase.get_object_label(collObjAttrRefObj)}】数据  
    Set<${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)}> ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids = new HashSet<>();
    for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
      ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids.add((${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)})row.get("${modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)}"));
    }
    ${java.nameType(collObjAttrRefObj.name)}Query ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query = new ${java.nameType(collObjAttrRefObj.name)}Query();
    ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query.setLimit(-1);
    ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query.get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)))}().addAll(${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids);
    Pagination<${java.nameType(collObjAttrRefObj.name)}Query> ${java.nameVariable(attr.name)}${java.nameType(modelbase.get_object_plural(obj))} = ${java.nameVariable(collObjAttrRefObj.name)}Service.find${java.nameType(modelbase.get_object_plural(collObjAttrRefObj))}(${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query);
    for (${java.nameType(collObjAttrRefObj.name)}Query row : ${java.nameVariable(attr.name)}${java.nameType(modelbase.get_object_plural(obj))}.getData()) {
      for (${java.nameType(collObj.name)}Query innerRow : retVal.get${java.nameType(attr.name)}()) {
        if (innerRow.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}().equals(row.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}())) {
          innerRow.set${java.nameType(collObjAttr.name)}(row);
          break;
        }
      }
    }
    </#list>
  <#elseif collObj.isLabelled("entity")>
  </#if> 
</#list>
    hierarchize(retVal, query);
<#-- REFERENCE -->    
<#list obj.attributes as attr>
    <#if attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
      <#assign referenceName = attr.getLabelledOptions("reference")["name"]>
    <#if !modelbase.get_reference_type_attribute(obj, referenceName)??><#continue></#if>
      <#assign refTypeAttr = modelbase.get_reference_type_attribute(obj, referenceName)>
    ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)} = retVal.get${java.nameType(modelbase.get_attribute_sql_name(attr))}();
    ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(refTypeAttr)} = retVal.get${java.nameType(modelbase.get_attribute_sql_name(refTypeAttr))}();
    retVal.set${java.nameType(referenceName)}(referenceService.readReference(${modelbase.get_attribute_sql_name(attr)}, ${modelbase.get_attribute_sql_name(refTypeAttr)}));  
    </#if>
  </#list>    
    return retVal;
  }
  
  /**
   * 聚合统计【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public Pagination<${typename}Query> aggregate${typename}(${typename}Query query) throws ServiceException {
    Pagination<${typename}Query> retVal = new Pagination<>();
<#if obj.isLabelled("pivot")> 
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign existingObjs += {masterObj.name:masterObj}>
  </#if>  
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#assign existingObjs += {detailObj.name:detailObj}>
    return retVal;
<#else>   
    try {    
      List<Map<String,Object>> results = ${varname}DataAccess.selectAggregateOf${typename}(query);
      for (Map<String,Object> row : results) {
        retVal.getData().add(${typename}QueryAssembler.assemble${typename}Query(row));
      }
      return retVal;
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
</#if> 
  }
  
  /**
   * 删除（物理删除）【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public void delete${typename}(${typename}Query query) throws ServiceException {
<#if obj.isLabelled("pivot")>
  <#if obj.getLabelledOptions("pivot")["master"]??>    
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
    <#assign masterObjIdAttr = modelbase.get_id_attributes(masterObj)[0]>
    try {    
      ${java.nameType(masterObj.name)} ${java.nameVariable(masterObj.name)} = new ${java.nameType(masterObj.name)}();
      ${java.nameVariable(masterObj.name)}.set${java.nameType(masterObjIdAttr.name)}(query.get${java.nameType(modelbase.get_attribute_sql_name(masterObjIdAttr))}());
      ${java.nameVariable(masterObj.name)}DataAccess.delete${java.nameType(masterObj.name)}(${java.nameVariable(masterObj.name)});
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  </#if>  
<#else>
    try {    
      ${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
      ${varname}DataAccess.delete${typename}(${java.nameVariable(obj.name)});
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }  
</#if> 
  }
<#list obj.attributes as attr>
  <#if attr.name == "state">
  
  public void enable${typename}(${typename}Query query) throws ServiceException {
    <#if obj.isLabelled("pivot") && obj.getLabelledOptions("pivot")["master"]??>
      <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
      <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
      <#assign masterObjIdAttr = modelbase.get_id_attributes(masterObj)[0]>
    try {    
      ${java.nameType(masterObj.name)} ${java.nameVariable(masterObj.name)} = new ${java.nameType(masterObj.name)}();
      ${java.nameVariable(masterObj.name)}.set${java.nameType(masterObjIdAttr.name)}(query.get${java.nameType(modelbase.get_attribute_sql_name(masterObjIdAttr))}());
      ${java.nameVariable(masterObj.name)}DataAccess.enable${java.nameType(masterObj.name)}(${java.nameVariable(masterObj.name)});
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }  
    <#else>  
    try {    
      ${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
      ${varname}DataAccess.enable${typename}(${java.nameVariable(obj.name)});
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
    </#if>
  }
  
  public void disable${typename}(${typename}Query query) throws ServiceException {
    <#if obj.isLabelled("pivot") && obj.getLabelledOptions("pivot")["master"]??>
      <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
      <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
      <#assign masterObjIdAttr = modelbase.get_id_attributes(masterObj)[0]>
    try {    
      ${java.nameType(masterObj.name)} ${java.nameVariable(masterObj.name)} = new ${java.nameType(masterObj.name)}();
      ${java.nameVariable(masterObj.name)}.set${java.nameType(masterObjIdAttr.name)}(query.get${java.nameType(modelbase.get_attribute_sql_name(masterObjIdAttr))}());
      ${java.nameVariable(masterObj.name)}DataAccess.disable${java.nameType(masterObj.name)}(${java.nameVariable(masterObj.name)});
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }  
    <#else>  
    try {    
      ${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
      ${varname}DataAccess.disable${typename}(${java.nameVariable(obj.name)});
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
    </#if>
  }
  </#if>
</#list>  
<#------------------->
<#-- 可运算的属性处理 -->    
<#------------------->   
<#list obj.attributes as attr>
  <#if attr.isLabelled("incrementable")>
  
  @Transactional(rollbackFor = Throwable.class)
  public void increment${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, int value) throws ServiceException {
    try {
      ${varname}DataAccess.increment${java.nameType(attr.name)}(${modelbase.get_attribute_sql_name(idAttrs[0])}, value);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  }
  </#if>
  <#if attr.isLabelled("decrementable")>
  
  @Transactional(rollbackFor = Throwable.class)
  public void decrement${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, int value) throws ServiceException {
    try {
      ${varname}DataAccess.decrement${java.nameType(attr.name)}(${modelbase.get_attribute_sql_name(idAttrs[0])}, value);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  }
  </#if>
  <#if attr.isLabelled("multipliable")>
  
  @Transactional(rollbackFor = Throwable.class)
  public void multiply${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, BigDecimal value) throws ServiceException {
    try {
      ${varname}DataAccess.multiply${java.nameType(attr.name)}(${modelbase.get_attribute_sql_name(idAttrs[0])}, value);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  }
  </#if>
  <#if attr.isLabelled("divisible")>
  
  @Transactional(rollbackFor = Throwable.class)
  public void divide${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, BigDecimal value) throws ServiceException {
    try {
      ${varname}DataAccess.divide${java.nameType(attr.name)}(${modelbase.get_attribute_sql_name(idAttrs[0])}, value);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
  }
  </#if>
</#list>
<#------------------------->
<#-- 含有业务唯一字段的处理 -->    
<#------------------------->  
<#list uniqueGroups as uniqueAttrs>
  
  @Override
  public ${typename}Query find${typename}By<@modelbase4java.print_find_by_unique_name attrs=uniqueAttrs />(<@modelbase4java.print_find_by_unique_parameters attrs=uniqueAttrs />) throws ServiceException {
    ${typename}Query query = new ${typename}Query();
  <#list uniqueAttrs as uniqueAttr>    
    query.${modelbase4java.name_setter(uniqueAttr)}(${modelbase.get_attribute_sql_name(uniqueAttr)});
  </#list>
    Pagination<${typename}Query> res = find${java.nameType(inflector.pluralize(typename))}(query);
    if (res.getTotal() == 0) {
      return null;
    }
    if (res.getTotal() > 1) {
      throw new ServiceException(409, "根据业务唯一字段找到多条数据");
    }
    return res.getData().get(0);
  }
</#list>  
<#------------------------->
<#-- 通用：含有集合对象属性 -->    
<#------------------------->
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign singular = attr.getLabelledOptions("name")["singular"]!attr.type.componentType.name>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  <#assign collTargetAttr = attr.directRelationship.targetAttribute>
  <#assign one2many = false>
  <#list collObj.attributes as collObjAttr>
    <#if collObjAttr.type.name == obj.name>
      <#assign one2many = true>
      <#break>
    </#if>
  </#list>
  <#if one2many == false>
    <#assign collObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
    <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  </#if>
  
  /**
   * 添加一个【${modelbase.get_object_label(collObj)}】对象。
   */
  @Transactional(rollbackFor = Throwable.class)
  public ${java.nameType(collObj.name)}Query add${java.nameType(singular)}(${java.nameType(collObj.name)}Query query) throws ServiceException {
    ${java.nameType(collObj.name)}Query retVal = new ${java.nameType(collObj.name)}Query();
  <#if collObjIdAttrs?size == 1>
    ${java.nameType(collObj.name)} ${java.nameVariable(collObj.name)} = ${java.nameType(collObj.name)}Assembler.assemble${java.nameType(collObj.name)}FromQuery(query);
    if (query.${modelbase4java.name_getter(collObjIdAttrs[0])}() == null) {
      ${modelbase4java.type_attribute_primitive(collObjIdAttrs[0])} ${modelbase.get_attribute_sql_name(collObjIdAttrs[0])} = IdGenerator.id();
      retVal.${modelbase4java.name_setter(collObjIdAttrs[0])}(${modelbase.get_attribute_sql_name(collObjIdAttrs[0])});
<@modelbase4java.print_reference_assemble attr=collObjIdAttrs[0] objname=java.nameVariable(collObj.name) attrname=modelbase.get_attribute_sql_name(collObjIdAttrs[0]) indent=6 />  
<@modelbase4java.print_object_default_setters obj=collObj varname=java.nameVariable(collObj.name) indent=6 />     
      ${java.nameVariable(collObj.name)}DataAccess.insert${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)});
    } else {
      ${java.nameVariable(collObj.name)}DataAccess.updatePartial${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)});
    }
  <#else>
    <#-- 多对多CONJUNCTION的定义，多对多情况需要验证是否已经存在 -->  
    <#list collObjIdAttrs as collObjIdAttr>
      <#if collObjIdAttr.type.custom>
    if (query.${modelbase4java.name_getter(collObjIdAttr)}() == null) {
      throw new ServiceException(400, "${modelbase.get_attribute_label(collObjIdAttr)}为空");
    }
      </#if>
    </#list>
    <#list collObjIdAttrs as collObjIdAttr>
    retVal.${modelbase4java.name_setter(collObjIdAttr)}(query.${modelbase4java.name_getter(collObjIdAttr)}());
    </#list>
    <#list collObj.attributes as attr>
      <#if attr.name == 'state'>
    query.setState("E");  
      </#if>
    </#list>
    List<Map<String,Object>> found = ${java.nameVariable(collObj.name)}DataAccess.select${java.nameType(collObj.name)}(query);
    if (found.size() > 0) {
      return retVal;
    }
    ${java.nameType(collObj.name)} ${java.nameVariable(collObj.name)} = ${java.nameType(collObj.name)}Assembler.assemble${java.nameType(collObj.name)}FromQuery(query);
<@modelbase4java.print_object_default_setters obj=collObj varname=java.nameVariable(collObj.name) indent=4 />  
    ${java.nameVariable(collObj.name)}DataAccess.insert${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)});
  </#if>
  <#if modelbase.has_observer_for_attribute(obj, attr)>
<@modelbase4java.print_attribute_observer_update obj=obj attr=attr indent=4 />    
  </#if>
    return retVal;
  }
  
  /**
   * 添加多个【${modelbase.get_object_label(collObj)}】对象。
   */
  @Transactional(rollbackFor = Throwable.class)
  public List<${java.nameType(collObj.name)}Query> add${java.nameType(attr.name)}(List<${java.nameType(collObj.name)}Query> queries) throws ServiceException {
    List<${java.nameType(collObj.name)}Query> retVal = new ArrayList<>();
    for (${java.nameType(collObj.name)}Query query : queries) {
      add${java.nameType(singular)}(query);
    }
    return retVal;
  }
   
  /**
   * 去掉一个【${modelbase.get_object_label(collObj)}】对象。
   */
  @Transactional(rollbackFor = Throwable.class)
  public ${java.nameType(collObj.name)}Query remove${java.nameType(singular)}(${java.nameType(collObj.name)}Query query) throws ServiceException {
    ${java.nameType(collObj.name)}Query retVal = new ${java.nameType(collObj.name)}Query();
  <#if collObjIdAttrs?size == 1>
    if (query.${modelbase4java.name_getter(collObjIdAttrs[0])}() == null) {
      throw new ServiceException(400, "${modelbase.get_object_label(collObj)}标识为空");
    }
    retVal.${modelbase4java.name_setter(collObjIdAttrs[0])}(query.${modelbase4java.name_getter(collObjIdAttrs[0])}());
    ${java.nameType(collObj.name)} ${java.nameVariable(collObj.name)} = ${java.nameType(collObj.name)}Assembler.assemble${java.nameType(collObj.name)}FromQuery(query);
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.type.name == obj.name>
    ${java.nameVariable(collObj.name)}.set${java.nameType(collObjAttr.name)}(${java.nameType(obj.name)}.NULL);
        <#break>
      </#if>
    </#list>
    ${java.nameVariable(collObj.name)}DataAccess.disable${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)});
  <#else>
    <#list collObjIdAttrs as collObjIdAttr>
      <#if collObjIdAttr.type.custom>
    if (query.${modelbase4java.name_getter(collObjIdAttr)}() == null) {
      throw new ServiceException(400, "${modelbase.get_attribute_label(collObjIdAttr)}为空");
    }
      </#if>
    </#list>
    <#list collObjIdAttrs as collObjIdAttr>
      <#if collObjIdAttr.type.name == 'datetime'><#continue></#if>
    retVal.${modelbase4java.name_setter(collObjIdAttr)}(query.${modelbase4java.name_getter(collObjIdAttr)}());
    </#list>
    ${java.nameType(collObj.name)} ${java.nameVariable(collObj.name)} = ${java.nameType(collObj.name)}Assembler.assemble${java.nameType(collObj.name)}FromQuery(query);
    ${java.nameVariable(collObj.name)}DataAccess.disable${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)});
  </#if>
  <#if modelbase.has_observer_for_attribute(obj, attr)>
<@modelbase4java.print_attribute_observer_update obj=obj attr=attr indent=4 />    
  </#if>
    return retVal;
  }
  
  /**
   * 去掉多个【${modelbase.get_object_label(collObj)}】对象。
   */
  @Transactional(rollbackFor = Throwable.class)
  public List<${java.nameType(collObj.name)}Query> remove${java.nameType(attr.name)}(List<${java.nameType(collObj.name)}Query> queries) throws ServiceException {
    List<${java.nameType(collObj.name)}Query> retVal = new ArrayList<>();
    for (${java.nameType(collObj.name)}Query query : queries) {
      remove${java.nameType(singular)}(query);
    }
    return retVal;
  }
   
  /**
   * 去掉全部【${modelbase.get_object_label(collObj)}】对象。
   */
  @Transactional(rollbackFor = Throwable.class)
  public void clear${java.nameType(attr.name)}(${java.nameType(obj.name)}Query query) throws ServiceException {
    if (query.${modelbase4java.name_getter(idAttrs[0])}() == null) {
      throw new ServiceException(400, "${modelbase.get_object_label(obj)}标识为空");
    }
  <#if modelbase.has_observer_for_attribute(obj, attr)>
    <#assign obAttr = modelbase.get_observer_for_attribute(obj, attr)>
    <#assign operator = obAttr.getLabelledOptions("observer")["operator"]>
    <#assign attrexpr = obAttr.getLabelledOptions("observer")["attribute"]>
    <#if operator == "count">
    query.${modelbase4java.name_setter(obAttr)}(${modelbase4java.get_attribute_default_value(obAttr)});
    <#elseif operator == "max">
    query.${modelbase4java.name_setter(obAttr)}(${java.nameType(collObj.name)}.NULL.toId());
    </#if>
  </#if>  
    ${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);   
  <#if modelbase.has_observer_for_attribute(obj, attr)>
    <#assign obAttr = modelbase.get_observer_for_attribute(obj, attr)>
    <#assign operator = obAttr.getLabelledOptions("observer")["operator"]>
    <#if operator == "count">
    ${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
    <#elseif operator == "max">
    </#if>  
  </#if>
  <#if one2many>
    <#assign collObjIdAttr = modelbase.get_id_attributes(collObj)[0]>
    List<${java.nameType(collObj.name)}Query> ${java.nameType(collObj.name)}Queries = get${java.nameType(attr.name)}(query);
    for (${java.nameType(collObj.name)}Query q : ${java.nameType(collObj.name)}Queries) {
      ${java.nameType(collObj.name)} ${java.nameVariable(collObj.name)}Item = ${java.nameType(collObj.name)}Assembler.assemble${java.nameType(collObj.name)}FromQuery(q);
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.type.name == obj.name>
      ${java.nameVariable(collObj.name)}Item.set${java.nameType(collObjAttr.name)}(${java.nameType(obj.name)}.NULL);
        <#break>
      </#if>
    </#list>
      ${java.nameVariable(collObj.name)}DataAccess.updatePartial${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)}Item);
    }
  <#else>
    ${java.nameType(conjObj.name)} conj = new ${java.nameType(conjObj.name)}();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
    conj.set${java.nameType(conjObjAttr.name)}(${java.nameVariable(obj.name)});
      </#if>
    </#list>
    ${java.nameVariable(conjObj.name)}DataAccess.disable${java.nameType(conjObj.name)}(conj);
  </#if>
  }
  
  /**
   * 获得全部【${modelbase.get_object_label(collObj)}】对象。
   */
  public List<${java.nameType(collObj.name)}Query> get${java.nameType(attr.name)}(${java.nameType(obj.name)}Query query) throws ServiceException {
    if (query.${modelbase4java.name_getter(idAttrs[0])}() == null) {
      throw new ServiceException(400, "${modelbase.get_object_label(obj)}标识为空");
    }
    ${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
    List<${java.nameType(collObj.name)}Query> retVal = new ArrayList<>();
  <#if one2many>
    ${java.nameType(collObj.name)}Query ${java.nameVariable(collObj.name)}Query = new ${java.nameType(collObj.name)}Query();
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.type.name == obj.name>
    ${java.nameVariable(collObj.name)}Query.${modelbase4java.name_setter(collObjAttr)}(${java.nameVariable(obj.name)}.toId());
        <#break>
      </#if>
    </#list>
    List<Map<String,Object>> rows = ${java.nameVariable(collObj.name)}DataAccess.select${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)}Query);
    for (Map<String,Object> row : rows) {
      retVal.add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
    }
  <#else>
    ${java.nameType(conjObj.name)}Query ${java.nameVariable(conjObj.name)}Query = new ${java.nameType(conjObj.name)}Query();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
    ${java.nameVariable(conjObj.name)}Query.${modelbase4java.name_setter(conjObjAttr)}(${java.nameVariable(obj.name)}.toId());
        <#break>
      </#if>
    </#list>
    List<Map<String,Object>> rows = ${java.nameVariable(conjObj.name)}DataAccess.select${java.nameType(conjObj.name)}(${java.nameVariable(conjObj.name)}Query);
    for (Map<String,Object> row : rows) {
      retVal.add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
    }
  </#if>  
    return retVal;
  }
</#list>
}
