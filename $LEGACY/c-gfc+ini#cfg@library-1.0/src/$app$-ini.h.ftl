<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_INI_H__
#define __${app.name?upper_case}_INI_H__

#include <stdio.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct ${app.name}_ctx_s      ${app.name}_ctx_t;
typedef ${app.name}_ctx_t*            ${app.name}_ctx_p;

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_INI_H__
