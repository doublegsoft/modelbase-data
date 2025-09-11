<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${namespace?upper_case}_UTIL_H__
#define __${namespace?upper_case}_UTIL_H__

#ifdef __cplusplus
extern "C"
{
#endif

int
${namespace}_util_now(char* holder);

int
${namespace}_util_id(char* holder);

int
${namespace}_util_get_string(json_object* jobj,
${""?left_pad(namespace?length + 17)}const char* name,
${""?left_pad(namespace?length + 17)}char* holder);

int
${namespace}_util_get_int(json_object* jobj,
${""?left_pad(namespace?length + 14)}const char* name,
${""?left_pad(namespace?length + 14)}int* holder);

int
${namespace}_util_get_array(json_object* jobj,
${""?left_pad(namespace?length + 16)}const char* name,
${""?left_pad(namespace?length + 16)}json_object** holder);

#ifdef __cplusplus
};
#endif

#endif // __${namespace?upper_case}_UTIL_H__