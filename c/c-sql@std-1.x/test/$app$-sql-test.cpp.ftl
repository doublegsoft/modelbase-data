#include <iostream>
#include <gtest/gtest.h>
#include "${app.name}-sql.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${namespace}_sql_${obj.name}, select) {
  ${namespace}_${obj.name}_query_p query = ${namespace}_${obj.name}_query_init();
  int bind_count = 0;
  char sql_select[4096] = {'\0'};
  int rc = ${namespace}_sql_${obj.name}_select(query, sql_select, &bind_count);
  EXPECT_EQ(rc, ${namespace?upper_case}_SQL_ERROR_SUCCESS);

  SCOPED_TRACE(testing::Message() << "sql: " << sql_select);
}
</#list>
