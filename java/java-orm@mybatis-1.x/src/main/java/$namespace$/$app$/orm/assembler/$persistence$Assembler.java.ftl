<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = persistence>
package <#if namespace??>${namespace}.</#if>${app.name}.orm.assembler;

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
/**
 * 【${modelbase.get_object_label(obj)}】实体各层对象的装配器。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public final class ${typename}Assembler {

  /**
   * 从数据库存储的数据对象中装配【${modelbase.get_object_label(obj)}】实体对象。
   *
   * @param persisted
   *        数据库返回的行列对象
   *
   * @return 装配后的【${modelbase.get_object_label(obj)}】实体对象
   */
  public static ${typename} assemble${typename}FromMap(Map<String,Object> persisted) {
    ${typename} retVal = new ${typename}();
<#list obj.attributes as attr>
  <#if !attr.persistenceName??><#continue></#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign idAttrsRefObj = modelbase.get_id_attributes(refObj)>
    ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)} = (${modelbase4java.type_attribute_primitive(attr)})persisted.get("${modelbase.get_attribute_sql_name(attr)}");
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
<@modelbase4java.print_reference_assemble attr=attr objname="retVal" attrname=modelbase.get_attribute_sql_name(attr) indent=6 />    
    }
  <#else>
    retVal.set${java.nameType(attr.name)}((${modelbase4java.type_attribute_primitive(attr)})persisted.get("${modelbase.get_attribute_sql_name(attr)}"));
  </#if>
</#list>    
    return retVal;
  }
  
  /**
   * 从网络传输对象中装配【${modelbase.get_object_label(obj)}】实体对象。
   *
   * @param query
   *        网络传输对象
   *
   * @return 装配后的【${modelbase.get_object_label(obj)}】实体对象
   */
  public static ${typename} assemble${typename}FromQuery(${typename}Query query) {
    ${typename} retVal = new ${typename}();
<#list obj.attributes as attr>
  <#if !attr.persistenceName??><#continue></#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign idAttrsRefObj = modelbase.get_id_attributes(refObj)>
    ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)} = query.get${java.nameType(modelbase.get_attribute_sql_name(attr))}();
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
<@modelbase4java.print_reference_assemble attr=attr objname="retVal" attrname=modelbase.get_attribute_sql_name(attr) indent=6 />    
    }
  <#else>
    retVal.set${java.nameType(attr.name)}(query.get${java.nameType(modelbase.get_attribute_sql_name(attr))}());
  </#if>
</#list>     
    return retVal;
  }

  private ${typename}Assembler() {}
}
