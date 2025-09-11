<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
<#if license??>
${c.license(license)}
</#if>
#include <iostream>
#include <string>
#include <algorithm>
#include <stdlib.h>

#include "${app.name}/bin.hpp"
#include "${app.name}/poco.hpp"

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
void ${namespace}::${cpp.nameType(obj.name)}Bin::Serialize(${cpp.nameType(obj.name)}* ${cpp.nameVariable(obj.name)}, char** data, uint32_t& len)
{
  uint32_t total = 0;
  uint32_t strsize = 0;
  int intval;
  char charval;
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    <#if attr.type.name == "string" ||
         attr.type.name == "id" ||
         attr.type.name == "uuid">  
  total += sizeof(uint32_t);
  total += ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().length();
    <#elseif attr.type.name == "date">
  total += 10;
    <#elseif attr.type.name == "datetime">
  total += 19;
    <#elseif attr.type.name == "int" ||
             attr.type.name == "integer">
  total += sizeof(uint32_t);           
    <#elseif attr.type.name == "bool" || attr.type.name == "state">
  total += 1;
    </#if>              
  </#list>
  *data = (char*)malloc(total);
  
  char* ptr = *data;
  std::memcpy(ptr, 0, total);
  len = total;
  
  std::memcpy(ptr, &total, sizeof(uint32_t));
  ptr += sizeof(uint32_t);
  
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    <#if attr.type.name == "string" ||
         attr.type.name == "id" ||
         attr.type.name == "uuid">  
  /*!
  ** 写入【${modelbase.get_attribute_label(attr)}】字符串
  */       
  strsize = ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().length();
  std::memcpy(ptr, &strsize, sizeof(uint32_t));
  ptr += sizeof(uint32_t);
  if (strsize > 0) 
  {
    std::memcpy(ptr, ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().data(), strsize);
    ptr += strsize;  
  }
    <#elseif attr.type.name == "date">
  /*!
  ** 写入【${modelbase.get_attribute_label(attr)}】日期
  */
  strsize = ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().length();
  if (strsize > 0) 
    std::memcpy(ptr, ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().data(), 10);
  else 
    std::memcpy(ptr, "1970-01-01", 10);
  ptr += 10;    
    <#elseif attr.type.name == "datetime">
  /*!
  ** 写入【${modelbase.get_attribute_label(attr)}】时间戳
  */
  strsize = ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().length();
  if (strsize > 0) 
    std::memcpy(ptr, ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}().data(), 19);
  else 
    std::memcpy(ptr, "1970-01-01 00:00:00", 19); 
  ptr += 19;  
    <#elseif attr.type.name == "int" ||
             attr.type.name == "integer">
  /*!
  ** 写入【${modelbase.get_attribute_label(attr)}】整型值
  */           
  intval = ${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}();           
  std::memcpy(ptr, &intval, sizeof(int)); 
  ptr += sizeof(int);
    <#elseif attr.type.name == "bool">
  /*!
  ** 写入【${modelbase.get_attribute_label(attr)}】布尔值
  */  
  if (${cpp.nameVariable(obj.name)}->Get${cpp.nameType(modelbase4cpp.name_attribute(attr))}())
    std::memcpy(ptr, "T", 1); 
  else
    std::memcpy(ptr, "F", 1); 
  ptr += 1;  
    </#if>              
  </#list>
}

${namespace}::${cpp.nameType(obj.name)}* ${namespace}::${cpp.nameType(obj.name)}Bin::Deserialize(char* bytes, uint32_t len, uint32_t& offset)
{
  ${namespace}::${cpp.nameType(obj.name)}* ret = new ${namespace}::${cpp.nameType(obj.name)};
  uint32_t strsize = 0;
  int      intval;
  char     charval;
  char* byteptr = bytes;
  std::string str;
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    <#if attr.type.name == "string" ||
         attr.type.name == "id" ||
         attr.type.name == "uuid">
  /*!
  ** 读取【${modelbase.get_attribute_label(attr)}】字符串
  */
  std::memcpy(&strsize, byteptr, sizeof(uint32_t));
  offset += sizeof(uint32_t);
  byteptr += offset;
  
  if (strsize > 0) 
  {
    str.assign(reinterpret_cast<const char*>(byteptr), strsize);
    ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(str);
    byteptr += strsize;
  }
    <#elseif attr.type.name == "date">
  /*!
  ** 读取【${modelbase.get_attribute_label(attr)}】日期字符串
  */
  str.assign(reinterpret_cast<const char*>(byteptr), 10);
  ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(str);
  byteptr += 10;
    <#elseif attr.type.name == "datetime">
  /*!
  ** 读取【${modelbase.get_attribute_label(attr)}】时间戳字符串
  */
  str.assign(reinterpret_cast<const char*>(byteptr), 19);
  ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(str);
  byteptr += 19;
    <#elseif attr.type.name == "int" ||
             attr.type.name == "integer">
  /*!
  ** 读取【${modelbase.get_attribute_label(attr)}】整型值
  */
  std::memcpy(&intval, byteptr, sizeof(int));
  ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(intval);
  byteptr += 4;
    <#elseif attr.type.name == "bool">
  /*!
  ** 读取【${modelbase.get_attribute_label(attr)}】布尔值
  */
  std::memcpy(&charval, byteptr, 1);
  if (charval == 'T')
    ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(true);
  else
    ret->Set${cpp.nameType(modelbase4cpp.name_attribute(attr))}(false);
  byteptr += 1;
    <#elseif attr.type.custom>
  /*!
  ** 读取【${modelbase.get_attribute_label(attr)}】对象值
  */  
  ${attrtype.name} ${modelbase4cpp.name_attribute(attr)} = ${attrtype.name?substring(0, attrtype.name?length - 1)}Bin::Deserialize(byteptr, len, offset);
    </#if>     
  </#list>
  return ret;
}
</#list>