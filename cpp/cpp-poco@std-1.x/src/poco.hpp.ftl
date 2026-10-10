<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#pragma once

#include <cstdint>
#include <cstddef>
#include <cstring>
#include <memory>

namespace ${namespace} {
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 【${modelbase.get_object_label(obj)}】数据类型
*/
class ${cpp.nameType(obj.name)} {

public:

  ${cpp.nameType(obj.name)}() = default;
  ~${cpp.nameType(obj.name)}() = default;

  ${cpp.nameType(obj.name)}(const ${cpp.nameType(obj.name)}&) = delete;
  ${cpp.nameType(obj.name)}& operator=(const ${cpp.nameType(obj.name)}&) = delete;

  ${cpp.nameType(obj.name)}(${cpp.nameType(obj.name)}&&) noexcept = default;
  ${cpp.nameType(obj.name)}& operator=(${cpp.nameType(obj.name)}&&) noexcept = default;

public:
  <#list obj.attributes as attr>
  <#assign attrType = modelbase4cpp.type_attribute(attr)>
  
  ${attrType.name} ${modelbase.get_attribute_sql_name(attr)}() const { return ${attr.name}_; }
  void set${cpp.nameType(modelbase.get_attribute_sql_name(attr))}(const ${attrType.name}& value) { ${attr.name}_ = value; }
  </#list>

private:
  <#list obj.attributes as attr>
  <#assign attrType = modelbase4cpp.type_attribute(attr)>
  
  // 【${modelbase.get_attribute_label(attr)}】属性
  ${attrType.name} ${attr.name}_;
  </#list>

} // class ${cpp.nameType(obj.name)}
</#list>

} // namespace ${namespace}