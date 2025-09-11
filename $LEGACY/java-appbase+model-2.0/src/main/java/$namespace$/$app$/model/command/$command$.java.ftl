<#import '/$/appbase.ftl' as appbase>
<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model.command;

import java.sql.Date;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.InputStream;

import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.ddd.Command;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.util.Safe;

import <#if namespace??>${namespace}.</#if>${app.name}.model.Constants;
import <#if namespace??>${namespace}.</#if>${app.name}.model.Errors;

import <#if namespace??>${namespace}.</#if>${app.name}.model.*;
<#if modelbase.has_entity_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
</#if>
<#if modelbase.has_value_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.value.*;
</#if>

<#assign commandId = command.name>
/**
 * ${command.text!'TODO'}命令对象封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">甘果</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(commandId)} implements Command, Serializable {

  private static final long serialVersionUID = -1L;

<#list command.attributes as attr>
  /**
   * ${modelbase.get_attribute_label(attr)}.
   */
  private <#if attr.type.collection>final </#if>${modelbase.get_type_name(attr.type)} ${java.nameVariable(attr.name)}<#if attr.type.collection> = new ArrayList<>()</#if>;

</#list>
<#list command.attributes as attr>
  public ${modelbase.get_type_name(attr.type)} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }

  <#if !attr.type.collection>
  public void set${java.nameType(attr.name)}(${modelbase.get_type_name(attr.type)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }

  </#if>
</#list>
  /**
   * 转化为可用于数据访问的SQL对象。
   *
   * @return SQL对象
   */
  public SqlParams toSqlParams() {
    SqlParams retVal = new SqlParams();
<#list command.attributes as attr>
<#assign attrName = attr.getLabelledOptions('command')['name']!>
<#assign operator = attr.getLabelledOptions('command')['operator']!>
<#assign refObj = modelbase.get_single_reference(attr, model)!>
<#if attrName == ''>
  <#assign attrName = attr.name>
</#if>
<#if operator == ''>
  <#assign operator = '='>
</#if>
<#if operator == '[]'>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${attr.persistenceName?lower_case}", ${java.nameVariable(attrName)});
    }
<#elseif operator == '<>'>
    if (${java.nameVariable(attrName)}0 != null) {
      retVal.set("${attr.persistenceName?lower_case}0", ${java.nameVariable(attrName)}0);
    }
    if (${java.nameVariable(attrName)}1 != null) {
      retVal.set("${attr.persistenceName?lower_case}1", ${java.nameVariable(attrName)}1);
    }
<#elseif refObj != ''>
  <#list refObj.attributes as refObjAttr>
    <#if !refObjAttr.isLabelled('command')><#continue></#if>
    <#assign refObjAttrName = refObjAttr.getLabelledOptions('command')['name']!>
    <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('command')['operator']!>
    <#if refObjAttrName == ''>
      <#assign refObjAttrName = refObjAttr.name>
    </#if>
    <#if refObjAttrOperator != '='><#continue></#if>
    <#if refObjAttr.constraint.identifiable>
    if (${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)} != null) {
      retVal.set("${refObjAttr.persistenceName?lower_case}", ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)});
    }
    <#elseif refObjAttr.type.custom>
      <#-- TODO: 暂时不需要做任何处理，直接忽略 -->
    <#else>
    if (${java.nameVariable(attrName + '_' + refObjAttrName)} != null) {
      retVal.set("${refObjAttr.persistenceName?lower_case}", ${java.nameVariable(attrName + '_' + refObjAttrName)});
    }
    </#if>
  </#list>
<#elseif attr.type.name == 'string'>
    if (!Strings.isBlank(${java.nameVariable(attrName)})) {
      retVal.set("${attr.persistenceName?lower_case}", ${java.nameVariable(attrName)});
    }
<#elseif attr.type.name == 'bool'>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${attr.persistenceName?lower_case}", ${java.nameVariable(attrName)} ? Constants.TRUE : Constants.FALSE);
    }
<#else>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${attr.persistenceName?lower_case}", ${java.nameVariable(attrName)});
    }
</#if>
</#list>
    return retVal;
  }

  /**
   * 从来源于用户输入界面的请求参数中赋值。
   *
   * @param params
   *        请求参数封装，通常来源于用户输入界面
   */
  public void from(ObjectMap params) {
<#list command.attributes as attr>
<#assign attrName = attr.getLabelledOptions('command')['name']!>
<#assign operator = attr.getLabelledOptions('command')['operator']!>
<#assign refObj = modelbase.get_single_reference(attr, model)!>
<#if attrName == ''>
  <#assign attrName = attr.name>
</#if>
<#if operator == ''>
  <#assign operator = '='>
</#if>
<#if operator == '[]'>
    if (params.containsKey("${java.nameVariable(attrName)}")) {
      set${java.nameType(attrName)}(params.get("${java.nameVariable(attrName)}"));
    }
<#elseif operator == '<>'>
    if (params.containsKey("${java.nameVariable(attrName)}0")) {
      set${java.nameType(attrName)}0(Safe.safe(params.get("${java.nameVariable(attrName)}0"), ${modelbase.get_type_name(attr.type)}.class));
    }
    if (params.containsKey("${java.nameVariable(attrName)}1")) {
      set${java.nameType(attrName)}1(Safe.safe(params.get("${java.nameVariable(attrName)}1"), ${modelbase.get_type_name(attr.type)}.class));
    }
<#elseif refObj != ''>
  <#list refObj.attributes as refObjAttr>
    <#if !refObjAttr.isLabelled('command')><#continue></#if>
    <#assign refObjAttrName = refObjAttr.getLabelledOptions('command')['name']!>
    <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('command')['operator']!>
    <#if refObjAttrName == ''>
      <#assign refObjAttrName = refObjAttr.name>
    </#if>
    <#if refObjAttrOperator != '='><#continue></#if>
    <#if refObjAttr.constraint.identifiable>
    if (params.containsKey("${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)}")) {
      set${java.nameType(attr.name)}${java.nameType(refObjAttrName)}(${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)});
    }
    <#elseif refObjAttr.type.custom>
      <#-- TODO: 暂时不需要做任何处理，直接忽略 -->
    <#else>
    if (params.containsKey("${java.nameVariable(refObjAttrName)}"))
      set${java.nameType(attrName + '_' + refObjAttrName)}(Safe.safe(params.get("${java.nameVariable(refObjAttrName)}"), ${modelbase.get_type_name(refObjAttr.type)}.class));
    }
    </#if>
  </#list>
<#elseif attr.type.collection>
    if (params.containsKey("${java.nameVariable(attrName)}")) {
      for (${modelbase.get_type_name(attr.type.componentType)} item : ${java.nameVariable(attrName)}) {
        get${java.nameType(attrName)}().add(item);
      }
    }
<#else>
    if (params.containsKey("${java.nameVariable(attrName)}")) {
      set${java.nameType(attrName)}(Safe.safe(params.get("${java.nameVariable(attrName)}"), ${modelbase.get_type_name(attr.type)}.class));
    }
</#if>
</#list>
  }

}
