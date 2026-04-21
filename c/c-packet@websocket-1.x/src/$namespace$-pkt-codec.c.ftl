<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "${namespace}-pkt-codec.h"
<#list model.objects as obj>

${namespace}_${obj.name}_p 
${namespace}_${obj.name}_decode(const unsigned char* bytes, 
${""?left_pad(namespace?length + obj.name?length + 9)}size_t buf_len)
{
  ${namespace}_${obj.name}_p ret = ${namespace}_${obj.name}_init();
  size_t offset = 0;
  size_t block_bytes = 0;

  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4c.type_attribute(attr)>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, "ret")?string>
    <#if lenExpr != "0">  
  // ${attr.name}
      <#if attr.type.lengthName??>
  ret->${attr.name} = (${attrtype.name})malloc(${lenExpr});  
      <#elseif attr.type.countedName??>
  ret->${attr.name} = (${attrtype.name})malloc(${lenExpr});
      </#if>
  memcpy((void*)<#if !attr.type.collection && !attr.type.lengthName?? && attrtype.name != "char">&</#if>ret->${attr.name}, bytes + offset, ${lenExpr});
  offset += ${lenExpr};
      <#if attr.type.constant>
        <#if attr.type.name == "int" || attr.type.name == "integer">
  if (ret->${attr.name} != ${attr.type.value?string("###")}) 
        <#else>
  if (strcmp(ret->${attr.name}, "${attr.type.value}") != 0)       
        </#if>
  {
    free(ret);
    return NULL;
  }
      </#if>
    <#else>
      <#assign countedName = modelbase4c.get_attribute_counted_name(attr)>
  block_bytes = 0;    
  for (int i = 0; i < ret->${countedName}; i++) 
    block_bytes += ret->${attr.type.countedName!"出现在这里就是错误"}[i];  
  ret->${attr.name} = (${attrtype.name})malloc(block_bytes);
  memcpy((void*)ret->${attr.name}, bytes + offset, block_bytes);
  offset += block_bytes;  
    </#if>
  </#list>

  return ret;
}

void
${namespace}_${obj.name}_encode(const ${namespace}_${obj.name}_p ${obj.name}, 
${""?left_pad(namespace?length + obj.name?length + 9)}unsigned char** bytes,
${""?left_pad(namespace?length + obj.name?length + 9)}size_t* size)
{
  size_t offset = 0;
  size_t total_bytes = 0;
  size_t block_bytes = 0;
  <#list obj.attributes as attr>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  // ${attr.name}    
    <#if lenExpr != "0">  
  total_bytes += ${lenExpr}; 
    <#else>
      <#assign countedName = modelbase4c.get_attribute_counted_name(attr)>
  for (int i = 0; i < ${obj.name}->${countedName}; i++) 
    total_bytes += ${obj.name}->${attr.type.countedName!"出现在这里就是错误"}[i];  
    </#if>
  </#list>
  *size = total_bytes;
  *bytes = (unsigned char*)malloc(total_bytes);
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4c.type_attribute(attr)>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  // ${attr.name}
    <#if lenExpr != "0">  
  memcpy((*bytes) + offset, <#if !attr.type.collection && attrtype.name != "char" && !attr.type.lengthName?? && !attr.type.countedName??>&</#if>${obj.name}->${attr.name}, ${lenExpr});
  offset += ${lenExpr};
    <#else>
      <#assign countedName = modelbase4c.get_attribute_counted_name(attr)>
  block_bytes = 0;    
  for (int i = 0; i < ${obj.name}->${countedName}; i++) 
    block_bytes += ${obj.name}->${attr.type.countedName!"出现在这里就是错误"}[i];  
  memcpy((*bytes) + offset, ${obj.name}->${attr.name}, block_bytes);
  offset += block_bytes;  
    </#if>
  </#list>
}
</#list>