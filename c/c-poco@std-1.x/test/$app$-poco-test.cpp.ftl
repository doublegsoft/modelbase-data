#include <gtest/gtest.h>
#include "${app.name}-poco.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${c.nameType(namespace)}_poco_${c.nameType(obj.name)}, init) {
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();
  
  ASSERT_NE(obj, nullptr);
  EXPECT_STREQ(obj->type_name, "${namespace}_${obj.name}_p");
  
  ${namespace}_${obj.name}_free(obj);
}

TEST(${c.nameType(namespace)}_poco_${c.nameType(obj.name)}, xetter_basic) {
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();

  ASSERT_NE(obj, nullptr);
  EXPECT_STREQ(obj->type_name, "${namespace}_${obj.name}_p");

  ${namespace}_${obj.name}_free(obj);
}

TEST(${c.nameType(namespace)}_poco_${c.nameType(obj.name)}, xetter_custom) {
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();

  ASSERT_NE(obj, nullptr);
  EXPECT_STREQ(obj->type_name, "${namespace}_${obj.name}_p");

  ${namespace}_${obj.name}_free(obj);
}

TEST(${c.nameType(namespace)}_poco_${c.nameType(obj.name)}, xetter_collection) {
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();

  ASSERT_NE(obj, nullptr);
  EXPECT_STREQ(obj->type_name, "${namespace}_${obj.name}_p");

  ${namespace}_${obj.name}_free(obj);
}
</#list>
