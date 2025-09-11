<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#include "${app.name}/json.hpp"

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
void ${namespace}::${cpp.nameType(obj.name)}Json::Serialize(${cpp.nameType(obj.name)}* ${cpp.nameVariable(obj.name)}, std::string& json)
{
  nlohmann::json root = nlohmann::json::object();
  Serialize(${cpp.nameVariable(obj.name)}, root);
  json = root.dump();
}

void ${namespace}::${cpp.nameType(obj.name)}Json::Serialize(${cpp.nameType(obj.name)}* ${cpp.nameVariable(obj.name)}, nlohmann::json& json)
{
  <#list obj.attributes as attr>
    <#if attr.type.primitive>
  json["${modelbase4cpp.name_attribute(attr)}"] = ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}();
    <#elseif attr.type.custom>
  if (${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}() != nullptr)
  {
    json["${modelbase4cpp.name_attribute(attr)}"] = nlohmann::json::object();
    ${namespace}::${cpp.nameType(attr.type.name)}Json::Serialize(${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}(), json["${modelbase4cpp.name_attribute(attr)}"]);
  }
    <#elseif attr.type.componentType??>
  if (${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}()->size() > 0) 
  {
    json["${modelbase4cpp.name_attribute(attr)}"] = nlohmann::json::array();
    for (auto itemptr : *${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}())
    {
      nlohmann::json item = nlohmann::json::object();
      ${namespace}::${cpp.nameType(attr.type.componentType.name)}Json::Serialize(itemptr, item);
      json["${modelbase4cpp.name_attribute(attr)}"].push_back(item);
    }
  }  
    </#if>
  </#list>
}

${namespace}::${cpp.nameType(obj.name)}* ${namespace}::${cpp.nameType(obj.name)}Json::Deserialize(std::string& str)
{
  nlohmann::json parsed = nlohmann::json::parse(str);
  return Deserialize(parsed);
}

${namespace}::${cpp.nameType(obj.name)}* ${namespace}::${cpp.nameType(obj.name)}Json::Deserialize(nlohmann::json& json)
{
  ${namespace}::${cpp.nameType(obj.name)}* ret = new ${namespace}::${cpp.nameType(obj.name)};
  <#list obj.attributes as attr>
    <#if attr.type.primitive>
  if (json.contains("${modelbase4cpp.name_attribute(attr)}") && !json["${modelbase4cpp.name_attribute(attr)}"].is_null()) 
    ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(json["${modelbase4cpp.name_attribute(attr)}"]);
    <#elseif attr.type.custom>
  if (json.contains("${modelbase4cpp.name_attribute(attr)}") && !json["${modelbase4cpp.name_attribute(attr)}"].is_null()) 
    ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(${namespace}::${cpp.nameType(attr.type.name)}Json::Deserialize(json["${modelbase4cpp.name_attribute(attr)}"]));
    <#elseif attr.type.componentType??>
  if (json.contains("${modelbase4cpp.name_attribute(attr)}") && !json["${modelbase4cpp.name_attribute(attr)}"].is_null()) 
  {
    nlohmann::json arr = json["${modelbase4cpp.name_attribute(attr)}"];
    for (nlohmann::json& item : arr) 
      ret->Add${cpp.nameType(modelbase.get_attribute_singular(attr))}(${namespace}::${cpp.nameType(attr.type.componentType.name)}Json::Deserialize(item));
  }  
    </#if>
  </#list>
  return ret;
}
</#list>