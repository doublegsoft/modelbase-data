<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_PROTO_H__
#define __${app.name?upper_case}_PROTO_H__

#include <stdio.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef unsigned char         byte;
typedef unsigned long         ulong;
typedef unsigned int          uint;
<#assign sortedObjects = appbase.sort_objects(model.objects)>
<#list sortedObjects as obj>

/*!
** 【${modelbase.get_object_label(obj)}】数据结构定义。
*/
typedef struct {
  <#list obj.attributes as attr>

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】，${attr.type.length!""} bytes.
  */  
    <#if attr.type.name == "string">
      <#if attr.isLabelled("varsized")>
  char* ${attr.name};    
  uint  ${attr.name}_len;
      <#else>
        <#if attr.type.length?? && attr.type.length != 0>
  char ${attr.name}[${attr.type.length}];
        <#else>
  char* ${attr.name};
        </#if>
      </#if>
    <#elseif attr.type.name == "byte">
      <#if attr.isLabelled("varsized")>
  byte* ${attr.name};    
  uint  ${attr.name}_len;
      <#else>
  byte ${attr.name}[${attr.type.length!"0"}];
      </#if>
    <#elseif attr.type.isCustom()>
  ${app.name}_${appbase.get_domain_type_name(attr.constraint.domainType)}_t ${attr.name};
    <#elseif attr.type.isDomain()>
      <#if attr.constraint.domainType.name == "any">
  void* ${attr.name};
  uint  ${attr.name}_len;
      </#if>
    <#elseif attr.type.name == "int">
  uint ${attr.name};
    <#else>
  ${attr.type.name} ${attr.name};
    </#if>
  </#list>
} 
${app.name}_${obj.name}_t; 
</#list>
<#list model.objects as obj>

/*!
** 初始化【${modelbase.get_object_label(obj)}】结构体。
*/
void
${app.name}_init_${obj.name}(${app.name}_${obj.name}_t* pd);

/*!
** 从文件中获得【${modelbase.get_object_label(obj)}】结构体。
*/
int
${app.name}_read_${obj.name}(${app.name}_${obj.name}_t* pd, FILE* fp);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_PROTO_H__
