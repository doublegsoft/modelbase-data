<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#ifndef __${app.name?upper_case}_PKT_H__
#define __${app.name?upper_case}_PKT_H__

#ifdef __cplusplus
extern "C"
{
#endif
<#------------------------------->
<#-- 通过Modelbase的枚举属性定义，-->
<#-- 生成C语言的枚举类型。        -->
<#------------------------------->
<#assign printingEnums = {}>
<#list model.objects as obj>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType?? && attr.constraint.domainType.name?starts_with("enum")>
      <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
      <#if printingEnums[attr.name]??>
        <#assign existingPairs = printingEnums[attr.name]>
        <#list existingPairs as existingPair>
          <#assign existing = false>
          <#list pairs as pair>
            <#if existingPair.key == pair.key>
              <#assign existing = true>
              <#break>
            </#if>
          </#list>
          <#if !existing>
            <#assign pairs += [existingPair]>
          </#if>
        </#list>
        <#assign pairs = existingPairs>
      </#if>  
      <#assign printingEnums += {attr.name: pairs}>
    </#if>
  </#list>
</#list>
<#list printingEnums as name,pairs>

/*!
** ${name}
*/
typedef enum 
{
  <#list pairs as pair>
  ${name?upper_case}_${pair.value?upper_case}<#if pair?has_next>,</#if>
  </#list>
} 
${namespace}_${name}_t;
</#list>
<#--------------------->
<#-- 协议包结构类型定义 -->
<#--------------------->
<#list model.objects as obj>

/*!
** 【${modelbase.get_object_label(obj)}】对象。
*/
typedef struct ${namespace}_${obj.name}_s      ${namespace}_${obj.name}_t;
typedef        ${namespace}_${obj.name}_t*     ${namespace}_${obj.name}_p;
</#list>
<#list model.objects as obj>

/*!
** 【${modelbase.get_object_label(obj)}】数据结构定义。
*/
struct ${namespace}_${obj.name}_s 
{
  /*!
  ** 指明这个对象的类型名称。
  */
  char typename[64];
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4c.type_attribute(attr)>

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${attrtype.name} ${modelbase4c.name_attribute(attr)}<#if attrtype.length??>[${attrtype.length}]</#if>;
  </#list>
}; 
</#list>
<#list model.objects as obj>

/*!
** 创建并初始化【${modelbase.get_object_label(obj)}】对象。
*/
${namespace}_${obj.name}_p
${namespace}_${obj.name}_init(void);

/*!
** 释放【${modelbase.get_object_label(obj)}】对象所占用的内存。
*/
void
${namespace}_${obj.name}_free(${namespace}_${obj.name}_p);
  <#list obj.attributes as attr>
    <#assign attrtype = modelbase4c.type_attribute(attr)>
  
    <#if attrtype.name == "char*" || (attrtype.name == "char" && attrtype.length??)>
      <#assign singular = modelbase.get_attribute_singular(attr)>
/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p, const char*, size_t);  
      <#if attr.type.countedName??>

/*!
** 获取【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】某个索引值。
*/
char*
${namespace}_${obj.name}_get_${singular}(${namespace}_${obj.name}_p, int idx, size_t*);
      </#if>
    <#elseif attrtype.name?contains("*")>
      <#assign singular = modelbase.get_attribute_singular(attr)>
/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p, const ${attrtype.name}, size_t);    

/*!
** 获取【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】某个索引值。
*/
${attrtype.name?replace("*","")}
${namespace}_${obj.name}_get_${singular}(${namespace}_${obj.name}_p, int idx);    
    <#else>
/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p, ${attrtype.name});
    </#if>
  </#list>
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_PKT_H__
