<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${c.license(license)}
</#if>

#include <time.h>
#include <stdio.h>
#include <string.h>
#include <uuid/uuid.h>

#include <json.h>

#include "${namespace}-util.h"
#include "${namespace}-err.h"

int
${namespace}_util_now(char* holder)
{
  time_t rawtime;
  struct tm* timeinfo;

  time(&rawtime);
  timeinfo = localtime(&rawtime);
  sprintf(holder, "%d-%02d-%02d %02d:%02d:%02d",
      timeinfo->tm_year + 1900,
      timeinfo->tm_mon + 1,
      timeinfo->tm_mday,
      timeinfo->tm_hour,
      timeinfo->tm_min,
      timeinfo->tm_sec);
  return ERROR_SUCCESS;
}

int
${namespace}_util_id(char* holder)
{
  uuid_t binuuid;
  uuid_generate_random(binuuid);
  uuid_unparse_upper(binuuid, holder);
  return ERROR_SUCCESS;
}

int
${namespace}_util_get_string(json_object* jobj,
${""?left_pad(namespace?length + 17)}const char* name,
${""?left_pad(namespace?length + 17)}char* holder)
{
  json_object *jval = json_object_object_get(jobj, name);

  if (jval == NULL)
    return ERROR_JSON_NOT_FOUND;

  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
    return ERROR_JSON_NOT_STRING_TYPE;

  const char* strval = json_object_get_string(jval);
  strcpy(holder, strval);

  return ERROR_SUCCESS;
}

int
${namespace}_util_get_int(json_object* jobj,
${""?left_pad(namespace?length + 14)}const char* name,
${""?left_pad(namespace?length + 14)}int* holder)
{
  json_object *jval = json_object_object_get(jobj, name);
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_int)
    return ERROR_JSON_NOT_INT_TYPE;

  *holder = json_object_get_int(jval);

  return ERROR_SUCCESS;
}

int
${namespace}_util_get_array(json_object* jobj,
${""?left_pad(namespace?length + 16)}const char* name,
${""?left_pad(namespace?length + 16)}json_object** holder)
{
  json_object *jval = json_object_object_get(jobj, name);
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_array)
    return ERROR_JSON_NOT_ARRAY_TYPE;

  *holder = jval;

  return ERROR_SUCCESS;
}
