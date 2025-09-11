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

/*!
** 获得【${modelbase.get_object_label(obj)}】的SELECT SQL语句。
*/
int
${namespace}_sql_${obj.name}_select(${namespace}_${obj.name}_query_p ${obj.name}, char* sql_select, int* bind_count)
{
  strcpy(sql_select, "select "
<#list obj.attributes as attr> 
    "${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} ${modelbase.get_attribute_sql_name(attr)},"
</#list>    
    "0 "
    "from ${obj.persistenceName} ${modelbase.get_object_sql_alias(obj)} "
    "where 1 = 1 "
  );
<#list obj.attributes as attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}0 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}1 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}2 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)} != NULL)
  {
    char* in = ${namespace}_sql_str2in(${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)});
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} in (");
    strcat(sql_select, in);
    strcat(sql_select, ") ");
    (*bind_count)++;
    free(in);
  }
  <#elseif attr.constraint.identifiable>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}0 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}1 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}2 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)} != NULL)
  {
    char* in = ${namespace}_sql_str2in(${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)});
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} in (");
    strcat(sql_select, in);
    strcat(sql_select, ") ");
    (*bind_count)++;
    free(in);
  }
  <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)} != NULL)
  {
    char* in = ${namespace}_sql_str2in(${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)});
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} in (");
    strcat(sql_select, in);
    strcat(sql_select, ") ");
    (*bind_count)++;
    free(in);
  }
  <#elseif attr.type.name == "string">
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(attr)}0 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(attr)}1 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(attr)}2 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like ? ");
    (*bind_count)++;
  }
  <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(attr)}0 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} >= ? ");
    (*bind_count)++;
  }
  if (${obj.name}->${modelbase4c.name_attribute(attr)}1 != NULL)
  {
    strcat(sql_select, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} <= ? ");
    (*bind_count)++;
  }
  </#if>
</#list>  
  return ${namespace?upper_case}_SQL_ERROR_SUCCESS;
}

/*!
** 创建【${modelbase.get_object_label(obj)}】查询对象。
*/
${namespace}_${obj.name}_query_p
${namespace}_sql_${obj.name}_query_init(void)
{
  ${namespace}_${obj.name}_query_p ret = (${namespace}_${obj.name}_query_p)malloc(sizeof(${namespace}_${obj.name}_query_t));
   <#list obj.attributes as attr>
    <#if attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>  
  ret->${modelbase4c.name_attribute(refObjIdAttr)}  = NULL;
  ret->${modelbase4c.name_attribute(refObjIdAttr)}0 = NULL;
  ret->${modelbase4c.name_attribute(refObjIdAttr)}1 = NULL;
  ret->${modelbase4c.name_attribute(refObjIdAttr)}2 = NULL;
  ret->${modelbase4c.name_attribute_as_primitive_plural(attr)} = NULL;
    <#elseif attr.constraint.identifiable>
  ret->${modelbase4c.name_attribute_as_primitive(attr)} = NULL;
  ret->${modelbase4c.name_attribute_as_primitive(attr)}0 = NULL;
  ret->${modelbase4c.name_attribute_as_primitive(attr)}1 = NULL;
  ret->${modelbase4c.name_attribute_as_primitive(attr)}2 = NULL;
  ret->${modelbase4c.name_attribute_as_primitive_plural(attr)} = NULL;
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  ret->${modelbase4c.name_attribute_as_primitive(attr)} = NULL;
  ret->${modelbase4c.name_attribute_as_primitive_plural(attr)} = NULL;
    <#elseif attr.type.name == "string">
  ret->${modelbase4c.name_attribute(attr)} = NULL;  
  ret->${modelbase4c.name_attribute(attr)}0 = NULL;  
  ret->${modelbase4c.name_attribute(attr)}1 = NULL;  
  ret->${modelbase4c.name_attribute(attr)}2 = NULL;  
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  ret->${modelbase4c.name_attribute(attr)} = NULL;  
  ret->${modelbase4c.name_attribute(attr)}0 = NULL;  
  ret->${modelbase4c.name_attribute(attr)}1 = NULL;  
    <#elseif attr.type.name == "bool">
  ret->${modelbase4c.name_attribute(attr)} = NULL;  
    <#elseif attr.type.name == "int" || attr.type.name == "long">
  ret->${modelbase4c.name_attribute(attr)} = NULL;
  ret->${modelbase4c.name_attribute(attr)}0 = NULL;
  ret->${modelbase4c.name_attribute(attr)}1 = NULL;
    <#elseif attr.type.name == 'state'>
  ret->${modelbase4c.name_attribute(attr)} = NULL;  
    </#if>
  </#list>
  ret->start = INT_MIN;
  ret->limit = INT_MIN;
  return ret;
}

/*!
** 释放【${modelbase.get_object_label(obj)}】查询对象。
*/
void
${namespace}_sql_${obj.name}_query_free(${namespace}_${obj.name}_query_p ${obj.name})
{
  <#list obj.attributes as attr>
    <#if attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>  
  
    </#if>
  </#list>
  <#list obj.attributes as attr>
    <#if attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>  
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)});
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}0 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}0);
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}1 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}1);
  if (${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}2 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(refObjIdAttr)}2);      
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)});
    <#elseif attr.constraint.identifiable>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)});  
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}0 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}0);  
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}1 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}1);
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}2 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)}2);
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)});      
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive(attr)});  
  if (${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute_as_primitive_plural(attr)});      
    <#elseif attr.type.name == "string">
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)});  
  if (${obj.name}->${modelbase4c.name_attribute(attr)}0 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)}0);  
  if (${obj.name}->${modelbase4c.name_attribute(attr)}1 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)}1);
  if (${obj.name}->${modelbase4c.name_attribute(attr)}2 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)}2);  
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  if (${obj.name}->${modelbase4c.name_attribute(attr)} != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)});  
  if (${obj.name}->${modelbase4c.name_attribute(attr)}0 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)}0);  
  if (${obj.name}->${modelbase4c.name_attribute(attr)}1 != NULL)
    free(${obj.name}->${modelbase4c.name_attribute(attr)}1);
    </#if>
  </#list>
  free(${obj.name});
}
</#list>

int
${namespace}_sql_persistence_name(const char* objname, const char* attrname, char* persistence_name)
{
  if (objname == NULL) 
    return ${namespace?upper_case}_SQL_ERROR_NO_OBJECT_SPECIFIED;
  if (1 == 0) {}
  <#list model.objects as obj>
  else if (strcmp(objname, "${obj.name}") == 0)
  {
    if (attrname == NULL) 
      strcpy(persistence_name, "${obj.persistenceName}");
    <#list obj.attributes as attr>
    else if (strcmp(attrname, "${attr.name}") == 0)
      strcpy(persistence_name, "${attr.persistenceName}");
    </#list>
  }
  </#list>  
  return ${namespace?upper_case}_SQL_ERROR_SUCCESS;
}