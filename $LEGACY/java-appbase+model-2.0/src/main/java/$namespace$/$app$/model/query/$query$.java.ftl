<#import '/$/appbase.ftl' as appbase>
<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model.query;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.InputStream;

import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.ddd.Query;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.util.Safe;

import <#if namespace??>${namespace}.</#if>${app.name}.model.*;

<#-- 正式的查询对象的类型名称 -->
<#assign queryName = query.getLabelledOptions('query')['name']!>
<#if queryName == ''>
  <#assign queryName = query.name>
</#if>
/**
 * ${query.text!'TODO'}查询对象封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">甘果</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(queryName)} implements Query, Serializable {

  private static final long serialVersionUID = -1L;

<#list query.attributes as attr>
  <#assign attrName = attr.getLabelledOptions('query')['name']!>
  <#assign operator = attr.getLabelledOptions('persistence')['query']!>
  <#assign refObj = modelbase.get_single_reference(attr, model)!>
  <#if attrName == ''>
    <#assign attrName = attr.name>
  </#if>
  <#if operator == ''>
    <#assign operator = '='>
  </#if>
  <#if operator == '[]'>
  /**
   * ${modelbase.get_attribute_label(attr)}.
   */
  private final ${modelbase.get_type_name(attr.type)} ${java.nameVariable(attrName)} = new ArrayList<>();
  <#elseif operator == '<>'>
  /**
   * ${modelbase.get_attribute_label(attr)}，下限值.
   */
  private ${modelbase.get_type_name(attr.type)} ${java.nameVariable(attrName)}0;

  /**
   * ${modelbase.get_attribute_label(attr)}，上限值.
   */
  private ${modelbase.get_type_name(attr.type)} ${java.nameVariable(attrName)}1;
  <#elseif refObj != ''>
    <#list refObj.attributes as refObjAttr>
      <#if !refObjAttr.isLabelled('query')><#continue></#if>
      <#assign refObjAttrName = refObjAttr.getLabelledOptions('query')['name']!>
      <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('query')['operator']!>
      <#if refObjAttrName == ''>
        <#assign refObjAttrName = refObjAttr.name>
      </#if>
      <#if refObjAttrOperator != '='><#continue></#if>
  /**
   * ${modelbase.get_attribute_label(refObjAttr)}.
   */
      <#if refObjAttr.constraint.identifiable>
  private ${modelbase.get_attribute_primitive_type_name(refObjAttr)} ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)};
      <#elseif refObjAttr.type.custom>
        <#-- TODO: 暂时不需要做任何处理，直接忽略 -->
      <#else>
  private ${modelbase.get_attribute_primitive_type_name(refObjAttr)} ${java.nameVariable(attrName + '_' + refObjAttrName)};
      </#if>

    </#list>
  <#else>
  /**
   * ${modelbase.get_attribute_label(attr)}.
   */
  private ${modelbase.get_type_name(attr.type)} ${java.nameVariable(attrName)}<#if attr.type.collection> = new ArrayList<>()</#if>;
  </#if>

