<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <stdlib.h>

#include "${app.name}-sql.h"

${namespace}_table_result_p
${namespace}_table_result_init(int cols)
{
  ${namespace}_table_result_p ret = (${namespace}_table_result_p)malloc(sizeof(${namespace}_table_result_t));
  ret->labels = (char**)malloc(sizeof(char*) * cols);
  ret->types = (int*)malloc(sizeof(int) * cols);
  ret->values = NULL;
  ret->cols = cols;
  ret->rows = 0;
  return ret;
}

void
${namespace}_table_result_set_label(${namespace}_table_result_p result, int col, const char* label)
{
  int len = strlen(label);
  char* str = (char*)malloc(sizeof(char) * (len + 1));
  strcpy(str, label);
  str[len] = '\0';
  result->labels[col] = str;
}

void
${namespace}_table_result_set_type(${namespace}_table_result_p result, int col, int type)
{
  result->types[col] = type;
}

void
${namespace}_table_result_set_value(${namespace}_table_result_p result, int row, int col, void* value, int size)
{
  if (row >= result->rows) 
  {
    if (result->values == NULL) 
      result->values = (void*)malloc(sizeof(void*) * result->cols);
    else
      result->values = (void**)realloc(result->values, sizeof(void*) * result->cols);
    result->rows++;
  }
  result->values[col] = value;
}

void
${namespace}_table_result_free(${namespace}_table_result_p result)
{
  for (int i = 0; i < result->cols; i++)
    free(result->labels[i]);
  free(result->labels);
  free(result->types);
  free(result);
}

char*
${namespace}_sql_str2in(const char* str)
{
  if (str == NULL) return NULL;
  char* new_str = strdup(str);
  char* ret = NULL;
  char* token = strtok(new_str, ",");
  while (token != NULL) 
  {
    int len = strlen(token);
    if (ret == NULL)
    {
      ret = (char*)malloc(sizeof(char) * (len + 3));
      strcpy(ret, "'");
      strcat(ret, token);
      strcat(ret, "'");
      ret[len + 2] = '\0';
    }
    else 
    {
      int new_len = (strlen(ret) + len + 4);
      ret = (char*)realloc(ret, sizeof(char) * new_len);
      strcat(ret, ",'");
      strcat(ret, token);
      strcat(ret, "'");
      ret[new_len - 1] = '\0';
    }
    token = strtok(NULL, ",");
  }
  if (ret == NULL) 
  {
    int len = strlen(str);
    ret = (char*)malloc(sizeof(char) * (len + 3));
    strcpy(ret, "'");
    strcat(ret, new_str);
    strcat(ret, "'");
    ret[len + 2] = '\0';
  }
  free(new_str);
  return ret;
}

char*
${namespace}_sql_str2like_l(const char* str)
{
  if (str == NULL) return NULL;
  int len = strlen(str);
  char* ret = (char*)malloc(sizeof(char) * (len + 4));
  strcpy(ret, "'");
  strcat(ret, str);
  strcat(ret, "%'");
  ret[len + 3] = '\0';
  return ret;
}

char*
${namespace}_sql_str2like_r(const char* str)
{
  if (str == NULL) return NULL;
  int len = strlen(str);
  char* ret = (char*)malloc(sizeof(char) * (len + 4));
  strcpy(ret, "'%");
  strcat(ret, str);
  strcat(ret, "'");
  ret[len + 3] = '\0';
  return ret;
}

char*
${namespace}_sql_str2like_g(const char* str)
{
  if (str == NULL) return NULL;
  int len = strlen(str);
  char* ret = (char*)malloc(sizeof(char) * (len + 5));
  strcpy(ret, "'%");
  strcat(ret, str);
  strcat(ret, "%'");
  ret[len + 4] = '\0';
  return ret;
}
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 获得【${modelbase.get_object_label(obj)}】的SELECT SQL语句。
*/
int
${namespace}_sql_${obj.name}_select(${namespace}_${obj.name}_query_p ${obj.name}, char* sql_select, int* bind_count)
{
  strcpy(sql_select, "select "
<#list obj.attributes as attr> 
  <#if !attr.persistenceName??><#continue></#if>
  
    "${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} ${modelbase.get_attribute_sql_name(attr)},"
</#list>    
    "0 "
    "from ${obj.persistenceName} ${modelbase.get_object_sql_alias(obj)} "
    "where 1 = 1 "
  );
<#list obj.attributes as attr>
  <#if !attr.persistenceName??><#continue></#if>
  <#assign attrType = modelbase4c.type_attribute_primitive(attr)>
  <#if attrType.length?? || attrType.name == "char*">
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}0 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}1 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}2 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}0 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} >= ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}1 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} <= ? ");
    (*bind_count)++;
  }
  <#else>
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)} != 0)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}0 != 0)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} >= ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_primitive(attr)}1 != 0)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} <= ? ");
    (*bind_count)++;
  }
  </#if>
</#list>  
  return ${namespace?upper_case}_SQL_ERROR_SUCCESS;
}
</#list>

int
${namespace}_sql_persistence_name(const char* objname, const char* attrname, char* persistence_name)
{
  if (objname == NULL) 
    return ${namespace?upper_case}_SQL_ERROR_NO_OBJECT_SPECIFIED;
  if (1 == 0) {}
  <#list model.objects as obj>
    <#if obj.isLabelled("generated")><#continue></#if>
  else if (strcmp(objname, "${obj.name}") == 0)
  {
    if (attrname == NULL) 
      strcpy(persistence_name, "${obj.persistenceName}");
    <#list obj.attributes as attr>
      <#if !attr.persistenceName??><#continue></#if>
    else if (strcmp(attrname, "${attr.name}") == 0)
      strcpy(persistence_name, "${attr.persistenceName}");
    </#list>
  }
  </#list>  
  return ${namespace?upper_case}_SQL_ERROR_SUCCESS;
}