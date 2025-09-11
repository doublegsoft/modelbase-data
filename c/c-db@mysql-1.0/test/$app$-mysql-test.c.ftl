<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4c.ftl' as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdio.h>
#include "${app.name}-sql.h"
#include "${app.name}-mysql.h"
<#list model.objects as obj>

static void
test_${namespace}_mysql_${obj.name}(MYSQL*);
</#list>

int main(int argc, char* argv[])
{
  MYSQL* conn = mysql_init(NULL);

  if (mysql_real_connect(conn, "localhost", "root", "ganguo", "stdbiz_test_env", 0, NULL, 0) == NULL) 
  {
    fprintf(stderr, "Error connecting to MySQL: %s\n", mysql_error(conn));
    return 1;
  }

<#list model.objects as obj>
  test_${namespace}_mysql_${obj.name}(conn);
</#list>
  return 0;
}

<#list model.objects as obj>

static void
test_${namespace}_mysql_${obj.name}(MYSQL* conn)
{
  ${namespace}_table_result_p result;
  char errmsg[4096] = {'\0'};
  ${namespace}_${obj.name}_query_p query = ${namespace}_sql_${obj.name}_query_init();
  <#list obj.attributes as attr>
    <#if attr.type.custom>
  query->${modelbase4c.name_attribute_as_primitive(attr)} = "0";
    <#elseif attr.constraint.identifiable>
  query->${modelbase4c.name_attribute_as_primitive(attr)} = "0";
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  query->${modelbase4c.name_attribute(attr)} = "0";
    <#elseif attr.type.name == "string">
  query->${modelbase4c.name_attribute(attr)} = "0";
    </#if>
  </#list>
  int rc = ${namespace}_mysql_${obj.name}_delete(conn, query, errmsg);
  if (rc)
    printf("delete error (%d): %s\n", rc, errmsg);
  rc = ${namespace}_mysql_${obj.name}_insert(conn, query, errmsg);
  if (rc) 
    printf("insert error (%d): %s\n", rc, errmsg);
  rc = ${namespace}_mysql_${obj.name}_update(conn, query, errmsg);
  if (rc) 
    printf("update error (%d): %s\n", rc, errmsg);  
  rc = ${namespace}_mysql_${obj.name}_select(conn, query, errmsg, &result);
  if (rc)
    printf("select error (%d): %s\n", rc, errmsg);
}
</#list>