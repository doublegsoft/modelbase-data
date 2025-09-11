<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#pragma once

#include <any>
#include <vector>
#include <string>

<#--
 ### 处理头文件引用的问题
 -->
<#assign reftypes = {}>
<#list field.attributes as attr>
  <#if attr.type.custom>
    <#assign reftypes = reftypes + {attr.type.name: attr.type.name}>
  <#elseif attr.type.componentType??>    
    <#assign reftypes = reftypes + {attr.type.componentType.name: attr.type.componentType.name}>
  </#if>
</#list>
<#list reftypes?keys as key>
#include "${cpp.nameFile(key)}.hpp"
</#list>

namespace gux
{

/*!
** 【${modelbase.get_object_label(field)}】
*/
class ${cpp.nameType(field.name)}
{

public:

  /*!
  ** 【${modelbase.get_object_label(field)}】构造函数。
  */
  ${cpp.nameType(field.name)}(void);
  
  /*!
  ** 【${modelbase.get_object_label(field)}】析构函数。
  */
  ~${cpp.nameType(field.name)}(void);
<#list field.attributes as attr>
  <#assign attrtype = modelbase4cpp.type_attribute(attr)>
  <#if attr.type.componentType??>
    
  /*!
  ** 添加【${modelbase.get_object_label(field)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  void Add${cpp.nameType(modelbase.get_attribute_singular(attr))}(${namespace}::${cpp.nameType(attr.type.componentType.name)}*);
  
  /*!
  ** 设置【${modelbase.get_object_label(field)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  ${attrtype.name}* Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}();      
    <#else>
    
  /*!
  ** 设置【${modelbase.get_object_label(field)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  void Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(${attrtype.name} newValue);
  
  /*!
  ** 获取【${modelbase.get_object_label(field)}】的【${modelbase.get_object_label(attr)}】属性值。
  */
  ${attrtype.name} Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}();
  </#if>
</#list>

private:

  class Impl;
  
  Impl* pimpl;

};

}; // namespace gux