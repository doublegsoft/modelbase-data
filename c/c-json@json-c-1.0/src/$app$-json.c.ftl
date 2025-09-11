<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#include <json.h>
#include <string.h>
#include "${app.name}-json.h"
<#list model.objects as obj>

${namespace}_${obj.name}_query_p
${namespace}_json_${obj.name}_query_parse(const char* json_string)
{
  struct json_object* jobj = json_tokener_parse(json_string);
  ${namespace}_${obj.name}_query_p ret = ${namespace}_json_${obj.name}_query_assemble(jobj);
  json_object_put(jobj);
  return ret;
}

${namespace}_${obj.name}_query_p
${namespace}_json_${obj.name}_query_assemble(struct json_object* jobj)
{
  ${namespace}_${obj.name}_query_p ret = ${namespace}_sql_${obj.name}_query_init();
  int rc = 0;
  <#list obj.attributes as attr>
    <#if attr.type.custom><#-- Query模式不存在数组对象 -->
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${modelbase4c.name_attribute_as_primitive(attr)});
  rc = ${namespace}_json_get_string(jobj, "${modelbase4c.name_attribute_as_primitive_plural(attr)}", &ret->${modelbase4c.name_attribute_as_primitive_plural(attr)});  
    <#elseif attr.constraint.identifiable>
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${modelbase4c.name_attribute_as_primitive(attr)});
  rc = ${namespace}_json_get_string(jobj, "${modelbase4c.name_attribute_as_primitive_plural(attr)}", &ret->${modelbase4c.name_attribute_as_primitive_plural(attr)});  
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${modelbase4c.name_attribute_as_primitive(attr)});
  rc = ${namespace}_json_get_string(jobj, "${modelbase4c.name_attribute_as_primitive_plural(attr)}", &ret->${modelbase4c.name_attribute_as_primitive_plural(attr)});  
    <#elseif attr.type.name == "string">
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))});
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}0", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))}0);
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}1", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))}1);
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}2", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))}2);
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))});
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}0", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))}0);
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}1", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))}1);
    <#elseif attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">
  rc = ${namespace}_json_get_int(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${c.nameVariable(modelbase.get_attribute_sql_name(attr))});
    </#if>
  </#list>  
  return ret;
}

${namespace}_${obj.name}_p
${namespace}_json_${obj.name}_parse(const char* json_string, int* count)
{
  struct json_object* jobj = json_tokener_parse(json_string);
  ${namespace}_${obj.name}_p ret = ${namespace}_json_${obj.name}_assemble(jobj, count);
  json_object_put(jobj);
  return ret;
}

${namespace}_${obj.name}_p
${namespace}_json_${obj.name}_assemble(struct json_object* jobj, int* count)
{
  int rc = 0;
  int i = 0;
  ${namespace}_${obj.name}_p ret = ${namespace}_${obj.name}_init();
  <#list obj.attributes as attr>
    <#if attr.type.componentType??>
      <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
  struct json_object* jval_${modelbase4c.name_attribute(attr)} = json_object_object_get(jobj, "${modelbase4c.name_attribute(attr)}");
  if (jval_${modelbase4c.name_attribute(attr)} != NULL)
  {
    int count_${modelbase4c.name_attribute(attr)} = json_object_array_length(jval_${modelbase4c.name_attribute(attr)});
    for (i = 0; i < count_${modelbase4c.name_attribute(attr)}; i++) 
    {
      int count = 0;
      struct json_object* item = json_object_array_get_idx(jval_${modelbase4c.name_attribute(attr)}, i);
      ${namespace}_${refObj.name}_p child = ${namespace}_json_${refObj.name}_assemble(item, &count);
      ${namespace}_add_${refObj.name}_to_${attr.name}(ret, child);
    }
  }
    <#elseif attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
  struct json_object* jval_${modelbase4c.name_attribute(attr)} = json_object_object_get(jobj, "${modelbase4c.name_attribute(attr)}");
  if (jval_${modelbase4c.name_attribute(attr)} != NULL)
  {
    int jval_count = 0;
    ret->${modelbase4c.name_attribute(attr)} = ${namespace}_json_${refObj.name}_assemble(jval_${modelbase4c.name_attribute(attr)}, &jval_count);
  }
    <#elseif attr.constraint.domainType.name?starts_with("enum")>    
  rc = ${namespace}_json_get_str(jobj, "${modelbase.get_attribute_sql_name(attr)}", ret->${modelbase4c.name_attribute_as_primitive(attr)});
    <#elseif attr.type.name == "string">
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${modelbase4c.name_attribute_as_primitive(attr)});
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  rc = ${namespace}_json_get_string(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${modelbase4c.name_attribute_as_primitive(attr)});
    <#elseif attr.type.name == "int" || attr.type.name == "long">
  rc = ${namespace}_json_get_int(jobj, "${modelbase.get_attribute_sql_name(attr)}", &ret->${modelbase4c.name_attribute_as_primitive(attr)});
    </#if>
  </#list>  
  return ret;
}
</#list>

int
${namespace}_json_get_string(json_object* jobj, const char* name, char** holder)
{
  json_object *jval = json_object_object_get(jobj, name);

  if (jval == NULL)
    return ${namespace?upper_case}_JSON_ERROR_NOT_FOUND;

  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
    return ${namespace?upper_case}_JSON_ERROR_NOT_STRING_TYPE;

  const char* strval = json_object_get_string(jval);
  if (strval != NULL)
  {
    if (*holder == NULL)
    {
      int len = strlen(strval);
      *holder = (char*)malloc(sizeof(char) * (len + 1));
      strcpy(*holder, strval);
      *holder[len] = '\0';
    }
    else
      strcpy(*holder, strval);
  }

  return ${namespace?upper_case}_JSON_ERROR_SUCCESS;
}

int
${namespace}_json_get_str(json_object* jobj, const char* name, char* holder)
{
  json_object *jval = json_object_object_get(jobj, name);

  if (jval == NULL)
    return ${namespace?upper_case}_JSON_ERROR_NOT_FOUND;

  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
    return ${namespace?upper_case}_JSON_ERROR_NOT_STRING_TYPE;

  const char* strval = json_object_get_string(jval);
  if (strval != NULL)
  {
    strcpy(holder, strval);
  }
  return ${namespace?upper_case}_JSON_ERROR_SUCCESS;
}

int
${namespace}_json_get_int(json_object* jobj, const char* name, int* holder)
{
  json_object *jval = json_object_object_get(jobj, name);
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_int)
    return ${namespace?upper_case}_JSON_ERROR_NOT_INT_TYPE;

  *holder = json_object_get_int(jval);

  return ${namespace?upper_case}_JSON_ERROR_SUCCESS;
}

int
${namespace}_json_get_array(json_object* jobj, const char* name, json_object** holder)
{
  json_object *jval = json_object_object_get(jobj, name);
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_array)
    return ${namespace?upper_case}_JSON_ERROR_NOT_ARRAY_TYPE;

  *holder = jval;

  return ${namespace?upper_case}_JSON_ERROR_SUCCESS;
}