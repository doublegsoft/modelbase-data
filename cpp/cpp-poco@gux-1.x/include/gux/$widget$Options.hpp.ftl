<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#pragma once

#include <any>
#include <vector>
#include <string>

<#list model.objects as obj>
  <#if obj.isLabelled("field")>
#include "${cpp.nameFile(obj.name)}.hpp" 
  </#if>
</#list>

namespace gux
{

/*!
** 【${modelbase.get_object_label(widget)}】配置项类型
*/
class ${cpp.nameType(widget.name)}Options
{

public:
  
  /*!
  ** 【${modelbase.get_object_label(widget)}】配置项构造函数。
  */
  ${cpp.nameType(widget.name)}Options(void);
  
  /*!
  ** 【${modelbase.get_object_label(widget)}】配置项析构函数。
  */
  ~${cpp.nameType(widget.name)}Options(void);
<#list widget.attributes as attr>
  <#assign attrtype = modelbase4cpp.type_attribute(attr)>
  
  /*!
  ** 获取【${modelbase.get_object_label(widget)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  ${attrtype.name} Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}();
  <#if attr.type.componentType??>
    
  /*!
  ** 添加【${modelbase.get_object_label(widget)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  void Add${cpp.nameType(modelbase.get_attribute_singular(attr))}(${modelbase4cpp.type_component(attr.type.componentType).name});
    <#else>
    
  /*!
  ** 设置【${modelbase.get_object_label(widget)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  void Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(${attrtype.name});
  </#if>
</#list>

private:

  class Impl;
  
  Impl* pimpl;

};

}; // namespace gux