</#list>
<#list query.attributes as attr>
  <#assign attrName = attr.getLabelledOptions('query')['name']!>
  <#assign operator = attr.getLabelledOptions('persistence')['query']!>
  <#assign refObj = modelbase.get_single_reference(attr, model)!>
  <#if attrName == ''>
    <#assign attrName = attr.name>
  </#if>
  <#if operator == ''>
    <#assign operator = '='>
  </#if>
  <#if operator == '[]'>
  public ${modelbase.get_type_name(attr.type)} get${java.nameType(attrName)}() {
    return ${java.nameVariable(attrName)};
  }

  <#elseif operator == '<>'>
  public ${modelbase.get_type_name(attr.type)} get${java.nameType(attrName)}0() {
    return ${java.nameVariable(attrName)}0;
  }

  public void set${java.nameType(attrName)}0(${modelbase.get_type_name(attr.type)} ${java.nameVariable(attrName)}0) {
    this.${java.nameVariable(attrName)}0 = ${java.nameVariable(attrName)}0;
  }

  public ${modelbase.get_type_name(attr.type)} get${java.nameType(attrName)}1() {
    return ${java.nameVariable(attrName)}1;
  }

  public void set${java.nameType(attrName)}1(${modelbase.get_type_name(attr.type)} ${java.nameVariable(attrName)}1) {
    this.${java.nameVariable(attrName)}1 = ${java.nameVariable(attrName)}1;
  }
  <#elseif refObj != ''>
    <#list refObj.attributes as refObjAttr>
      <#if !refObjAttr.isLabelled('query')><#continue></#if>
      <#assign refObjAttrName = refObjAttr.getLabelledOptions('query')['name']!>
      <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('query')['operator']!>
      <#if refObjAttrName == ''>
        <#assign refObjAttrName = refObjAttr.name>
      </#if>
      <#if refObjAttrOperator != '='><#continue></#if>
      <#if refObjAttr.constraint.identifiable>
  public ${modelbase.get_type_name(refObjAttr.type)} get${java.nameType(attr.name)}${java.nameType(refObjAttrName)}() {
    return ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)};
  }

  public void set${java.nameType(attr.name)}${java.nameType(refObjAttrName)}(${modelbase.get_type_name(refObjAttr.type)} ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)}) {
    this.${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)} = ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)};
  }
      <#elseif refObjAttr.type.custom>
        <#-- TODO: 暂时不需要做任何处理，直接忽略 -->
      <#else>
  public ${modelbase.get_type_name(refObjAttr.type)} get${java.nameType(attrName + '_' + refObjAttrName)}() {
    return ${java.nameVariable(attrName + '_' + refObjAttrName)};
  }

  public void set${java.nameType(attrName + '_' + refObjAttrName)}(${modelbase.get_type_name(refObjAttr.type)} ${java.nameVariable(attrName + '_' + refObjAttrName)}) {
    this.${java.nameVariable(attrName + '_' + refObjAttrName)} = ${java.nameVariable(attrName + '_' + refObjAttrName)};
  }
      </#if>

    </#list>
  <#else>
  public ${modelbase.get_attribute_primitive_type_name(attr)} get${java.nameType(attrName)}() {
    return ${java.nameVariable(attrName)};
  }

  public void set${java.nameType(attrName)}(${modelbase.get_attribute_primitive_type_name(attr)} ${java.nameVariable(attrName)}) {
    this.${java.nameVariable(attrName)} = ${java.nameVariable(attrName)};
  }
  </#if>

</#list>

  /**
   * 转化为可用于数据访问的查询条件对象。
   *
   * @return 查询条件对象
   */
  public SqlParams toSqlParams() {
    SqlParams retVal = new SqlParams();
<#list query.attributes as attr>
  <#assign attrName = attr.getLabelledOptions('query')['name']!>
  <#assign operator = attr.getLabelledOptions('persistence')['query']!>
  <#assign refObj = modelbase.get_single_reference(attr, model)!>
  <#if attrName == ''>
    <#assign attrName = attr.name>
  </#if>
  <#if operator == ''>
    <#assign operator = '='>
  </#if>
  <#if operator == '[]'>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)});
    }
  <#elseif operator == '<>'>
    if (${java.nameVariable(attrName)}0 != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)}0", ${java.nameVariable(attrName)}0);
    }
    if (${java.nameVariable(attrName)}1 != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)}1", ${java.nameVariable(attrName)}1);
    }
  <#elseif refObj != ''>
    <#list refObj.attributes as refObjAttr>
      <#if !refObjAttr.isLabelled('query')><#continue></#if>
      <#assign refObjAttrName = refObjAttr.getLabelledOptions('query')['name']!>
      <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('query')['operator']!>
      <#if refObjAttrName == ''>
        <#assign refObjAttrName = refObjAttr.name>
      </#if>
      <#if refObjAttrOperator != '='><#continue></#if>
      <#if refObjAttr.constraint.identifiable>
    if (${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(refObjAttr)}", ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)});
    }
      <#elseif refObjAttr.type.custom>
        <#-- TODO: 暂时不需要做任何处理，直接忽略 -->
      <#else>
    if (${java.nameVariable(attrName + '_' + refObjAttrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(refObjAttr)}", ${java.nameVariable(attrName + '_' + refObjAttrName)});
    }
      </#if>
    </#list>
  <#elseif attr.type.name == 'string'>
    if (!Strings.isBlank(${java.nameVariable(attrName)})) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)});
    }
  <#elseif attr.type.name == 'bool'>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)} ? Constants.TRUE : Constants.FALSE);
    }
  <#elseif attr.persistenceName??>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)});
    }
  </#if>
