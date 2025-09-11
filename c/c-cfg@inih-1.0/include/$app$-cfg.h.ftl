<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_CFG_H__
#define __${app.name?upper_case}_CFG_H__

#include <stdlib.h>
#include "${app.name}-poco.h"

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct ${namespace}_cfg_s     ${namespace}_cfg_t;
typedef        ${namespace}_cfg_t*    ${namespace}_cfg_p;

struct ${namespace}_cfg_s
{
<#list model.objects as obj>
  <#if !obj.isLabelled("config")><#continue></#if>
  <#list obj.attributes as attr>
  
  /*!
  ** 【${modelbase.get_object_label(obj)}${modelbase.get_attribute_label(attr)}】配置值。
  */
  <#if attr.type.name == "int" || attr.type.name == "integer">
  int ${obj.name}_${attr.name};
  <#else>
  char* ${obj.name}_${attr.name};
  </#if>
  </#list>
</#list>
};

/*!
** the default inih handler for section and item.
*/
int
${namespace}_cfg_process(void* user, const char* section, const char* name, const char* value);

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_CFG_H__
