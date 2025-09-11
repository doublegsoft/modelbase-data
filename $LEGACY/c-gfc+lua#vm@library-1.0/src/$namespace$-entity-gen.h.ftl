<#import '/$/paradigm-internal.ftl' as internal>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${c.nameConstant(namespace)}_ENTITY_GEN_H__
#define __${c.nameConstant(namespace)}_ENTITY_GEN_H__

#ifdef __cplusplus
extern "C"
{
#endif

<#list model.objects as obj>
/*!
** 重定义${obj.text!''}.
*/
typedef struct ${c.nameNamespace(namespace)}_${internal.type_object(obj)}_s ${c.nameConstant(namespace)?lower_case}_${internal.type_object(obj)}_t;

</#list>
<#list model.objects as obj>
/*!
** ${obj.text!''}.
*/
struct ${c.nameNamespace(namespace)}_${internal.type_object(obj)}_s
{
  <#list obj.attributes as attr>
  /*!
  ** ${attr.text!''}<#if attr.persistenceName??>--${attr.persistenceName}</#if>.
  */
  <#if attr.type.primitive>
  ${internal.type_attribute(attr)} ${attr.name?lower_case}${internal.length_attribute(attr)};
  <#elseif attr.type.custom>
  ${c.nameNamespace(namespace)}_${internal.type_attribute(attr)} ${attr.name?lower_case}${internal.length_attribute(attr)};
  <#elseif attr.type.collection>
  ${c.nameNamespace(namespace)}_${internal.type_attribute(attr)} ${attr.name?lower_case}${internal.length_attribute(attr)};

  size_t ${attr.name?lower_case}_size;
  </#if>

  </#list>
};

</#list>
#ifdef __cplusplus
}
#endif

#endif // __${c.nameConstant(namespace)}_ENTITY_GEN_H__
