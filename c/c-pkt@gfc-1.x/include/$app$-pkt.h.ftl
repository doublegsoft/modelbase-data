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
            <#if existing.key == pair.key>
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
    <#if attr.type.componentType??><#-- 优先判断，是否是自定义数组类型的对象 -->
      <#if attr.type.componentType.name == "any[]">
  void**     ${modelbase4c.name_attribute(attr)};    
      <#else>
  ${namespace}_${attr.type.componentType.name}_p*     ${modelbase4c.name_attribute(attr)};
      </#if>
  int     count_of_${modelbase4c.name_attribute(attr)};
    <#elseif attr.type.custom><#-- 其次判断单个引用自定义类型 -->
      <#assign refObj = model.findObjectByName(attr.type.name)>
  ${namespace}_${refObj.name}_p ${modelbase4c.name_attribute(attr)};    
    <#elseif attr.name == "state">
  char  state[2];
    <#else>
  ${attrtype.name} ${modelbase4c.name_attribute(attr)}<#if attrtype.length??>[${attrtype.length}]</#if>;
    </#if>
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

    <#if attr.type.componentType??>
      <#if attr.type.componentType.name == "any[]">
/*!
** 添加【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_add_${modelbase.get_attribute_singular(attr)}_to_${attr.name}(${namespace}_${obj.name}_p, void*);

/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${attr.name}(${namespace}_${obj.name}_p, void**, int);
      <#else>
/*!
** 添加【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_add_${attr.type.componentType.name}_to_${attr.name}(${namespace}_${obj.name}_p, ${namespace}_${attr.type.componentType.name}_p);

/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${attr.name}(${namespace}_${obj.name}_p, ${namespace}_${attr.type.componentType.name}_p*, int);      
      </#if>
    <#else>
/*!
** 设置【${modelbase.get_object_label(obj)}】的【${modelbase.get_object_label(attr)}】属性值。
*/
void
${namespace}_${obj.name}_set_${modelbase4c.name_attribute(attr)}(${namespace}_${obj.name}_p, <#if attrtype.name == "char*" || (attrtype.name == "char" && attrtype.length??)>const char*<#else>${attrtype.name}</#if>);
    </#if>
  </#list>
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_PKT_H__
