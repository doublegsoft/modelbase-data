<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service.valid;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.springframework.context.annotation.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.transaction.annotation.*;
import org.springframework.stereotype.*;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.orm.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dao.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign extObjs = modelbase.get_extension_objects(obj)>
<#assign existingVars = {}>
<#assign existingDaos = {}>
/**
 * 【${modelbase.get_object_label(obj)}】存储事务化的服务规范。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
@Component 
public class ${typename}Validation {
<#if !obj.isLabelled("pivot")>
  <#if !existingDaos[obj.name]??>
    <#assign existingDaos += {obj.name: obj}>
    
  @Autowired
  ${java.nameType(obj.name)}DataAccess ${java.nameVariable(obj.name)}DataAccess;
  </#if>
</#if>    
<#list extObjs?keys as extObjName>
  <#assign extObj = model.findObjectByName(extObjName)>
  <#if !existingDaos[objObjName.name]??>
    <#assign existingDaos += {extObjName: extObj}>
    
  @Autowired
  ${java.nameType(extObj.name)}DataAccess ${java.nameVariable(extObj.name)}DataAccess;
  </#if>
</#list>  
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#if !existingVars[attr.type.componentType.name]??>
    <#assign existingVars += {attr.type.componentType.name:""}>
    <#if !existingDaos[attr.type.componentType.name]??>
      <#assign existingDaos += {attr.type.componentType.name: obj}>
      
  @Autowired
  ${java.nameType(attr.type.componentType.name)}DataAccess ${java.nameVariable(attr.type.componentType.name)}DataAccess;
    </#if>
  </#if>
  <#if attr.isLabelled("conjunction") && !existingVars[attr.getLabelledOptions("conjunction")["name"]]??>
    <#assign existingVars += {attr.getLabelledOptions("conjunction")["name"]:""}>
    <#if !existingDaos[attr.getLabelledOptions("conjunction")["name"]]??>
      <#assign existingDaos += {attr.getLabelledOptions("conjunction")["name"]: obj}>
      
  @Autowired
  ${java.nameType(attr.getLabelledOptions("conjunction")["name"])}DataAccess ${java.nameVariable(attr.getLabelledOptions("conjunction")["name"])}DataAccess;
    </#if>
  </#if>
</#list> 

  public ValidationResult validate(${typename}Query query) {
<#-- 必填 -->  
<#list obj.attributes as attr> 
  <#if !attr.constraint.nullable>  
    if (query.${modelbase4java.name_getter(attr)}() == null) {
      return new ValidationResult(false, 404, "${modelbase.get_attribute_label(attr)}为空");
    }
  </#if>
</#list>
<#-- 长度 -->
<#list obj.attributes as attr> 
  <#if attr.type.primitive && modelbase4java.type_attribute_primitive(attr) == "String">  
    <#if (attr.type.length > 0)>
    if (query.${modelbase4java.name_getter(attr)}() != null && query.${modelbase4java.name_getter(attr)}()/*.getBytes()*/.length() > ${attr.type.length?string("#")}) {
      return new ValidationResult(false, 413, "${modelbase.get_attribute_label(attr)}长度过长（>${attr.type.length?string("#")}）");
    }
    </#if>
  </#if>
</#list>
<#-- 唯一 -->
<#list obj.attributes as attr>   
  <#if attr.constraint.unique>
    if (!Strings.isBlank(query.${modelbase4java.name_getter(attr)}())) {
      ${typename}Query existingQuery = new ${typename}Query();
      existingQuery.${modelbase4java.name_setter(attr)}(query.${modelbase4java.name_getter(attr)}());
      List<Map<String,Object>> results = ${java.nameVariable(obj.name)}DataAccess.select${typename}(existingQuery);
      if (results.size() != 0) {
        if (!results.get(0).get("${modelbase.get_attribute_sql_name(idAttrs[0])}").equals(query.${modelbase4java.name_getter(idAttrs[0])}())) {
          return new ValidationResult(false, 409, "${modelbase.get_attribute_label(attr)}已经存在");
        }
      }
    }
  </#if>
</#list>  
    return ValidationResult.SUCCESS;
  }
  
}
