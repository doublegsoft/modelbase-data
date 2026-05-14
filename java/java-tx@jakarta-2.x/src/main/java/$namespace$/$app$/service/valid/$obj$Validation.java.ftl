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
import jakarta.inject.*;

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
<#assign existings = {}>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", obj, model)>
<#assign flow = typeDef.flow>
/**
 * 【${modelbase.get_object_label(obj)}】存储事务化的服务规范。
 */
@Named 
public class ${typename}Validation {
<#list flow.types as typeObj>
  <#if existings[typeObj.name]??><#continue></#if>
  <#assign typeRefType = typeDef.getReferenceType(typeObj)>
  <#if typeRefType == "SREF">

  @Inject
  private ${java.nameType(typeDef.name)}DataAccess ${java.nameVariable(typeDef.name)}DataAccess;
  <#else>

  @Inject
  private ${java.nameType(typeObj.name)}Service ${java.nameVariable(typeObj.name)}Service;
  </#if>
  <#assign existings += {typeObj.name: typeObj}>
</#list>   

  public ValidationResult validate(${typename}Query query) {
    return validate(query, true);
  }

  public ValidationResult validate(${typename}Query query, boolean checkNull) {
<#-- 必填 -->  
<#list obj.attributes as attr> 
  <#if !attr.constraint.nullable>  
    if (query.${modelbase4java.name_getter(attr)}() == null && checkNull) {
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
