<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#pragma once

#include <string>
#include <vector>

namespace ${namespace}
{

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
class ${cpp.nameType(obj.name)};  
</#list>
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 【${modelbase.get_object_label(obj)}】类定义。
*/
class ${cpp.nameType(obj.name)}
{

public:
  
  /*!
  ** 【${modelbase.get_object_label(obj)}】构造函数。
  */
  ${cpp.nameType(obj.name)}(void);
  
  /*!
  ** 【${modelbase.get_object_label(obj)}】析构函数。
  */
  ~${cpp.nameType(obj.name)}(void);
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    
  /*!
  ** 获取【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  ${attrtype.name} Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}();    
    <#if attr.type.componentType??>
    
  /*!
  ** 添加【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  void Add${cpp.nameType(modelbase.get_attribute_singular(attr))}(${modelbase4cpp.type_component(attr.type.componentType).name});
    <#else>
    
  /*!
  ** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  void Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(${attrtype.name} newValue);
    </#if>
  </#list>

private:
  
  class Impl;
  
  Impl* pimpl;
  
}; 
</#list>

}; // namespace ${namespace}
