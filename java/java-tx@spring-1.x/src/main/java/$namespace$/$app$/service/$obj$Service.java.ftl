<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign uniqueGroups = modelbase.group_unique_attributes(obj)>
/**
 * 【${modelbase.get_object_label(obj)}】存储事务化的服务规范。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public interface ${typename}Service {

  /**
   * 批处理（插入、更新、删除）【${modelbase.get_object_label(obj)}】对象。
   *
   * @param existingQuery
   *        用于获取已经存在的数据集合的查询对象
   *
   * @param compareFields
   *        用于比较已经持久化的集合和用户编辑传入的集合相互比较的字段名称
   *
   * @param queries
   *        多个【${modelbase.get_object_label(obj)}】查询对象，待持久化数据，包括已经存在的更新和新增的插入
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  void batch${inflector.pluralize(typename)}(${typename}Query existingQuery, List<String> compareFields, List<${typename}Query> queries) throws ServiceException;

  /**
   * 保存多个【${modelbase.get_object_label(obj)}】对象。
   *
   * @param queries
   *        多个【${modelbase.get_object_label(obj)}】查询对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  void save${inflector.pluralize(typename)}(List<${typename}Query> queries) throws ServiceException;
  
  /**
   * 保存【${modelbase.get_object_label(obj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 被赋予对象标识的【${modelbase.get_object_label(obj)}】对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  ${typename}Query save${typename}(${typename}Query query) throws ServiceException;
<#if obj.persistenceName??>  

  /**
   * 单纯地创建【${modelbase.get_object_label(obj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 被赋予对象标识的【${modelbase.get_object_label(obj)}】对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  ${typename}Query create${typename}(${typename}Query query) throws ServiceException;
  
  /**
   * 单纯地更新【${modelbase.get_object_label(obj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 被赋予对象标识的【${modelbase.get_object_label(obj)}】对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  ${typename}Query update${typename}(${typename}Query query) throws ServiceException;
</#if>  

  /**
   * 修改【${modelbase.get_object_label(obj)}】详细对象的部分信息。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象 
   *
   * @return ${typename}Query 查询到的唯一【${modelbase.get_object_label(obj)}】对象 
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  ${typename}Query modify${typename}(${typename}Query query) throws ServiceException;

  /**
   * 查询【${modelbase.get_object_label(obj)}】列表对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 查询到的唯一【${modelbase.get_object_label(obj)}】对象集合
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常  
   */
  Pagination<${typename}Query> find${inflector.pluralize(typename)}(${typename}Query query) throws ServiceException;
  
  /**
   * 读取【${modelbase.get_object_label(obj)}】详细对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象 
   *
   * @return ${typename}Query 查询到的唯一【${modelbase.get_object_label(obj)}】对象 
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  ${typename}Query read${typename}(${typename}Query query) throws ServiceException;
  
  /**
   * 聚合统计【${modelbase.get_object_label(obj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象 
   *
   * @return ${typename}Query 查询到的唯一【${modelbase.get_object_label(obj)}】对象 
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  Pagination<${typename}Query> aggregate${typename}(${typename}Query query) throws ServiceException;
  
  /**
   * 删除（物理删除）【${modelbase.get_object_label(obj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象 
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  void delete${typename}(${typename}Query query) throws ServiceException;
<#list obj.attributes as attr>
  <#if attr.name == "state">
  
  void enable${typename}(${typename}Query query) throws ServiceException;
  
  void disable${typename}(${typename}Query query) throws ServiceException;
  </#if>
</#list>    
<#-------------------->
<#-- 业务唯一对象属性 -->    
<#-------------------->  
<#list uniqueGroups as uniqueAttrs>
  
  /**
   * 通过业务唯一字段查询【${modelbase.get_object_label(obj)}】对象。
  <#list uniqueAttrs as uniqueAttr>  
   *   
   * @param ${modelbase.get_attribute_sql_name(uniqueAttr)}
   *        【${modelbase.get_attribute_label(uniqueAttr)}】
  </#list> 
   *
   * @return ${typename}Query 业务唯一【${modelbase.get_object_label(obj)}】对象 
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常   
   */
  ${typename}Query find${typename}By<@modelbase4java.print_find_by_unique_name attrs=uniqueAttrs />(<@modelbase4java.print_find_by_unique_parameters attrs=uniqueAttrs />) throws ServiceException;
</#list> 
<#---------------->
<#-- 集合对象属性 -->    
<#---------------->
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
   *
   * @param query
   *        【${modelbase.get_object_label(collObj)}】子查询对象  
   *
   * @return 仅携带标识数据的【${modelbase.get_object_label(obj)}】查询对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常
   */
  ${java.nameType(collObj.name)}Query add${java.nameType(singular)}(${java.nameType(collObj.name)}Query query) throws ServiceException;

  /**
   * 添加多个【${modelbase.get_object_label(collObj)}】对象。
   *
   * @param queries
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 仅携带标识数据的【${modelbase.get_object_label(obj)}】查询对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常
   */
  List<${java.nameType(collObj.name)}Query> add${java.nameType(attr.name)}(List<${java.nameType(collObj.name)}Query> queries) throws ServiceException;
      
  /**
   * 去掉一个【${modelbase.get_object_label(collObj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 仅携带标识数据的【${modelbase.get_object_label(obj)}】查询对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常
   */
  ${java.nameType(collObj.name)}Query remove${java.nameType(singular)}(${java.nameType(collObj.name)}Query query) throws ServiceException;
  
  /**
   * 去掉多个【${modelbase.get_object_label(collObj)}】对象。
   *
   * @param queries
   *        【${modelbase.get_object_label(obj)}】查询对象
   *
   * @return 仅携带标识数据的【${modelbase.get_object_label(obj)}】查询对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常
   */
  List<${java.nameType(collObj.name)}Query> remove${java.nameType(attr.name)}(List<${java.nameType(collObj.name)}Query> queries) throws ServiceException;
   
  /**
   * 去掉全部【${modelbase.get_object_label(collObj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】主查询对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常
   */
  void clear${java.nameType(attr.name)}(${java.nameType(obj.name)}Query query) throws ServiceException;
  
  /**
   * 获得全部【${modelbase.get_object_label(collObj)}】对象。
   *
   * @param query
   *        【${modelbase.get_object_label(obj)}】主查询对象
   *
   * @return 满足条件的【${modelbase.get_object_label(collObj)}】对象
   *
   * @throws ServiceException
   *        发生任何错误，都抛出此类型异常
   */
  List<${java.nameType(collObj.name)}Query> get${java.nameType(attr.name)}(${java.nameType(obj.name)}Query query) throws ServiceException;
</#list>
<#--------------->
<#-- 可运算属性 -->    
<#--------------->   
<#list obj.attributes as attr>
  <#if attr.isLabelled("incrementable")>
  
  void increment${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, int value) throws ServiceException;
  </#if>
  <#if attr.isLabelled("decrementable")>
  
  void decrement${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, int value) throws ServiceException;
  </#if>
  <#if attr.isLabelled("multipliable")>
  
  void multiply${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, BigDecimal value) throws ServiceException;
  </#if>
  <#if attr.isLabelled("divisible")>
  
  void divide${java.nameType(attr.name)}(${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])}, BigDecimal value) throws ServiceException;
  </#if>
</#list>
}
