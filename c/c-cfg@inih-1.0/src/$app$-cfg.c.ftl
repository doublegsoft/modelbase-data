<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <ini.h>
#include <string.h>
#include "${app.name}-cfg.h"

int
${namespace}_cfg_process(void* user, const char* section, const char* name, const char* value)
{
  ${namespace}_cfg_p cfg = (${namespace}_cfg_p) user;

  #define MATCH(s, n) strcmp(section, s) == 0 && strcmp(name, n) == 0
<#list model.objects as obj>
  <#if !obj.isLabelled("config")><#continue></#if>
  <#list obj.attributes as attr>
  if (MATCH("${obj.name}", "${attr.name}"))   
  {
    <#if attr.type.name == "int" || attr.type.name == "integer">
    cfg->${obj.name}_${attr.name} = atoi(value);
    <#else>
    cfg->${obj.name}_${attr.name} = strdup(value);
    </#if>
    return 0;
  }
  </#list>
</#list>
  return 0;
}