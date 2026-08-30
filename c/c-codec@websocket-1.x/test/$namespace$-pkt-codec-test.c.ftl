<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>

#include "${namespace}-pkt-codec.h"
<#list model.objects as obj>

void
${namespace}_${obj.name}_decode_test(void) 
{
  printf("Running test: ${namespace}_${obj.name}_decode...\n");

  ${namespace}_${obj.name}_t source_obj;
  memset(&source_obj, 0, sizeof(${namespace}_${obj.name}_t));
  ${namespace}_${obj.name}_p ${obj.name} = &source_obj;

<#list obj.attributes as attr>
  <#assign attrtype = modelbase4c.type_attribute(attr)>
  <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  // 初始化属性: ${attr.name}
  <#if attr.constraint.defaultValue??>
    <#if attr.constraint.defaultValue?starts_with("'")>
  memcpy(${obj.name}->${attr.name}, "${attr.constraint.defaultValue?substring(1, attr.constraint.defaultValue?length-1)}", sizeof(${obj.name}->${attr.name}));  
    <#else>
  int ${attr.name}_dflval = ${attr.constraint.defaultValue};
  memcpy(&${obj.name}->${attr.name}, &${attr.name}_dflval, sizeof(${obj.name}->${attr.name}));  
    </#if>
  <#elseif lenExpr != "0">  
    <#-- 固定长度的数据，直接使用 memset 填充模拟值 -->
    <#if modelbase.is_attribute_length_name(attr)>
  ${obj.name}->${attr.name} = 100; 
    <#elseif !attr.type.collection && modelbase.is_attribute_counted_name(attr)>
  ${obj.name}->${attr.name} = 3;
    <#elseif !attr.type.collection && !attr.type.lengthName??><#-- 是固定长度属性 -->
  memset(&${obj.name}->${attr.name}, 0xAA, ${lenExpr});
    <#elseif attr.type.lengthName??>
  ${obj.name}->${attr.name} = (${attrtype.name})malloc(${obj.name}->${attr.type.lengthName});  
  memset(${obj.name}->${attr.name}, 0xBB, ${lenExpr});
    <#else>
      <#assign attrtype = modelbase4c.type_attribute(attr)>
      <#if modelbase.is_attribute_counted_name(attr)>
  ${obj.name}->${attr.name} = malloc(3 * sizeof(int)); // 根据实际类型强转
  ${obj.name}->${attr.name}[0] = 100;
  ${obj.name}->${attr.name}[1] = 200;
  ${obj.name}->${attr.name}[2] = 300;    
      <#else>
  ${obj.name}->${attr.name} = (${attrtype.name})malloc(${lenExpr});  
  memset(${obj.name}->${attr.name}, 0xCC, ${lenExpr});
      </#if>
    </#if>
  <#else>
    <#-- 动态变长数据，需要分配内存并填充长度数组 -->
    <#assign countedName = modelbase4c.get_attribute_counted_name(attr)>
    <#assign lengthsArray = attr.type.countedName!"ERROR_MISSING_COUNTED_NAME">
  size_t ${attr.name}_block_bytes = 0;
  for (int i = 0; i < 3; i++)
    ${attr.name}_block_bytes += ${obj.name}->${lengthsArray}[i];
  ${obj.name}->${attr.name} = malloc(${attr.name}_block_bytes);
  memset(${obj.name}->${attr.name}, 0xCC, ${attr.name}_block_bytes);
  </#if>
</#list>
  
  // 注意：为了防止未初始化的动态数组导致越界，计数器 (countedName) 保持为 0，
  // 这样 Encode 时只会编码基础字段。如需测试变长数组，可在此手动 malloc 并设置计数值。

  unsigned char* encoded_bytes = NULL;
  size_t encoded_size = 0;

  // 调用对应的 encode 函数，生成合法的 byte buffer
  ${namespace}_${obj.name}_encode(${obj.name}, &encoded_bytes, &encoded_size);
  assert(encoded_bytes != NULL);

  // 为了通过 decode 内部 "buf_len < sizeof(struct)" 的安全检查：
  // 如果实际编码长度小于结构体大小（因为指针本身占空间但不序列化指针地址），需补齐 buffer 长度
  size_t test_buf_len = encoded_size > sizeof(${namespace}_${obj.name}_t) ? encoded_size : sizeof(${namespace}_${obj.name}_t);

  unsigned char* decode_buffer = (unsigned char*)calloc(1, test_buf_len);
  memcpy(decode_buffer, encoded_bytes, encoded_size);

  // ==========================================
  // 2. Act: 执行 Decode 函数
  // ==========================================
  ${namespace}_${obj.name}_p decoded_obj = ${namespace}_${obj.name}_decode(decode_buffer, test_buf_len);

  // ==========================================
  // 3. Assert: 验证反序列化结果是否与源数据一致
  // ==========================================
  assert(decoded_obj != NULL);
  
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4c.type_attribute(attr)>
  <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  <#if lenExpr != "0">
  // 验证固定长度字段: ${attr.name}
    <#if attr.type.lengthName?? || attr.type.countedName?? || attrtype.name == "char">
  assert(memcmp(source_obj.${attr.name}, decoded_obj->${attr.name}, ${lenExpr}) == 0);
    <#else>
  assert(memcmp(&source_obj.${attr.name}, &decoded_obj->${attr.name}, ${lenExpr}) == 0);
    </#if>
  </#if>
</#list>

  // ==========================================
  // 4. Cleanup: 释放内存防泄漏
  // ==========================================
  free(encoded_bytes);
  free(decode_buffer);
  
  // 释放 Decode 动态生成的对象 (需确保内部动态分配的字段也被 free)
  if (decoded_obj != NULL) {
    // TODO: 如果解码时给变长字段分配了内存，需在此一并 free
    free(decoded_obj); 
  }

  printf("Test passed: ${namespace}_${obj.name}_decode\n");
}