</#list>
    return retVal;
  }

  /**
   * 转化为可用于数据访问的脚本类似对象。
   *
   * @return 查询条件对象
   */
  public ObjectMap toObjectMap() {
    ObjectMap retVal = new ObjectMap();
<#list query.attributes as attr>
  <#assign attrName = attr.getLabelledOptions('query')['name']!>
  <#assign operator = attr.getLabelledOptions('persistence')['query']!>
  <#assign refObj = modelbase.get_single_reference(attr, model)!>
  <#if attrName == ''>
    <#assign attrName = attr.name>
  </#if>
  <#if operator == ''>
    <#assign operator = '='>
  </#if>
  <#if operator == '[]'>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)}", ${java.nameVariable(attrName)});
    }
  <#elseif operator == '<>'>
    if (${java.nameVariable(attrName)}0 != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)}0", ${java.nameVariable(attrName)}0);
    }
    if (${java.nameVariable(attrName)}1 != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)}1", ${java.nameVariable(attrName)}1);
    }
  <#elseif refObj != ''>
    <#list refObj.attributes as refObjAttr>
      <#if !refObjAttr.isLabelled('query')><#continue></#if>
      <#assign refObjAttrName = refObjAttr.getLabelledOptions('query')['name']!>
      <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('query')['operator']!>
      <#if refObjAttrName == ''>
        <#assign refObjAttrName = refObjAttr.name>
      </#if>
      <#if refObjAttrOperator != '='><#continue></#if>
      <#if refObjAttr.constraint.identifiable>
    if (${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(refObjAttr)?replace('Query', '')}", ${java.nameVariable(attr.name)}${java.nameType(refObjAttrName)});
    }
      <#elseif refObjAttr.type.custom>
        <#-- TODO: 暂时不需要做任何处理，直接忽略 -->
      <#else>
    if (${java.nameVariable(attrName + '_' + refObjAttrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(refObjAttr)?replace('Query', '')}", ${java.nameVariable(attrName + '_' + refObjAttrName)});
    }
      </#if>
    </#list>
  <#elseif attr.type.name == 'string'>
    if (!Strings.isBlank(${java.nameVariable(attrName)})) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)});
    }
  <#elseif attr.type.name == 'bool'>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)} ? Constants.TRUE : Constants.FALSE);
    }
  <#elseif attr.persistenceName??>
    if (${java.nameVariable(attrName)} != null) {
      retVal.set("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}", ${java.nameVariable(attrName)});
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
<#list query.attributes as attr>
  <#assign attrName = attr.getLabelledOptions('query')['name']!>
  <#assign operator = attr.getLabelledOptions('persistence')['query']!>
  <#assign refObj = modelbase.get_single_reference(attr, model)!>
  <#if attrName == ''>
    <#assign attrName = attr.name>
  </#if>
  <#if operator == ''>
    <#assign operator = '='>
  </#if>
  <#if operator == '[]'>
    if (params.containsKey("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}")) {
      get${java.nameType(attrName)}().addAll(params.get("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}"));
    }
  <#elseif operator == '<>'>
    if (params.containsKey("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}0")) {
      set${java.nameType(attrName)}0(Safe.safe(params.get("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}0"), ${modelbase.get_type_name(attr.type)}.class));
    }
    if (params.containsKey("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}1")) {
      set${java.nameType(attrName)}1(Safe.safe(params.get("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}1"), ${modelbase.get_type_name(attr.type)}.class));
    }
  <#elseif refObj != ''>
    <#list refObj.attributes as refObjAttr>
      <#if !refObjAttr.isLabelled('query')><#continue></#if>
      <#assign refObjAttrName = refObjAttr.getLabelledOptions('query')['name']!>
      <#assign refObjAttrOperator = refObjAttr.getLabelledOptions('query')['operator']!>
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
    if (params.containsKey("${java.nameVariable(refObjAttrName)}")) {
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
    if (params.containsKey("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}")) {
      set${java.nameType(attrName)}(Safe.safe(params.get("${modelbase.get_attribute_sql_name(attr)?replace('Query', '')}"), ${modelbase.get_type_name(attr.type)}.class));
    }
  </#if>
</#list>
  }
}
