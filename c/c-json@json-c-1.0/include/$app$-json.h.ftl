<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_JSON_H__
#define __${app.name?upper_case}_JSON_H__

#include <json.h>
#include "${app.name}-poco.h"
#include "${app.name}-sql.h"

#define ${namespace?upper_case}_JSON_ERROR_SUCCESS                            0
#define ${namespace?upper_case}_JSON_ERROR_NOT_FOUND                          400701
#define ${namespace?upper_case}_JSON_ERROR_NOT_STRING_TYPE                    400702
#define ${namespace?upper_case}_JSON_ERROR_NOT_INT_TYPE                       400703
#define ${namespace?upper_case}_JSON_ERROR_NOT_ARRAY_TYPE                     400704

#ifdef __cplusplus
extern "C"
{
#endif
<#list model.objects as obj>

${namespace}_${obj.name}_query_p
${namespace}_json_${obj.name}_query_parse(const char* json_string);

${namespace}_${obj.name}_query_p
${namespace}_json_${obj.name}_query_assemble(struct json_object* jobj);

${namespace}_${obj.name}_p
${namespace}_json_${obj.name}_parse(const char* json_string, int* count);

${namespace}_${obj.name}_p
${namespace}_json_${obj.name}_assemble(struct json_object* jobj, int* count);
</#list>

int
${namespace}_json_get_string(json_object* jobj, const char* name, char** holder);

int
${namespace}_json_get_str(json_object* jobj, const char* name, char* holder);

int
${namespace}_json_get_int(json_object* jobj, const char* name, int* holder);

int
${namespace}_json_get_array(json_object* jobj, const char* name, json_object** holder);

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_JSON_H__
