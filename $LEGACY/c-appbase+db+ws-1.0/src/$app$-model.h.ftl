<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${namespace?upper_case}_MODEL_H__
#define __${namespace?upper_case}_MODEL_H__

#include <json.h>
#include <gfc.h>

#ifdef __cplusplus
extern "C" {
#endif
<#list model.objects as obj>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value')><#continue></#if>
  <#assign max_arg_len = appbase.max_object_argument_length(obj)>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#assign attrSelect = appbase.get_select_attributes(obj)>
  <#assign attrDelete = appbase.get_delete_attributes(obj)>
  <#assign attrUpdate = appbase.get_update_attributes(obj)>

/*!
** 创建【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_model_create_${obj.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 15)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
  <#list obj.attributes as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}<#if attr?index == obj.attributes?size - 1>);<#else>,</#if>
  </#list>
  <#if attrDelete?size != 0>

/*!
** 删除【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_model_delete_${obj.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 15)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,              
    <#list attrDelete as attr>
      <#assign typename = appbase.type_attribute_as_argument(attr)>
      <#assign persistenceDelete = attr.getLabelledOptions('persistence')['delete']>
      <#if persistenceDelete == '<>'>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}0,
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}1<#if attr?index == attrDelete?size - 1>);<#else>,</#if>
      <#else>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}<#if attr?index == attrDelete?size - 1>);<#else>,</#if>
      </#if>
    </#list>      
  </#if>
  <#if attrUpdate?size != 0>
    <#list attrUpdate as attr>
      <#assign persistenceUpdate = attr.getLabelledOptions('persistence')['update']>

/*!
** 更新【${modelbase.get_object_label(obj)}】中【${modelbase.get_attribute_label(attr)}】数据。
*/
int
${namespace}_model_update_${obj.name}_${attr.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 16)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
      <#list attrIds as attrId>
        <#assign typename = appbase.type_attribute_as_argument(attrId)>
${""?left_pad(namespace?length + obj.name?length + attr.name?length + 16)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attrId.name},
      </#list>
      <#assign typename = appbase.type_attribute_as_argument(attr)>
${""?left_pad(namespace?length + obj.name?length + attr.name?length + 16)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name});      
    </#list>
  </#if>

/*!
** 查询【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_model_select_${obj.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 15)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
${""?left_pad(namespace?length + obj.name?length + 15)}gfc_list_p${""?left_pad(max_arg_len - 10 + 2)}list,
  <#list attrSelect as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
    <#assign persistenceSelect = attr.getLabelledOptions('persistence')['select']>
    <#if persistenceSelect == '<>'>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}0,
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}1,
    <#else>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)},
    </#if>
  </#list>   
${""?left_pad(namespace?length + obj.name?length + 15)}const char*${""?left_pad(max_arg_len - typename?length + 2)}suffix);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${namespace?upper_case}_MODEL_H__