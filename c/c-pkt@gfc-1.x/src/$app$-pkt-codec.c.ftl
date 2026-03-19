<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "${app.name}-pkt-codec.h"
<#list model.objects as obj>

${namespace}_${obj.name}_p 
${namespace}_${obj.name}_decode(const unsigned char* bytes, 
${""?left_pad(namespace?length + obj.name?length + 9)}size_t buf_len)
{
  ${namespace}_${obj.name}_p ret = ${namespace}_${obj.name}_init();
  size_t offset = 0;

  if (buf_len < sizeof(${namespace}_${obj.name}_t)) {
    return NULL; 
  }

  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4c.type_attribute(attr)>
  // ${modelbase.get_attribute_label(attr)}
    <#if attrtype.name == 'char'>
  memcpy(ret->${attr.name}, bytes + offset, ${attrtype.length});
  offset += ${attrtype.length};
    <#elseif attrtype.name == 'char*'>
  ret->${attr.name} = (char*)malloc(sizeof(char) * (buf_len - offset));
  memcpy(ret->${attr.name}, bytes + offset, buf_len - offset);
  offset += buf_len - offset;
    <#elseif attrtype.name == 'int'>
  memcpy((int*)&ret->${attr.name}, bytes + offset, 4);
  offset += 4;
    <#elseif attrtype.name == 'long'>
  memcpy((long*)&ret->${attr.name}, bytes + offset, 8);
  offset += 4;
    </#if>
  </#list>

  return ret;
}
</#list>