<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4c.ftl' as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <pthread.h>
#include <assert.h>
#include <limits.h>

#include "${app.name}-sql.h"
#include "${app.name}-sqlite.h"

const char*
${namespace}_sqlite_escape_string(const char* user_input, ${namespace}_sql_match_e match)
{
  if (user_input == NULL) return NULL;
  int count_to_escape = 0;
  int len = strlen(user_input);
  for (int i = 0; i < len; i++) 
  {
    char ch = user_input[i];
    if (ch == '\'')
      count_to_escape++;
  }
  if (match == PREFIX || match == SUFFIX)
    count_to_escape++;
  else if (match == GLOBAL)
    count_to_escape += 2;
  
  int start = 0;
  int new_len = len + count_to_escape + 1;
  char* ret = malloc(sizeof(char) * new_len);
  if (match == SUFFIX || match == GLOBAL)
    ret[start++] = '%';
  for (int i = 0; i < len; i++, start++)
  {
    char ch = user_input[i];
    if (ch == '\'') 
      ret[start++] = '\'';
    ret[start] = ch;
  }
  if (match == PREFIX || match == GLOBAL) 
    ret[start++] = '%';
  ret[start] = '\0';  
  return ret;
}
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

int
${namespace}_sqlite_${obj.name}_insert(sqlite3* conn, ${namespace}_${obj.name}_query_p ${obj.name}, char* errmsg)
{
  sqlite3_stmt*         stmt;
  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  
  rc = sqlite3_prepare_v2(conn, ${namespace?upper_case}_SQL_${obj.name?upper_case}_INSERT, -1, &stmt, 0);                         
  if (rc)
  {
    sprintf(errmsg, "%s", sqlite3_errmsg(conn));
    goto RELEASE;
  }                          
  <#list obj.attributes as attr>
    <#if attr.type.custom>
  sqlite3_bind_text(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);  
    <#elseif attr.constraint.identifiable>
  sqlite3_bind_text(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);    
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  sqlite3_bind_text(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);  
    <#elseif attr.type.name == "string">
  sqlite3_bind_text(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);  
    <#elseif attr.type.name == "int" || attr.type.name == "integer">
  sqlite3_bind_text(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);  
  <#--  sqlite3_bind_int(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)});    -->
    <#elseif attr.type.name == "number">
  sqlite3_bind_double(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)});  
    <#else>
  sqlite3_bind_text(stmt, ${attr?index + 1}, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);   
    </#if>
  </#list>   
  rc = sqlite3_step(stmt);
  if (rc)
  {
    sprintf(errmsg, "%s", sqlite3_errmsg(conn));
    goto RELEASE;
  }

RELEASE:

  sqlite3_finalize(stmt);

  return rc;
}


int
${namespace}_sqlite_${obj.name}_update(sqlite3* conn, ${namespace}_${obj.name}_query_p ${obj.name}, char* errmsg)
{
  sqlite3_stmt*     stmt                    = NULL;
  char              sql[8192]               = {'\0'};
  int               update_column_count     = 0;
  int               pk_found                = 0;
  int               rc                      = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  int               param_index             = 0;

  strcpy(sql, "update ${obj.persistenceName} set ");

  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable><#continue></#if>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign typename = modelbase4c.type_attribute(attr).name>
    <#if attr.name == "state">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    if (update_column_count) strcat(sql, ", ");
    strcat(sql, "${attr.persistenceName} = ?");
    update_column_count++;    
  }
    <#elseif attr.name == "last_modified_time">
  if (update_column_count) strcat(sql, ", ");
  strcat(sql, "${attr.persistenceName} = current_timestamp");
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    if (update_column_count) strcat(sql, ", ");
    strcat(sql, "${attr.persistenceName} = ?");
    update_column_count++;    
  }
    <#elseif typename == "char*">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    if (update_column_count) strcat(sql, ", ");
    strcat(sql, "${attr.persistenceName} = ?");
    update_column_count++;    
  }
    <#elseif typename == "int" || typename == "long">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    if (update_column_count) strcat(sql, ", ");
    strcat(sql, "${attr.persistenceName} = ?");
    update_column_count++;    
  }  
    </#if>
  </#list>
  if (!update_column_count)
    return ${namespace?upper_case}_SQL_ERROR_NO_COLUMN_UPDATE;

  strcat(sql, " where 1 = 1 ");   

  <#list idAttrs as idAttr>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(idAttr)} != NULL) 
  {
    strcat(sql, "and ${idAttr.persistenceName} = ? ");
    pk_found++;
  }
  </#list>
  if (!pk_found) 
    return ${namespace?upper_case}_SQL_ERROR_PRIMARY_KEY_NOT_FOUND;

  int params_count = update_column_count + pk_found;
  int params_index = 0;

  rc = sqlite3_prepare_v2(conn, sql, -1, &stmt, 0);
  if (rc) 
  {
    sprintf(errmsg, "%s", sqlite3_errmsg(conn));
    goto RELEASE;
  }

  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign typename = modelbase4c.type_attribute(attr).name>
    <#if attr.name == "state">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);
    params_index++;
  }
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);
    params_index++;
  }
    <#elseif attr.name == "last_modified_time">
      <#continue>
    <#elseif typename == "char*">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);
    params_index++;
  }
    <#elseif typename == "int" || typename == "long">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);
    <#--  sqlite3_bind_int(stmt, param_index + 1, ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)});    -->
    params_index++;
  }  
    </#if>
  </#list>

  rc = sqlite3_step(stmt);
  if (rc) 
  {
    sprintf(errmsg, "%s", sqlite3_errmsg(conn));
    goto RELEASE;
  }

