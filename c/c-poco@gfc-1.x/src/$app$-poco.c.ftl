<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include "${app.name}-poco.h"
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
  ret->count_of_${modelbase4c.name_attribute(attr)} = 0;  
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

    <#if attr.type.componentType??>
      <#if attr.type.componentType.name == "any[]">
void
${namespace}_${obj.name}_add_${modelbase.get_attribute_singular(attr)}_to_${attr.name}(${namespace}_${obj.name}_p ${obj.name}, void* ${modelbase.get_attribute_singular(attr)})
{
  ${obj.name}->count_of_${attr.name}++;
  ${obj.name}->${attr.name} = (void*)realloc(${obj.name}->${attr.name}, sizeof(void*) * ${obj.name}->count_of_${attr.name});
  ${obj.name}->${attr.name}[${obj.name}->count_of_${attr.name} - 1] = ${modelbase.get_attribute_singular(attr)};
}

/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${attr.name}(${namespace}_${obj.name}_p ${obj.name}, void** ${attr.name}, int count)
{
  ${obj.name}->${attr.name} = ${attr.name};
  ${obj.name}->count_of_${attr.name} = count;
}
      <#else>
void
${namespace}_${obj.name}_add_${attr.type.componentType.name}_to_${attr.name}(${namespace}_${obj.name}_p ${obj.name}, ${namespace}_${attr.type.componentType.name}_p ${attr.type.componentType.name}) 
{
  ${obj.name}->count_of_${attr.name}++;
  ${obj.name}->${attr.name} = (${namespace}_${attr.type.componentType.name}_p*)realloc(${obj.name}->${attr.name}, sizeof(${namespace}_${attr.type.componentType.name}_p) * ${obj.name}->count_of_${attr.name});
  ${obj.name}->${attr.name}[${obj.name}->count_of_${attr.name} - 1] = ${attr.type.componentType.name};
}    

void
${namespace}_${obj.name}_set_${attr.name}(${namespace}_${obj.name}_p ${obj.name}, ${namespace}_${attr.type.componentType.name}_p* ${attr.name}, int count) 
{
  ${obj.name}->${attr.name} = ${attr.name};
  ${obj.name}->count_of_${attr.name} = count;
}  
      </#if>
    <#elseif attr.type.custom><#-- 由于自定义数组对象已经判断了，此处优先判断单个引用自定义类型 -->
      <#assign refObj = model.findObjectByName(attr.type.name)>
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p ${obj.name}, ${namespace}_${refObj.name}_p value)
{      
  ${obj.name}->${modelbase4c.name_attribute(attr)} = value;  
}
    <#else>
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p ${obj.name}, <#if attrtype.name == "char*">const </#if>${attrtype.name} value)
{
      <#if attr.name == "state">
  if (value == NULL || strlen(value) == 0) return;
  ${obj.name}->${modelbase4c.name_attribute(attr)}[0] = value[0];
      <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (value == NULL) return;
  strcpy(${obj.name}->${modelbase4c.name_attribute(attr)}, value);
      <#elseif attrtype.name == "char*">
  if (value == NULL) return;
  int len = strlen(value);
  ${obj.name}->${modelbase4c.name_attribute(attr)} = (char*)malloc(sizeof(char) * (len + 1));
  strcpy(${obj.name}->${modelbase4c.name_attribute(attr)}, value);
  ${obj.name}->${modelbase4c.name_attribute(attr)}[len] = '\0';
      <#else>
  ${obj.name}->${modelbase4c.name_attribute(attr)} = value;
      </#if>
}
    </#if>
  </#list>
</#list>