#include <gtest/gtest.h>
#include "${app.name}-poco.h"
#include "${app.name}-query.h"
#include "${app.name}-util.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${c.nameType(namespace)}_json_${c.nameType(obj.name)}, parse) {
  char* json_str = ${namespace}_file_read("../../test/json/${c.nameFile(obj.name)}.json");
  ASSERT_TRUE(json_str != NULL);

  ${c.nameType(namespace)}_${c.nameType(obj.name)}_query_p query = ${c.nameType(namespace)}_${c.nameType(obj.name)}_query_parse(json_str);
  ASSERT_TRUE(query != NULL);
}

TEST(${c.nameType(namespace)}_json_${c.nameType(obj.name)}, assemble) {
  
}
</#list>
