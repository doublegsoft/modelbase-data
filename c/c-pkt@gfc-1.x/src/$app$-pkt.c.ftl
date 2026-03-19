<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include "${app.name}-pkt.h"
<#list model.objects as obj>

${namespace}_${obj.name}_p
${namespace}_${obj.name}_init(void)
{
  ${namespace}_${obj.name}_p ret = (${namespace}_${obj.name}_p) malloc(sizeof(${namespace}_${obj.name}_t));
  strcpy(ret->typename, "${namespace}_${obj.name}_p");
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4c.type_attribute(attr)>
  <#if attr.type.componentType??><#-- 优先判断，是否是自定义数组类型的对象 -->
  ret->${modelbase4c.name_attribute(attr)} = NULL;
  <#elseif attr.type.custom><#-- 其次判断单个引用自定义类型 -->
  ret->${modelbase4c.name_attribute(attr)} = NULL;  
  <#elseif attr.constraint.domainType.name?starts_with("enum")>
  ret->${modelbase4c.name_attribute(attr)}[0] = '\0';
  <#elseif attr.name == "state">
  ret->${modelbase4c.name_attribute(attr)}[0] = '\0';
  <#elseif attrtype.name == "char*">
  ret->${modelbase4c.name_attribute(attr)} = NULL;
  <#elseif attrtype.name == "int" || attrtype.name == "long">
  ret->${modelbase4c.name_attribute(attr)} = INT_MIN;
  <#elseif attrtype.name == "char" || attrtype.length??>
  ret->${modelbase4c.name_attribute(attr)}[0] = '\0';
  <#elseif attrtype.name == "char">
  ret->${modelbase4c.name_attribute(attr)} = '\0';
  </#if>
</#list>
  return ret;
}

void
${namespace}_${obj.name}_free(${namespace}_${obj.name}_p ${obj.name})
{
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4c.type_attribute(attr)>
  <#-- 忽略掉的几种无需释放内容的属性 -->
  <#if attr.constraint.domainType.name?starts_with("enum") || attr.name == "state"><#continue></#if>
  <#if attr.type.componentType??><#-- 优先判断，是否是自定义数组类型的对象 -->
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)});
  <#elseif attr.type.custom><#-- 其次判断单个引用自定义类型 -->
    <#assign refObj = model.findObjectByName(attr.type.name)>
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
    ${namespace}_${refObj.name}_free(${obj.name}->${modelbase4c.name_attribute(attr)});
  <#elseif attrtype.name == "char*">
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL) 
    free(${obj.name}->${modelbase4c.name_attribute(attr)});
  </#if>
</#list>
  free(${obj.name});
}
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4c.type_attribute(attr)>

    <#if attr.type.custom><#-- 由于自定义数组对象已经判断了，此处优先判断单个引用自定义类型 -->
      <#assign refObj = model.findObjectByName(attr.type.name)>
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p ${obj.name}, ${namespace}_${refObj.name}_p value)
{      
  ${obj.name}->${modelbase4c.name_attribute(attr)} = value;  
}
    <#elseif attrtype.name?contains("*")>
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p ${obj.name}, const ${attrtype.name} value, size_t len)
{
  ${obj.name}->${modelbase4c.name_attribute(attr)} = (${attrtype.name})malloc(sizeof(char) * (len));
  memcpy(${obj.name}->${modelbase4c.name_attribute(attr)}, value, len);
}     
    <#elseif attrtype.name == "char" && attrtype.length??>
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p ${obj.name}, <#if attrtype.name == "char*" || (attrtype.name == "char" && attrtype.length??)>const char*<#else>${attrtype.name}</#if> value, size_t len)
{
  memcpy(${obj.name}->${modelbase4c.name_attribute(attr)}, value, len);
}    
    
    <#else>
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p ${obj.name}, <#if attrtype.name == "char*" || (attrtype.name == "char" && attrtype.length??)>const char*<#else>${attrtype.name}</#if> value)
{
  ${obj.name}->${modelbase4c.name_attribute(attr)} = value;
}
    </#if>
  </#list>
</#list>