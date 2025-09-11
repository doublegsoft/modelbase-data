
<#import "/$/modelbase.ftl" as modelbase>
<#--!
 --- print attribute select statement in sql variable in extract.groovy file.
 -->
<#macro print_select_in_sql_variable obj attr types indent>
  <#if !attr.persistenceName??><#return></#if>
  <#if attr.type.custom>
${""?right_pad(indent)}"${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName},"  
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#if types[refObj.name]??><#return></#if>
    <#list refObj.attributes as refAttr>
<@print_select_in_sql_variable obj=refObj attr=refAttr types=types indent=indent />
    </#list>
    <#global types = types + {refObj.name: ''}>
  <#else>
${""?right_pad(indent)}"${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName},"
  </#if>
</#macro>

<#--
 --- print attribute left-join statement in sql variable in extract.groovy file.
 -->
<#macro print_leftjoin_in_sql_variable obj attr types indent>
  <#assign objAttrId = modelbase.get_id_attributes(obj)[0]>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#if types[refObj.name]??><#return></#if>
    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
${""?right_pad(indent)}"left join ${refObj.persistenceName} ${modelbase.get_object_sql_alias(refObj)} on ${modelbase.get_object_sql_alias(refObj)}.${refObjAttrId.persistenceName} = ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} "
    <#list refObj.attributes as refAttr>
<@print_leftjoin_in_sql_variable obj=refObj attr=refAttr types=types indent=indent />    
    </#list>
    <#global types = types + {refObj.name: ''}>
  </#if>
</#macro>

<#macro print_ids_variable obj visitedObjs level indent>
  <#global visitedObjs = visitedObjs + {obj.name: level}>
  <#assign objAttrId = modelbase.get_id_attributes(obj)[0]>
  <#list obj.attributes as attr>
    <#if attr.type.custom>
      <#if visitedObjs[obj.name]?? && (visitedObjs[obj.name] > 1)><#return></#if>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
Set<String> ${modelbase.get_attribute_sql_name(refObjAttrId)}s = new HashSet<>()  
      <#list refObj.attributes as refAttr>
<@print_ids_variable obj=refObj visitedObjs=visitedObjs level=level+1 indent=indent />    
      </#list>
    </#if>
  </#list>
</#macro>

