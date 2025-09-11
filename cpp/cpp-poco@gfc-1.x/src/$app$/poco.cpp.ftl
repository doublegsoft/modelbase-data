<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>

#include "${app.name}/poco.hpp"

namespace ${namespace}
{
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

class ${cpp.nameType(obj.name)}::Impl 
{

public:
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${attrtype.name} ${modelbase4cpp.name_attribute(attr)};
  </#list>
};
</#list>

}; // namespace ${namespace}

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
${namespace}::${cpp.nameType(obj.name)}::${cpp.nameType(obj.name)}(void)
{
  pimpl = new ${cpp.nameType(obj.name)}::Impl();
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4cpp.type_attribute(attr)>
  <#if attr.type.componentType??>
  pimpl->${modelbase4cpp.name_attribute(attr)} = new ${attrtype.name?substring(0, attrtype.name?length - 1)}();
  </#if>
</#list>  
}

${namespace}::${cpp.nameType(obj.name)}::~${cpp.nameType(obj.name)}(void)
{
  if (pimpl != nullptr)
  {
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4cpp.type_attribute(attr)>
  <#if attr.type.componentType??>
    delete pimpl->${modelbase4cpp.name_attribute(attr)};
  </#if>
</#list>
    delete pimpl;
  }
}

  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    
${attrtype.name} ${namespace}::${cpp.nameType(obj.name)}::Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}()
{
  return pimpl->${modelbase4cpp.name_attribute(attr)};
}    
    <#if attr.type.componentType??>
    
void ${namespace}::${cpp.nameType(obj.name)}::Add${cpp.nameType(modelbase.get_attribute_singular(attr))}(${modelbase4cpp.type_component(attr.type.componentType).name} ${cpp.nameVariable(modelbase.get_attribute_singular(attr))})
{
  pimpl->${modelbase4cpp.name_attribute(attr)}->push_back(${cpp.nameVariable(modelbase.get_attribute_singular(attr))});
} 
    <#else>
    
void ${namespace}::${cpp.nameType(obj.name)}::Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(${attrtype.name} ${modelbase4cpp.name_attribute(attr)})
{
  pimpl->${modelbase4cpp.name_attribute(attr)} = ${modelbase4cpp.name_attribute(attr)};
}
    </#if>
  </#list>  
</#list>