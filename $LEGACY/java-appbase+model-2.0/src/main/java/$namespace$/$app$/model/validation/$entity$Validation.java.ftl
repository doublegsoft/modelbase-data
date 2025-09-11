<#import '/$/appbase.ftl' as appbase>
<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model.validation;

import java.sql.Date;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Timestamp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.service.CommonService;
import net.doublegsoft.appbase.service.ServiceException;
import net.doublegsoft.appbase.util.Strings;

import <#if namespace??>${namespace}.</#if>${app.name}.model.*;
<#if modelbase.has_entity_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
</#if>
<#if modelbase.has_value_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.value.*;
</#if>
<#-- 实体类名 -->
<#assign typename = java.nameType(entity.name)>
<#-- 实体变量名 -->
<#assign varname = java.nameVariable(entity.name)>
<#assign label = modelbase.get_object_label(entity)>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
<#-- 名称的单数和复数形式 -->
<#assign singular = modelbase.get_attribute_labelled_option(entity, 'name', 'singular')>
<#assign plural   = modelbase.get_attribute_labelled_option(entity, 'name', 'plural')>

/**
 * 【${label}】对象有效性验证工具。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">甘果</a>
 *
 * @since 1.0
 */
public class ${typename}Validation {

  private static final Logger TRACER = LoggerFactory.getLogger(${typename}Validation.class);

  private final CommonService commonService;

  public ${typename}Validation(CommonService commonService) {
    this.commonService = commonService;
  }

  /**
   * 验证【${label}】对象有效性。
   *
   * @param ${varname}
   *        待验证实体对象
   *
   * @return 错误信息，如果为空或者空字符串，则无错误
   *
   * @throws DomainException
   *        捕获到其他异常则抛出
   */
  public String validate(${typename} ${varname}) throws DomainException {
    StringBuilder errors = new StringBuilder();
<#list entity.attributes as attr>
  <#if !attr.constraint.nullable>
    <#if attr.type.name == 'string'>
    if (Strings.isBlank(${varname}.get${java.nameType(attr.name)}())) {
      errors.append("【${modelbase.get_attribute_label(attr)}】不能为空").append("\n");
    }
    <#else>
    if (${varname}.get${java.nameType(attr.name)}() == null) {
      errors.append("【${modelbase.get_attribute_label(attr)}】不能为空").append("\n");
    }
    </#if>
  </#if>
  <#if attr.type.name == 'string' && attr.constraint.maxSize != 0>
    <#if attr.constraint.domainType.toString()?index_of('name') == 0>
    if (!Strings.isBlank(${varname}.get${java.nameType(attr.name)}())) {
      // 检查字符串长度
      try {
        byte[] bytes = ${varname}.get${java.nameType(attr.name)}().getBytes("UTF-8");
        if (bytes.length > 200) {
          errors.append("【${modelbase.get_attribute_label(attr)}】输入字符长度超长").append("\n");
        }
      } catch (Exception ex) {

      }
    }
    <#elseif attr.constraint.domainType.toString()?index_of('uuid') == 0 || attr.constraint.domainType.toString()?index_of('id') == 0>
    if (!Strings.isBlank(${varname}.get${java.nameType(attr.name)}())) {
      // 检查字符串长度
      try {
        byte[] bytes = ${varname}.get${java.nameType(attr.name)}().getBytes("UTF-8");
        if (bytes.length > 64) {
          errors.append("【${modelbase.get_attribute_label(attr)}】输入字符长度超长").append("\n");
        }
      } catch (Exception ex) {

      }
    }
    <#else>
    if (!Strings.isBlank(${varname}.get${java.nameType(attr.name)}())) {
      // 检查字符串长度
      try {
        byte[] bytes = ${varname}.get${java.nameType(attr.name)}().getBytes("UTF-8");
        if (bytes.length > ${attr.constraint.maxSize?string('####')}) {
          errors.append("【${modelbase.get_attribute_label(attr)}】输入字符长度超长").append("\n");
        }
      } catch (Exception ex) {

      }
    }
    </#if>
  </#if>
  <#if attr.constraint.unique>
    if (${varname}.get${java.nameType(attr.name)}() != null && !Strings.isBlank(${varname}.get${java.nameType(attr.name)}().toString())) {
      try {
        ObjectMap found = commonService.single("${entity.persistenceName}.${attr.persistenceName}.find", new SqlParams().set("${modelbase.get_attribute_sql_name(attr)}", ${varname}.get${java.nameType(attr.name)}()));
        if (found != null && !found.get("${modelbase.get_attribute_sql_name(attrId)}").equals(String.valueOf(${varname}.get${java.nameType(attrId.name)}()))) {
          errors.append("【${modelbase.get_attribute_label(attr)}】数据不是唯一").append("\n");
        }
      } catch (ServiceException ex) {
        throw new DomainException(ex);
      }
    }
  </#if>
  <#if attr.type.custom && attr.type.name == entity.name>
    <#-- 树结构不能自己作为自己的上级 -->
    if (${varname}.get${java.nameType(attr.name)}() != null && 
        ${varname}.get${java.nameType(attr.name)}().getId() != null && 
        !Strings.isBlank(${varname}.get${java.nameType(attr.name)}().getId().toString()) &&
        ${varname}.get${java.nameType(attr.name)}().getId().equals(${varname}.getId())) {
      errors.append("【${modelbase.get_attribute_label(attr)}】的数据不能是该数据本身").append("\n");
    }
    /*
    if (!Strings.isBlank(${varname}.getId()) && 
        ${varname}.get${java.nameType(attr.name)}() != null && 
        !Strings.isBlank(${varname}.get${java.nameType(attr.name)}().getId()) &&
        !${varname}.getId().equals(${varname}.get${java.nameType(attr.name)}().getId())) {
      try {
        List<ObjectMap> existings = commonService.many("${entity.persistenceName}.find", new SqlParams());
        for (ObjectMap row : existings) {
          if (row.get("${modelbase.get_attribute_sql_name(attrId)}").equals(${varname}.getId())) {
            row.set("${modelbase.get_attribute_sql_name(attr)}", ${varname}.get${java.nameType(attr.name)}().getId());
            break;
          }
        }
        net.doublegsoft.appbase.graph.Graph graphVal = net.doublegsoft.appbase.graph.Graph.build(existings, "${modelbase.get_attribute_sql_name(attrId)}", "${modelbase.get_attribute_sql_name(attr)}");
        if (graphVal.hasCycle()) {
          errors.append("【${modelbase.get_attribute_label(attr)}】存在环状引用").append("\n");
        }
      } catch (ServiceException ex) {
        TRACER.error(ex.getMessage(), ex);
      }
    }
    */
    <#-- 环检测 -->
  </#if>
</#list>
    return errors.toString();
  }

}
