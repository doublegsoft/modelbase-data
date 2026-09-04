<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${namespace?upper_case}_PKT_CODEC_H__
#define __${namespace?upper_case}_PKT_CODEC_H__

#ifdef __cplusplus
extern "C"
{
#endif

#include "${c.nameFile(app.name)}-poco.h"
<#list model.objects as obj>
  <#if !obj.isLabelled("protocol")><#continue></#if>

/*!
** Decodes a serialized raw byte buffer into an object instance.
**
** @param bytes The raw byte array containing the serialized data.
** @return      A pointer to the newly allocated and decoded object 
**              (${namespace}_${obj.name}_p). The caller is typically 
**              responsible for freeing this memory.
*/
${namespace}_${obj.name}_p 
${namespace}_${obj.name}_decode(const unsigned char* buf, 
${""?left_pad(namespace?length + obj.name?length + 7)}size_t* size);

/*!
** Serializes (encodes) an object instance into a dynamically allocated byte buffer.
** 
** Note: The function name here is generated as '_decode', but the parameters 
** suggest this is meant to be an '_encode' or '_serialize' function.
**
** @param obj   The object instance to be serialized.
** @param bytes A pointer to a byte array pointer. The function will allocate 
**              the required memory for the serialized data and set *bytes to 
**              point to it. The caller is responsible for freeing this buffer.
** @param size  A pointer to an unsigned int where the function will write 
**              the total size (in bytes) of the newly allocated buffer.
*/
void 
${namespace}_${obj.name}_encode(const ${namespace}_${obj.name}_p obj, 
${""?left_pad(namespace?length + obj.name?length + 7)}unsigned char** bytes, 
${""?left_pad(namespace?length + obj.name?length + 7)}size_t* size);

/*!
** Calculates the total byte size required to serialize (encode) a ${obj.name} instance.
** 
** This function traverses the object hierarchy (including primitive fields, 
** variable-length payloads, and nested child structures) to compute the exact 
** memory footprint needed for binary encoding.
**
** @param obj  The constant ${namespace}_${obj.name}_p instance to be measured.
** @param size A pointer to a size_t variable where the function will write 
**             the total required size (in bytes).
*/
void 
${namespace}_${obj.name}_bytes(const ${namespace}_${obj.name}_p obj, 
${""?left_pad(namespace?length + obj.name?length + 7)}size_t* size);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${namespace?upper_case}_PKT_CODEC_H__
