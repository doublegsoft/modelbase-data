<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_WECHAT_H__
#define __${app.name?upper_case}_WECHAT_H__

#include <stdlib.h>
#include "${app.name}-poco.h"

#ifdef __cplusplus
extern "C"
{
#endif

int
${namespace}_wechat_get_access_token(const char* appid, const char* secret, char** access_token);

int
${namespace}_wechat_get_paid_union_id(const char* access_token, const char* openid);

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_WECHAT_H__
