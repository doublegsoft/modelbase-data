<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "${c.nameFile(app.name)}-codec.h"
<#list model.objects as obj>
  <#if !obj.isLabelled("protocol")><#continue></#if>

${namespace}_${obj.name}_p 
${namespace}_${obj.name}_decode(const unsigned char* bytes, 
${""?left_pad(namespace?length + obj.name?length + 7)}size_t* size)
{
  ${namespace}_${obj.name}_p ret = ${namespace}_${obj.name}_init();
  size_t offset = 0;
  size_t block_bytes = 0;

  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute(attr)>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, "ret")?string>
    <#if lenExpr != "0">  
  // ${attr.name}
      <#if attr.type.lengthVariable??>
  ret->${attr.name} = (${attrType.name}*)malloc(${lenExpr});  
      </#if>
      <#if attrType.name == "char" && !attr.type.lengthVariable?? && !attrType.length??>
  ret->${attr.name} = bytes[offset];
      <#else>
  memcpy((void*)<#if !attr.type.collection && !attr.type.lengthVariable?? && !attrType.length??>&</#if>ret->${attr.name}, bytes + offset, ${lenExpr});
      </#if>
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
      <#assign lengthVariable = modelbase4c.get_attribute_length_variable(attr)>
  block_bytes = 0;
      <#if attr.type.componentType.custom>
  ret->${attr.name} = (${attrType.name}*) malloc(ret->${lengthVariable} * sizeof(${attrType.name}));
  for (int i = 0; i < ret->${lengthVariable}; i++) 
  {
    block_bytes = 0;
    ${namespace}_${attr.type.componentType.name}_p row = ${namespace}_${attr.type.componentType.name}_decode(bytes + offset, &block_bytes); 
    ret->${attr.name}[i] = row;
    offset += block_bytes;  
  }
      </#if>
  offset += block_bytes; 
    </#if>  
  </#list>
  *size = offset;
  return ret;
}

void
${namespace}_${obj.name}_encode(const ${namespace}_${obj.name}_p ${obj.name}, 
${""?left_pad(namespace?length + obj.name?length + 7)}unsigned char** bytes,
${""?left_pad(namespace?length + obj.name?length + 7)}size_t* size)
{
  size_t offset = 0;
  size_t block_bytes = 0;
  size_t total_bytes = 0;

  ${namespace}_${obj.name}_bytes(${obj.name}, &total_bytes);
  *bytes = (unsigned char*)malloc(total_bytes);
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute(attr)>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  // ${attr.name}
    <#if lenExpr != "0">
  memcpy((*bytes) + offset, <#if !attr.type.collection && !attrType.length?? && !attr.type.lengthVariable??>&</#if>${obj.name}->${attr.name}, ${lenExpr});
  offset += ${lenExpr};
    <#else>
      <#assign lengthVariable = modelbase4c.get_attribute_length_variable(attr)>
  for (int i = 0; i < ${obj.name}->${lengthVariable}; i++) 
  {
    block_bytes = 0;    
    ${namespace}_${attr.type.componentType.name}_p row = ${obj.name}->${attr.name}[i];
    if (row != NULL)
    {
      ${namespace}_${attr.type.componentType.name}_encode(row, bytes + offset, &block_bytes);
      offset += block_bytes;
    }
  }
    </#if>
  </#list>
  *size = total_bytes;
}

void 
${namespace}_${obj.name}_bytes(const ${namespace}_${obj.name}_p obj, 
${""?left_pad(namespace?length + obj.name?length + 7)}size_t* size)
{
  size_t total_bytes = 0;
  size_t block_bytes = 0;
  <#list obj.attributes as attr>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, "obj")?string>
  // ${attr.name}    
    <#if lenExpr != "0">  
  total_bytes += ${lenExpr}; 
    <#else>
      <#assign lengthVariable = modelbase4c.get_attribute_length_variable(attr)>
  for (int i = 0; i < obj->${lengthVariable}; i++) 
  {
    block_bytes = 0;
    ${namespace}_${attr.type.componentType.name}_p row = obj->${attr.name}[i];
    if (row != NULL)
    {
      ${namespace}_${attr.type.componentType.name}_bytes(row, &block_bytes);
      total_bytes += block_bytes;
    }
  }
    </#if>
  </#list>
  *size = total_bytes;
}
</#list>