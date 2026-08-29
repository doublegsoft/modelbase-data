#include <gtest/gtest.h>
#include "${app.name}-poco.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${c.nameType(namespace)}_poco_${c.nameType(obj.name)}, init) {
  ${namespace}_${obj.name}_p obj = ${namespace}_${obj.name}_init();
  
  ASSERT_NE(obj, nullptr);
  EXPECT_STREQ(obj->type_name, "${namespace}_${obj.name}_p");

  <#--
  // Verify raw pointer strings (char*) are initialized to NULL
  EXPECT_EQ(obj->meta_prop_a, nullptr);
  EXPECT_EQ(obj->metable_object_name, nullptr);

  // Verify fixed-length string buffers are empty
  EXPECT_STREQ(obj->meta_prop_b, "");
  EXPECT_STREQ(obj->meta_prop_c, "");
  EXPECT_STREQ(obj->state, "");

  // Verify numerical fields default to INT_MIN
  EXPECT_EQ(obj->metable_object_id, INT_MIN);

  // Verify custom single-relation references are NULL
  EXPECT_EQ(obj->category, nullptr);  -->

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
