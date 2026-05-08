<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = persistence>
<#macro print_reference_assemble attr objname attrname indent>
  <#local refObj = model.findObjectByName(attr.type.name)>
  <#local idAttrs = modelbase.get_id_attributes(refObj)>
${""?left_pad(indent)}${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});  
  <#if idAttrs[0].type.custom>
<@print_reference_assemble attr=idAttrs[0] objname=java.nameVariable(refObj.name) attrname=attrname indent=indent />  
  <#else>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(idAttrs[0].name)}(${attrname});  
  </#if>
</#macro>
package <#if namespace??>${namespace}.</#if>${app.name}.dao;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.annotations.*;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

/**
 * 【${modelbase.get_object_label(composite)}】合成对象的装配器。
 *
 * @since ${version}
 */
@Mapper 
public interface ${java.nameType(composite.name)}DataAccess {
  
  List<${java.nameType(composite.name)}Query> select${java.nameType(composite.name)}Query(${java.nameType(composite.name)}Query query);
  
}
