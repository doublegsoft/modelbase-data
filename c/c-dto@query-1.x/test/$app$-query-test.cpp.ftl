#include <gtest/gtest.h>
#include "${app.name}-query.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${c.nameType(namespace)}_${c.nameType(obj.name)}_query, init) {
  ${namespace}_${obj.name}_query_p obj = ${namespace}_${obj.name}_query_init();
  
  ASSERT_NE(obj, nullptr);

  ${namespace}_${obj.name}_query_free(obj);
}
</#list>
