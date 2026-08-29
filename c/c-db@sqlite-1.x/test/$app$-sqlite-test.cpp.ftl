<#import "/$/modelbase4c.ftl" as modelbase4c>
#include <iostream>
#include <fstream>
#include <string>
#include <iterator>
#include <gtest/gtest.h>
#include "${app.name}-query.h"
#include "${app.name}-sqlite.h"
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

TEST(${c.nameType(namespace)}_sqlite3_${c.nameType(obj.name)}, crud) {
  sqlite3* conn;
  sqlite3_open("./test.db", &conn);
  
  ASSERT_NE(conn, nullptr);

  std::ifstream file("../../sql/install-database-sqlite.sql");
  std::string sql = std::string((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
  char* errMsg = nullptr;
  sqlite3_exec(conn, sql.c_str(), nullptr, nullptr, &errMsg);

  ${namespace}_table_result_p result;
  char errmsg[4096] = {'\0'};
  ${namespace}_${obj.name}_query_p query = ${namespace}_${obj.name}_query_init();
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute_primitive(attr)>
    <#if attrType.name == "int" || attrType.name == "long" || attrType.name == "double">
  query->${modelbase4c.name_attribute_primitive(attr)} = 10; 
    <#else>
  query->${modelbase4c.name_attribute_primitive(attr)} = const_cast<char*>("有值");
    </#if>  
  </#list>
  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  rc = ${namespace}_sqlite_${obj.name}_delete(conn, query, errmsg);
  ASSERT_EQ(rc, ${namespace?upper_case}_SQL_ERROR_SUCCESS) << "delete error (" << rc << "): " << errmsg;

  rc = ${namespace}_sqlite_${obj.name}_insert(conn, query, errmsg);
  ASSERT_EQ(rc, ${namespace?upper_case}_SQL_ERROR_SUCCESS) << "insert error (" << rc << "): " << errmsg;

  rc = ${namespace}_sqlite_${obj.name}_update(conn, query, errmsg);
  ASSERT_EQ(rc, ${namespace?upper_case}_SQL_ERROR_SUCCESS) << "update error (" << rc << "): " << errmsg;

  rc = ${namespace}_sqlite_${obj.name}_select(conn, query, errmsg, &result);
  ASSERT_EQ(rc, ${namespace?upper_case}_SQL_ERROR_SUCCESS) << "select error (" << rc << "): " << errmsg;

  ASSERT_NE(result->rows, 0);
  ASSERT_NE(result->values, nullptr);

  ${namespace}_${obj.name}_query_free(query);
  sqlite3_close(conn);
}
</#list>