RELEASE:

  if (stmt != NULL) 
    sqlite3_finalize(stmt);

  return rc;
}

int
${namespace}_sqlite_${obj.name}_delete(sqlite3* conn, ${namespace}_${obj.name}_query_p ${obj.name}, char* errmsg)
{
  char sql[8192] = {'\0'};
  int pk_found = 0; 
  strcpy(sql, ${namespace?upper_case}_SQL_${obj.name?upper_case}_DELETE);
  <#list idAttrs as idAttr>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(idAttr)} != NULL) 
  {
    strcat(sql, "and ${idAttr.persistenceName} = '");
    strcat(sql, ${obj.name}->${modelbase4c.name_attribute_as_primitive(idAttr)});
    strcat(sql, "' ");
    pk_found++;
  }
  </#list>
  if (!pk_found) 
    return ${namespace?upper_case}_SQL_ERROR_PRIMARY_KEY_NOT_FOUND;

  int rc = sqlite3_exec(conn, sql, NULL, 0, &errmsg);
  if (rc)
    return rc;
  return ${namespace?upper_case}_SQL_ERROR_SUCCESS;
}

int
${namespace}_sqlite_${obj.name}_select(sqlite3* conn, ${namespace}_${obj.name}_query_p query, char* errmsg, ${namespace}_table_result_p* table_result)
{
  char                  sql[8192 * 8]   = {'\0'};
  int                   rc              = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  sqlite3_stmt*         stmt            = NULL;
  char**                result_val      = NULL;
  unsigned long*        result_len      = NULL;
  bool*                 result_null     = NULL;
  bool*                 result_err      = NULL;
  unsigned long*        lengths         = NULL;
  int                   param_count     = 0;
  int                   param_index     = 0;
  int                   i               = 0;

  errmsg[0] = '\0';
  <#list obj.attributes as attr>
    <#if attr.type.custom>

  const char* ${modelbase4c.name_attribute_as_primitive(attr)} = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}, EXACT);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}0 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}0, PREFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}1 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}1, SUFFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}2 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}2, GLOBAL);          
    <#elseif attr.constraint.identifiable>

  const char* ${modelbase4c.name_attribute_as_primitive(attr)} = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}, EXACT);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}0 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}0, PREFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}1 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}1, SUFFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}2 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}2, GLOBAL);      
    <#elseif attr.constraint.domainType.name?starts_with("enum")>

  const char* ${modelbase4c.name_attribute_as_primitive(attr)} = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}, EXACT);  
    <#elseif attr.type.name == "string">
    
  const char* ${modelbase4c.name_attribute(attr)} = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute(attr)}, EXACT);  
  const char* ${modelbase4c.name_attribute(attr)}0 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute(attr)}0, PREFIX);  
  const char* ${modelbase4c.name_attribute(attr)}1 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute(attr)}1, SUFFIX);  
  const char* ${modelbase4c.name_attribute(attr)}2 = ${namespace}_sqlite_escape_string(query->${modelbase4c.name_attribute(attr)}2, GLOBAL);  
    </#if>
  </#list>

  rc = ${namespace}_sql_${obj.name}_select(query, sql, &param_count);
  rc = sqlite3_prepare_v2(conn, sql, -1, &stmt, 0);
  if (rc) 
  {
    sprintf(errmsg, "%s\n", sqlite3_errmsg(conn));
    goto RELEASE;
  }

  <#list obj.attributes as attr>
    <#if attr.type.custom>
  if (${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}0 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}0, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}1 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}1, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}2 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}2, -1, SQLITE_STATIC);   
    param_index++;
  }    
    <#elseif attr.constraint.identifiable>
  if (${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}0 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}0, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}1 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}1, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}2 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}2, -1, SQLITE_STATIC);   
    param_index++;
  }  
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);   
    param_index++;
  }  
    <#elseif attr.type.name == "string">
  if (${modelbase4c.name_attribute(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute(attr)}0 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}0, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute(attr)}1 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}1, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (${modelbase4c.name_attribute(attr)}2 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, ${modelbase4c.name_attribute_as_primitive(attr)}2, -1, SQLITE_STATIC);   
    param_index++;
  }
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  if (query->${modelbase4c.name_attribute(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, query->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (query->${modelbase4c.name_attribute(attr)}0 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, query->${modelbase4c.name_attribute_as_primitive(attr)}0, -1, SQLITE_STATIC);   
    param_index++;
  }
  if (query->${modelbase4c.name_attribute(attr)}1 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, query->${modelbase4c.name_attribute_as_primitive(attr)}1, -1, SQLITE_STATIC);   
    param_index++;
  }
    <#elseif attr.type.name == "int" || attr.type.name == "long">
  if (query->${modelbase4c.name_attribute(attr)} != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, query->${modelbase4c.name_attribute_as_primitive(attr)}, -1, SQLITE_STATIC);
    param_index++;
  } 
  if (query->${modelbase4c.name_attribute(attr)}0 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, query->${modelbase4c.name_attribute_as_primitive(attr)}0, -1, SQLITE_STATIC);
    param_index++;
  } 
  if (query->${modelbase4c.name_attribute(attr)}1 != NULL) 
  {
    sqlite3_bind_text(stmt, param_index + 1, query->${modelbase4c.name_attribute_as_primitive(attr)}1, -1, SQLITE_STATIC);
    param_index++;
  }  
    </#if>
  </#list>    

  rc = sqlite3_step(stmt);

  if (rc == SQLITE_ROW) 
  {
    int column_count = sqlite3_column_count(stmt);
    int row_index = 0;
    *table_result = ${namespace}_table_result_init(column_count);
    for (int i = 0; i < column_count; i++) 
    {
      const char* column_name = sqlite3_column_name(stmt, i);
      int column_type = sqlite3_column_type(stmt, i);
      ${namespace}_table_result_set_label(*table_result, i, column_name);
      ${namespace}_table_result_set_type(*table_result, i, column_type);
    }
    do 
    {
      for (int i = 0; i < column_count; i++) 
      {
        if ((*table_result)->types[i] == SQLITE_TEXT)
        {
          const char* value = (const char*)sqlite3_column_text(stmt, i);
          ${namespace}_table_result_set_value(*table_result, row_index, i, (void*)value, strlen(value));
        }
        else if ((*table_result)->types[i] == SQLITE_BLOB)
        {
          // TODO
        }
        else if ((*table_result)->types[i] == SQLITE_INTEGER)
        {
          int value = sqlite3_column_int(stmt, i);
          int* pval = (int*)malloc(sizeof(int));
          *pval = value;
          ${namespace}_table_result_set_value(*table_result, row_index, i, (void*)pval, 0);
        }
        else if ((*table_result)->types[i] == SQLITE_FLOAT)
        {
          float value = sqlite3_column_double(stmt, i);
          float* pval = (float*)malloc(sizeof(float));
          *pval = value;
          ${namespace}_table_result_set_value(*table_result, row_index, i, (void*)pval, 0);
        }
        else if ((*table_result)->types[i] == SQLITE_NULL)
        {
          ${namespace}_table_result_set_value(*table_result, row_index, i, NULL, 0);
        }
      }
      row_index++;
    } 
    while (sqlite3_step(stmt) == SQLITE_ROW);
  }

RELEASE:

  if (stmt != NULL)
    sqlite3_finalize(stmt);
  return rc;
}
</#list>