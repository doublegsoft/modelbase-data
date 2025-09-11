<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_UTIL_H__
#define __${app.name?upper_case}_UTIL_H__

#ifdef __cplusplus
extern "C"
{
#endif

int
${namespace}_util_datetime_from_millis(long millis, char* datetime);

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_UTIL_H__
