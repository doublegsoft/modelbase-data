<#import "/$/modelbase4c.ftl" as modelbase4c>
#include <gtest/gtest.h>
#include "${app.name}-poco.h"
#include "${app.name}-codec.h"
<#list model.objects as obj>
  <#if !obj.isLabelled("protocol")><#continue></#if>

TEST(${c.nameType(namespace)}_codec_${c.nameType(obj.name)}, encode_decode) {
  unsigned char* bytes = NULL;
  size_t size = 0;
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute(attr)>
    <#if attrType.name == "char" && attrType.length??>
  snprintf(obj->${attr.name}, sizeof(obj->${attr.name}), "%s", "DADA");
    <#elseif attrType.name == "char" && attr.type.lengthVariable??>
  obj->${attr.name} = (${attrType.name}*) malloc(3 * sizeof(${attrType.name})); 
  snprintf(obj->${attr.name}, sizeof(obj->${attr.name}), "%s", "ABC");
    <#elseif attr.type.lengthVariable??>
  obj->${attr.name} = (${attrType.name}*) malloc(3 * sizeof(${attrType.name}));  
  obj->${attr.name}[0] = NULL;
  obj->${attr.name}[1] = NULL;
  obj->${attr.name}[2] = NULL;
    <#else>
  obj->${attr.name} = ${modelbase4c.test_unit_value(attr)};
    </#if>
  </#list>
  ${namespace}_${obj.name}_encode(obj, &bytes, &size);
  ${namespace}_${obj.name}_free(obj);

  obj = ${namespace}_${obj.name}_decode(bytes, &size);
  ASSERT_NE(obj, nullptr);
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute(attr)>
    <#if attrType.name == "char" && attrType.length??>
  ASSERT_STREQ(obj->${attr.name}, "DADA");
    <#elseif attrType.name == "char" && attr.type.lengthVariable??>  
  ASSERT_STREQ(obj->${attr.name}, "ABC");
    <#elseif attr.type.lengthVariable??>
    <#else>
  ASSERT_EQ(obj->${attr.name}, ${modelbase4c.test_unit_value(attr)});
    </#if>
  </#list>
  ${namespace}_${obj.name}_free(obj);
  free(bytes);
}
</#list>
