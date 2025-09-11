<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4c.ftl' as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdio.h>
#include <mysql.h>
#include <string.h>
#include <stdbool.h>
#include <pthread.h>
#include <assert.h>
#include <limits.h>

#include "${app.name}-sql.h"
#include "${app.name}-mysql.h"

const char*
${namespace}_mysql_escape_string(const char* user_input, ${namespace}_sql_match_e match)
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
${namespace}_mysql_${obj.name}_insert(MYSQL* conn, ${namespace}_${obj.name}_query_p ${obj.name}, char* errmsg)
{
  MYSQL_STMT*           stmt;
  MYSQL_BIND            params[${obj.attributes?size}];
  unsigned long         lengths[${obj.attributes?size}];

  stmt    = mysql_stmt_init(conn);

  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  
  rc = mysql_stmt_prepare(stmt, 
                          ${namespace?upper_case}_SQL_${obj.name?upper_case}_INSERT, 
                          strlen(${namespace?upper_case}_SQL_${obj.name?upper_case}_INSERT));
  if (rc)
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }                         
  memset(params, 0, sizeof(params));    

  <#list obj.attributes as attr>
    <#assign typename = modelbase4c.type_attribute(attr).name>
  // 【${modelbase.get_attribute_label(attr)}】
    <#if attr.type.custom>
  lengths[${attr?index}] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
  params[${attr?index}].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};
    <#elseif attr.name == "state">
  lengths[${attr?index}] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
  params[${attr?index}].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};  
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  lengths[${attr?index}] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
  params[${attr?index}].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};    
    <#elseif attr.type.name == "string">
  lengths[${attr?index}] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
  params[${attr?index}].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time"> 
  lengths[${attr?index}] = ${obj.name}->${modelbase4c.name_attribute(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute(attr)}) : 0;
  params[${attr?index}].buffer_type = ${obj.name}->${modelbase4c.name_attribute(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute(attr)};   
    <#else>
  lengths[${attr?index}] = ${obj.name}->${modelbase4c.name_attribute(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute(attr)}) : 0;
  params[${attr?index}].buffer_type = ${obj.name}->${modelbase4c.name_attribute(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char*) &${obj.name}->${modelbase4c.name_attribute(attr)};
    </#if>
  params[${attr?index}].length = &lengths[${attr?index}];
  params[${attr?index}].is_null = 0;
  </#list>       

  rc = mysql_stmt_bind_param(stmt, params);
  if (rc)
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  rc = mysql_stmt_execute(stmt);
  if (rc)
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

RELEASE:

  mysql_stmt_close(stmt);

  return rc;
}

int
${namespace}_mysql_${obj.name}_update(MYSQL* conn, ${namespace}_${obj.name}_query_p ${obj.name}, char* errmsg)
{
  MYSQL_STMT*       stmt                    = NULL;
  MYSQL_BIND*       params                  = NULL;
  unsigned long*    lengths                 = NULL;
  char              sql[8192]               = {'\0'};
  int               update_column_count     = 0;
  int               pk_found                = 0;
  int               rc                      = ${namespace?upper_case}_SQL_ERROR_SUCCESS;

  strcpy(sql, "update ${obj.persistenceName} set ");

  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable><#continue></#if>
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
  params = (MYSQL_BIND*)malloc(sizeof(MYSQL_BIND) * params_count);
  lengths = (unsigned long*)malloc(sizeof(unsigned long) * params_count);

  stmt    = mysql_stmt_init(conn);
  rc = mysql_stmt_prepare(stmt, sql, strlen(sql));
  if (rc) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  memset(params, 0, sizeof(MYSQL_BIND) * params_count); 

  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign typename = modelbase4c.type_attribute(attr).name>
    <#if attr.name == "state">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[params_index] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
    params[params_index].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
    params[params_index].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};
    params[params_index].length = &lengths[params_index];
    params[params_index].is_null = 0;
    params_index++;
  }
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[params_index] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
    params[params_index].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
    params[params_index].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};
    params[params_index].length = &lengths[params_index];
    params[params_index].is_null = 0;
    params_index++;
  }
    <#elseif attr.name == "last_modified_time">
      <#continue>
    <#elseif typename == "char*">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[params_index] = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}) : 0;
    params[params_index].buffer_type = ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
    params[params_index].buffer = (char *) ${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)};
    params[params_index].length = &lengths[params_index];
    params[params_index].is_null = 0;
    params_index++;
  }
    <#elseif typename == "int" || typename == "long">
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[params_index] = strlen(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)});
    params[params_index].buffer_type = MYSQL_TYPE_STRING;
    params[params_index].buffer = (char*) &${obj.name}->${modelbase4c.name_attribute(attr)};
    params[params_index].length = &lengths[params_index];
    params[params_index].is_null = 0;
    params_index++;
  }  
    </#if>
  </#list>

  rc = mysql_stmt_bind_param(stmt, params);
  if (rc) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  rc = mysql_stmt_execute(stmt);
  if (rc) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

