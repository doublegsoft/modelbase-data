#include <gtest/gtest.h>
#include "${app.name}-poco.h"
#include "${app.name}-query.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${c.nameType(namespace)}_json_${c.nameType(obj.name)}, parse) {
  
}

TEST(${c.nameType(namespace)}_json_${c.nameType(obj.name)}, assemble) {
  
}
</#list>
