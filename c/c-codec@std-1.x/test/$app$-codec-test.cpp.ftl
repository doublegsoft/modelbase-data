<#import "/$/modelbase4c.ftl" as modelbase4c>
#include <gtest/gtest.h>
#include "${app.name}-poco.h"
#include "${app.name}-codec.h"
#include "${app.name}-error.h"
<#list model.objects as obj>
  <#if !obj.isLabelled("protocol")><#continue></#if>

TEST(${c.nameType(namespace)}_codec_${c.nameType(obj.name)}, memory) {
  unsigned char* bytes = NULL;
  size_t size = 0;
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute(attr)>
    <#if attr.name == "magic">
  obj->magic = ${namespace?upper_case}_MAGIC;
    <#elseif attrType.name == "char" && attrType.length??>
  snprintf(obj->${attr.name}, sizeof(obj->${attr.name}), "%s", "DADA");
    <#elseif attrType.name == "char" && attr.type.lengthVariable??>
  obj->${attr.name} = (${attrType.name}*) malloc(3 * sizeof(${attrType.name})); 
  snprintf(obj->${attr.name}, sizeof(obj->${attr.name}), "%s", "ABC");
    <#elseif attrType.name == "short">
  obj->${attr.name} = htons(${modelbase4c.test_unit_value(attr)});
    <#elseif attrType.name == "int" || attrType.name == "long">
  obj->${attr.name} = htonl(${modelbase4c.test_unit_value(attr)});
    <#elseif attr.type.lengthVariable??>
  obj->${attr.name} = (${attrType.name}*) malloc(3 * sizeof(${attrType.name}));
      <#if attr.type.componentType??>
  obj->${attr.name}[0] = ${namespace}_${attr.type.componentType.name}_init();
  obj->${attr.name}[1] = ${namespace}_${attr.type.componentType.name}_init();
  obj->${attr.name}[2] = ${namespace}_${attr.type.componentType.name}_init();
      <#else>
  obj->${attr.name}[0] = 1;
  obj->${attr.name}[1] = 2;
  obj->${attr.name}[2] = 3;
      </#if>
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
    <#if attr.name == "magic">
  ASSERT_EQ(obj->${attr.name}, ${namespace?upper_case}_MAGIC);
    <#elseif attrType.name == "char" && attrType.length??>
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

TEST(${c.nameType(namespace)}_codec_${c.nameType(obj.name)}, file) {
}
</#list>