RELEASE:

  free(params);
  free(lengths);

  if (stmt != NULL) 
    mysql_stmt_close(stmt);

  return rc;
}

int
${namespace}_mysql_${obj.name}_delete(MYSQL* conn, ${namespace}_${obj.name}_query_p ${obj.name}, char* errmsg)
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

  int rc = mysql_real_query(conn, sql, strlen(sql));
  if (rc)
  {
    sprintf(errmsg, "%s", mysql_error(conn));
    return rc;
  }
  return ${namespace?upper_case}_SQL_ERROR_SUCCESS;
}

int
${namespace}_mysql_${obj.name}_select(MYSQL* conn, ${namespace}_${obj.name}_query_p query, char* errmsg, ${namespace}_table_result_p* table_result)
{
  char                  sql[8192 * 8]   = {'\0'};
  int                   rc              = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  MYSQL_STMT*           stmt            = NULL;
  MYSQL_BIND*           params          = NULL;
  MYSQL_FIELD*          fields          = NULL;
  MYSQL_RES*            meta            = NULL;
  MYSQL_BIND*           result_bind     = NULL;
  char**                result_val      = NULL;
  unsigned long*        result_len      = NULL;
  bool*                 result_null     = NULL;
  bool*                 result_err      = NULL;
  MYSQL_ROW             row;
  MYSQL_RES*            result;
  unsigned long*        lengths         = NULL;
  int                   param_count     = 0;
  int                   param_index     = 0;
  int                   i               = 0;

  errmsg[0] = '\0';
  <#list obj.attributes as attr>
    <#if attr.type.custom>

  const char* ${modelbase4c.name_attribute_as_primitive(attr)} = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}, EXACT);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}0 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}0, PREFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}1 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}1, SUFFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}2 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}2, GLOBAL);      
    <#elseif attr.constraint.identifiable>

  const char* ${modelbase4c.name_attribute_as_primitive(attr)} = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}, EXACT);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}0 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}0, PREFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}1 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}1, SUFFIX);  
  const char* ${modelbase4c.name_attribute_as_primitive(attr)}2 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}2, GLOBAL);      
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
    
  const char* ${modelbase4c.name_attribute_as_primitive(attr)} = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute_as_primitive(attr)}, EXACT);  
    <#elseif attr.type.name == "string">
    
  const char* ${modelbase4c.name_attribute(attr)} = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute(attr)}, EXACT);  
  const char* ${modelbase4c.name_attribute(attr)}0 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute(attr)}0, PREFIX);  
  const char* ${modelbase4c.name_attribute(attr)}1 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute(attr)}1, SUFFIX);  
  const char* ${modelbase4c.name_attribute(attr)}2 = ${namespace}_mysql_escape_string(query->${modelbase4c.name_attribute(attr)}2, GLOBAL);  
    </#if>
  </#list>

  stmt = mysql_stmt_init(conn);
  rc = ${namespace}_sql_${obj.name}_select(query, sql, &param_count);

  if (param_count > 0)
  {
    params  = (MYSQL_BIND*) malloc(sizeof(MYSQL_BIND) * param_count);
    lengths = (unsigned long*) malloc(sizeof(unsigned long) * param_count);                       
    memset(params, 0, sizeof(MYSQL_BIND) * param_count); 
  }

  rc = mysql_stmt_prepare(stmt, sql, strlen(sql));
  if (rc) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }      

  <#list obj.attributes as attr>
    <#if attr.type.custom>
  if (${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)};
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}0 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)}0);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)}0;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}1 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)}1);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)}1;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}2 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)}2);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)}2;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }    
    <#elseif attr.constraint.identifiable>
  if (${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)};
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}0 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)}0);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)}0;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}1 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)}1);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)}1;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute_as_primitive(attr)}2 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)}2);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)}2;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }  
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${modelbase4c.name_attribute_as_primitive(attr)} != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute_as_primitive(attr)});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute_as_primitive(attr)};
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }  
    <#elseif attr.type.name == "string">
  if (${modelbase4c.name_attribute(attr)} != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute(attr)});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute(attr)};
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute(attr)}0 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute(attr)}0);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute(attr)}0;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute(attr)}1 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute(attr)}1);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute(attr)}1;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${modelbase4c.name_attribute(attr)}2 != NULL) 
  {
    lengths[param_index] = strlen(${modelbase4c.name_attribute(attr)}2);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${modelbase4c.name_attribute(attr)}2;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  if (query->${modelbase4c.name_attribute(attr)} != NULL) 
  {
    lengths[param_index] = strlen(query->${modelbase4c.name_attribute(attr)});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) query->${modelbase4c.name_attribute(attr)};
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (query->${modelbase4c.name_attribute(attr)}0 != NULL) 
  {
    lengths[param_index] = strlen(query->${modelbase4c.name_attribute(attr)}0);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) query->${modelbase4c.name_attribute(attr)}0;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (query->${modelbase4c.name_attribute(attr)}1 != NULL) 
  {
    lengths[param_index] = strlen(query->${modelbase4c.name_attribute(attr)}1);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) query->${modelbase4c.name_attribute(attr)}1;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
    <#elseif attr.type.name == "int" || attr.type.name == "long">
    </#if>
  </#list>    

  if (params != NULL)
  {
    rc = mysql_stmt_bind_param(stmt, params);
    if (rc) 
    {
      sprintf(errmsg, "%s", mysql_stmt_error(stmt));
      goto RELEASE;
    }
  }
  rc = mysql_stmt_execute(stmt);
  if (rc) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  meta = mysql_stmt_result_metadata(stmt);
  if (!meta) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  fields = mysql_fetch_fields(meta);
  unsigned long fields_number = mysql_num_fields(meta);

  result_bind = (MYSQL_BIND*)malloc(sizeof(MYSQL_BIND) * fields_number);
  result_val = (char**)malloc(sizeof(char*) * fields_number);
  result_len = (unsigned long*)malloc(sizeof(unsigned long) * fields_number);
  result_null = (bool*)malloc(sizeof(bool) * fields_number);
  result_err = (bool*)malloc(sizeof(bool) * fields_number);
  memset(result_bind, 0, sizeof(MYSQL_BIND) * fields_number);

  for (unsigned long i = 0; i < fields_number; i++) 
  {
    result_val[i] = malloc(sizeof(char) * fields[i].length);
    result_bind[i].buffer_type = fields[i].type;
    result_bind[i].buffer = (char*)result_val[i];
    result_bind[i].length = &result_len[i];
    result_bind[i].is_null = &result_null[i];
    result_bind[i].error = &result_err[i];
  }

  if (mysql_stmt_bind_result(stmt, result_bind)) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  int row_index = 0;
  *table_result = ${namespace}_table_result_init(fields_number);
  for (unsigned long i = 0; i < fields_number; i++) 
  {
    ${namespace}_table_result_set_label(*table_result, i, fields[i].name);
    ${namespace}_table_result_set_type(*table_result, i, fields[i].type);
  }

  int status;
  while (1) 
  {
    status = mysql_stmt_fetch(stmt);
    if (status == 1 || status == MYSQL_NO_DATA)
      break;
    for (int i = 0; i < fields_number; i++) 
    {
      ${namespace}_table_result_set_value(*table_result, row_index, i, result_val[i] ? (char *)result_val : NULL, (int)result_len[i]);
    }
    row_index++;
  }

RELEASE: 
  if (meta != NULL)
    mysql_free_result(meta);

  if (params != NULL)
    free(params);
  if (lengths != NULL)  
    free(lengths);

  if (result_len != NULL)
    free(result_len);
  if (result_null != NULL)
    free(result_null);
  if (result_err != NULL)
    free(result_err);  
  if (result_val != NULL)
  {  
    for (int i = 0; i < fields_number; i++)  
      free(result_val[i]);
    free(result_val);
  }

  if (result_bind != NULL)
    free(result_bind);

  if (stmt != NULL)
  {
    mysql_stmt_free_result(stmt);
    mysql_stmt_close(stmt);
  }
  return rc;
}
</#list>