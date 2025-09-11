<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#pragma once

#include "${app.name}/poco.hpp"

namespace ${namespace}
{
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
class ${cpp.nameType(obj.name)}Bin
{

public:

  static void Serialize(${cpp.nameType(obj.name)}*, char** bytes, uint32_t& len);

  static ${cpp.nameType(obj.name)}* Deserialize(char* bytes, uint32_t len, uint32_t& offset);

}; // class ${cpp.nameType(obj.name)}Bin
</#list>
}; // namespace ${namespace}