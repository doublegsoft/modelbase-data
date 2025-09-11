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

import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.service.CommonService;
import net.doublegsoft.appbase.service.ServiceException;
import net.doublegsoft.appbase.util.Strings;

<#assign entity = constant>
import <#if namespace??>${namespace}.</#if>${app.name}.model.*;
<#if modelbase.has_entity_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
</#if>
import <#if namespace??>${namespace}.</#if>${app.name}.model.value.*;
<#-- 实体类名 -->
<#assign typename = java.nameType(constant.name)>
<#-- 实体变量名 -->
<#assign varname = java.nameVariable(constant.name)>
<#assign label = modelbase.get_object_label(constant)>
<#-- 名称的单数和复数形式 -->
<#assign singular = modelbase.get_attribute_labelled_option(constant, 'name', 'singular')>
<#assign plural   = modelbase.get_attribute_labelled_option(constant, 'name', 'plural')>

/**
 * 【${label}】对象有效性验证工具。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">甘果</a>
 *
 * @since 1.0
 */
public class ${typename}Validation {

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
  <#if attr.constraint.unique>
    try {
      Object found = commonService.single("${entity.persistenceName}.${attr.persistenceName}.find", new SqlParams().set("${modelbase.get_attribute_sql_name(attr)}", ${varname}.get${java.nameType(attr.name)}()));
      if (found != null) {
        errors.append("【${modelbase.get_attribute_label(attr)}】数据不是唯一").append("\n");
      }
    } catch (ServiceException ex) {
      throw new DomainException(ex);
    }
  </#if>
</#list>
    return errors.toString();
  }

}
