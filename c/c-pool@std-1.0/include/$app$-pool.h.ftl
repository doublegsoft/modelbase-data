<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#ifndef __${app.name?upper_case}_POOL_H__
#define __${app.name?upper_case}_POOL_H__

#include <stdlib.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct ${namespace}_pool_s              ${namespace}_pool_t;
typedef        ${namespace}_pool_t*             ${namespace}_pool_p;

typedef struct ${namespace}_pooled_proxy_s      ${namespace}_pooled_proxy_t;
typedef        ${namespace}_pooled_proxy_t*     ${namespace}_pooled_proxy_p;

typedef void*   (*${namespace}_pooled_object_create)(void);
typedef bool   (*${namespace}_pooled_object_validate)(void*);
typedef void   (*${namespace}_pooled_object_release)(void*);

/*!
**
*/
${namespace}_pool_p
${namespace}_pool_init(int max, 
  ${namespace}_pooled_object_create    create,
  ${namespace}_pooled_object_validate  validate, 
  ${namespace}_pooled_object_release   release);

/*!
**
*/
void*
${namespace}_pool_obtain(${namespace}_pool_p);

/*!
**
*/
int
${namespace}_pool_release(${namespace}_pool_p, void*);

/*!
**
*/
void
${namespace}_pool_free(${namespace}_pool_p);


#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_POOL_H__
