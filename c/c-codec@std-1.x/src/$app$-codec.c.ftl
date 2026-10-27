<#setting number_format="computer">
<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
  #include <winsock2.h>
  #pragma comment(lib, "ws2_32.lib")
#else
  #include <arpa/inet.h>
#endif

#include "${c.nameFile(app.name)}-codec.h"
#include "${c.nameFile(app.name)}-error.h"
<#list model.objects as obj>
  <#if !obj.isLabelled("protocol")><#continue></#if>

${namespace}_${obj.name}_p 
${namespace}_${obj.name}_decode(const unsigned char* bytes, 
${""?left_pad(namespace?length + obj.name?length + 9)}size_t* size)
{
  size_t offset = 0;
<#list obj.attributes as attr>
  <#if attr.name != "magic"><#continue></#if>
  <#assign attrType = modelbase4c.type_attribute(attr)>
  <#if attrType.name == "short" || attrType.name == "uint16_t">
  short magic = 0;
  memcpy((void*)&magic, bytes, 2);
  magic = ntohs(magic);
  offset += 2;
  <#elseif attrType.name == "int" || attrType.name == "uint32_t">
  int magic = 0;
  memcpy((void*)&magic, bytes, 4);
  magic = ntohl(magic);
  offset += 4;
  <#elseif attrType.name == "uint64_t">
  long long magic = 0;
  memcpy((void*)&magic, bytes, 8);
  magic = ntohll(magic);
  offset += 8;
  </#if>
  if (magic != ${namespace?upper_case}_MAGIC) 
    return NULL;
  <#break>
</#list>
  ${namespace}_${obj.name}_p ret = ${namespace}_${obj.name}_init();
  size_t block_bytes = 0;

  <#list obj.attributes as attr>
    <#if attr.name == "magic">
  ret->magic = magic;
      <#continue>
    </#if>
    <#assign attrType = modelbase4c.type_attribute(attr)>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, "ret")?string>
  // ${attr.name}
    <#if lenExpr != "0">  
      <#if attr.type.lengthVariable??>
        <#assign lengthVariable = modelbase4c.get_attribute_length_variable(attr)>
  ret->${attr.name} = (${attrType.name}*)malloc(ret->${lengthVariable});  
  memcpy((void*)<#if !attr.type.collection && !attr.type.lengthVariable?? && !attrType.length??>&</#if>ret->${attr.name}, bytes + offset, ret->${lengthVariable});
  offset += ret->${lengthVariable};
      <#elseif attrType.name == "char" && !attr.type.lengthVariable?? && !attrType.length??>
  ret->${attr.name} = bytes[offset];
  offset += ${lenExpr};
      <#elseif attrType.name == "short" || attrType.name == "uint16_t">
  ${attrType.name} raw_${attr.name} = 0;
  memcpy(&raw_${attr.name}, bytes + offset, 2);
  ret->${attr.name} = ntohs(raw_${attr.name});
  offset += 2;
      <#elseif attrType.name == "int" || attrType.name == "uint32_t">
  ${attrType.name} raw_${attr.name} = 0;
  memcpy(&raw_${attr.name}, bytes + offset, 4);
  ret->${attr.name} = ntohl(raw_${attr.name});
  offset += 4;
      <#elseif attrType.name == "uint64_t">
  ${attrType.name} raw_${attr.name} = 0;
  memcpy(&raw_${attr.name}, bytes + offset, 8);
  ret->${attr.name} = ntohl(raw_${attr.name});
  offset += 8;
      <#else>
  memcpy((void*)<#if !attr.type.collection && !attr.type.lengthVariable?? && !attrType.length??>&</#if>ret->${attr.name}, bytes + offset, ${lenExpr});
  offset += ${lenExpr};
      </#if>
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
    <#elseif attr.type.componentType??>
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
${""?left_pad(namespace?length + obj.name?length + 9)}unsigned char** bytes,
${""?left_pad(namespace?length + obj.name?length + 9)}size_t* size)
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
      <#if attr.type.lengthVariable??>
        <#assign lengthVariable = modelbase4c.get_attribute_length_variable(attr)>
  memcpy((*bytes) + offset, <#if !attr.type.collection && !attrType.length?? && !attr.type.lengthVariable??>&</#if>${obj.name}->${attr.name}, ${obj.name}->${lengthVariable});
  offset += ${obj.name}->${lengthVariable};
      <#elseif attrType.name == "short" || attrType.name == "uint16_t">
  short raw_${attr.name} = htons(${obj.name}->${attr.name});
  memcpy((*bytes) + offset, &raw_${attr.name}, 2);   
  offset += 2;
      <#elseif attrType.name == "int" || attrType.name == "uint32_t">
  int raw_${attr.name} = htonl(${obj.name}->${attr.name});
  memcpy((*bytes) + offset, &raw_${attr.name}, 4);  
  offset += 4; 
      <#elseif attrType.name == "uint64_t">
  uint64_t raw_${attr.name} = htonll(${obj.name}->${attr.name});
  memcpy((*bytes) + offset, &raw_${attr.name}, 8);    
  offset += 8; 
      <#else>
  memcpy((*bytes) + offset, <#if !attr.type.collection && !attrType.length?? && !attr.type.lengthVariable??>&</#if>${obj.name}->${attr.name}, ${lenExpr});
  offset += ${lenExpr};
      </#if>
    <#elseif attr.type.componentType??>
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
${""?left_pad(namespace?length + obj.name?length + 8)}size_t* size)
{
  size_t total_bytes = 0;
  size_t block_bytes = 0;
  <#list obj.attributes as attr>
    <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, "obj")?string>
  // ${attr.name}    
    <#if lenExpr != "0">
      <#if attr.type.lengthVariable??>
        <#assign lengthVariable = modelbase4c.get_attribute_length_variable(attr)>
  total_bytes += obj->${lengthVariable};
      <#else>
  total_bytes += ${lenExpr}; 
      </#if>
    <#elseif attr.type.componentType??>
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