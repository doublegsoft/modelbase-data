<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#pragma once

#include "nlohmann/json.hpp"
#include "${app.name}/poco.hpp"

using json = nlohmann::json;

namespace ${namespace}
{
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
class ${cpp.nameType(obj.name)}Json
{

public:

  static void Serialize(${cpp.nameType(obj.name)}*, std::string& json);
  
  static void Serialize(${cpp.nameType(obj.name)}*, nlohmann::json& json);

  static ${cpp.nameType(obj.name)}* Deserialize(std::string&);

  static ${cpp.nameType(obj.name)}* Deserialize(nlohmann::json&);

}; // class ${cpp.nameType(obj.name)}Json
</#list>
}; // namespace ${namespace}