void
${namespace}_${obj.name}_encode_test(void) 
{
  printf("Running test: ${namespace}_${obj.name}_encode...\n");
  ${namespace}_${obj.name}_t dummy_obj;
  memset(&dummy_obj, 0, sizeof(${namespace}_${obj.name}_t));
  ${namespace}_${obj.name}_p ${obj.name} = &dummy_obj;

  size_t expected_total_size = 0;

<#list obj.attributes as attr>
  <#assign attrtype = modelbase4c.type_attribute(attr)>
  <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  // 初始化属性: ${attr.name}
  <#if attr.constraint.defaultValue??>
    <#if attr.constraint.defaultValue?starts_with("'")>
  memcpy(${obj.name}->${attr.name}, "${attr.constraint.defaultValue?substring(1, attr.constraint.defaultValue?length-1)}", sizeof(${obj.name}->${attr.name}));  
    <#else>
  int ${attr.name}_dflval = ${attr.constraint.defaultValue};
  memcpy(&${obj.name}->${attr.name}, &${attr.name}_dflval, sizeof(${obj.name}->${attr.name}));  
    </#if>
  expected_total_size += sizeof(${obj.name}->${attr.name});  
  <#elseif lenExpr != "0">  
    <#-- 固定长度的数据，直接使用 memset 填充模拟值 -->
    <#if modelbase.is_attribute_length_name(attr)>
  ${obj.name}->${attr.name} = 100; 
  expected_total_size += ${lenExpr};  
    <#elseif !attr.type.collection && modelbase.is_attribute_counted_name(attr)>
  ${obj.name}->${attr.name} = 3;
  expected_total_size += ${lenExpr};
    <#elseif !attr.type.collection && !attr.type.lengthName??><#-- 是固定长度属性 -->
  memset(&${obj.name}->${attr.name}, 0xAA, ${lenExpr});
  expected_total_size += ${lenExpr};
    <#elseif attr.type.lengthName??>
  ${obj.name}->${attr.name} = (${attrtype.name})malloc(${obj.name}->${attr.type.lengthName});  
  memset(${obj.name}->${attr.name}, 0xBB, ${lenExpr});
  expected_total_size += ${lenExpr};
    <#else>
      <#assign attrtype = modelbase4c.type_attribute(attr)>
      <#if modelbase.is_attribute_counted_name(attr)>
  ${obj.name}->${attr.name} = malloc(3 * sizeof(int)); // 根据实际类型强转
  ${obj.name}->${attr.name}[0] = 100;
  ${obj.name}->${attr.name}[1] = 200;
  ${obj.name}->${attr.name}[2] = 300;    
  expected_total_size += 3 * sizeof(int);
      <#else>
  ${obj.name}->${attr.name} = (${attrtype.name})malloc(${lenExpr});  
  memset(${obj.name}->${attr.name}, 0xCC, ${lenExpr});
  expected_total_size += ${lenExpr};
      </#if>
    </#if>
  <#else>
    <#-- 动态变长数据，需要分配内存并填充长度数组 -->
    <#assign countedName = modelbase4c.get_attribute_counted_name(attr)>
    <#assign lengthsArray = attr.type.countedName!"ERROR_MISSING_COUNTED_NAME">
  size_t ${attr.name}_block_bytes = 0;
  for (int i = 0; i < 3; i++)
    ${attr.name}_block_bytes += ${obj.name}->${lengthsArray}[i];
  ${obj.name}->${attr.name} = malloc(${attr.name}_block_bytes);
  memset(${obj.name}->${attr.name}, 0xCC, ${attr.name}_block_bytes);

  expected_total_size += ${attr.name}_block_bytes;
  </#if>
</#list>
  unsigned char* encoded_bytes = NULL;
  size_t encoded_size = 0;

  ${namespace}_${obj.name}_encode(${obj.name}, &encoded_bytes, &encoded_size);

  assert(encoded_bytes != NULL);
  assert(encoded_size == expected_total_size);

<#list obj.attributes as attr>
  <#assign lenExpr = modelbase4c.get_attribute_bytes(attr, obj.name)?string>
  <#if lenExpr == "0">
    <#assign lengthsArray = attr.type.countedName!"ERROR">
  free(${obj.name}->${lengthsArray});
  free(${obj.name}->${attr.name});
  </#if>
</#list>
  free(encoded_bytes);

  printf("Test passed: ${namespace}_${obj.name}_encode\n");
}
</#list>

int main(int argc, char* argv[])
{
<#list model.objects as obj>
  ${namespace}_${obj.name}_decode_test();
  ${namespace}_${obj.name}_encode_test();
</#list>   
  return 0;
}