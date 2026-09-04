<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_QUERY_H__
#define __${app.name?upper_case}_QUERY_H__

#include <stdlib.h>

#ifdef __cplusplus
extern "C"
{
#endif

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 【${modelbase.get_object_label(obj)}】查询对象。
*/
struct ${namespace}_${obj.name}_query_s
{
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute_primitive(attr)>
    <#if attrType.length??>
  char* ${modelbase4c.name_attribute_primitive(attr)};
  char* ${modelbase4c.name_attribute_primitive(attr)}0;
  char* ${modelbase4c.name_attribute_primitive(attr)}1;    
    <#else>
  ${attrType.name} ${modelbase4c.name_attribute_primitive(attr)};
  ${attrType.name} ${modelbase4c.name_attribute_primitive(attr)}0;
  ${attrType.name} ${modelbase4c.name_attribute_primitive(attr)}1;  
    </#if>
    <#if attrType.length?? || attrType.name == "char*">
  char* ${modelbase4c.name_attribute_primitive(attr)}2;    
    </#if>
    <#if attr.identifiable || attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
  ${attrType.name}* ${modelbase4c.name_attribute_primitive_plural(attr)};
  int count_of_${modelbase4c.name_attribute_primitive_plural(attr)};
    </#if>
  </#list>
  int   start;
  int   limit;
};
</#list>
<#list model.objects as obj>

/*!
** 【${modelbase.get_object_label(obj)}】查询对象。
*/
typedef struct ${namespace}_${obj.name}_query_s      ${namespace}_${obj.name}_query_t;
typedef        ${namespace}_${obj.name}_query_t*     ${namespace}_${obj.name}_query_p;
</#list>
<#list model.objects as obj>

/*!
** 创建【${modelbase.get_object_label(obj)}】查询对象。
*/
${namespace}_${obj.name}_query_p
${namespace}_${obj.name}_query_init(void);

/*!
** 释放【${modelbase.get_object_label(obj)}】查询对象。
*/
void
${namespace}_${obj.name}_query_free(${namespace}_${obj.name}_query_p ${obj.name});
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_QUERY_H__
