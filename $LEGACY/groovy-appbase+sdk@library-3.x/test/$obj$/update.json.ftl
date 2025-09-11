<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#-- 主对象，mapping模式 -->
<#assign master = ''>
<#-- 从对象，mapping模式 -->
<#assign slaves = []>
<#-- 多对一模式 -->
<#assign manys = []>
<#-- 扩展模式 -->
<#assign meta = ''>
<#-- 行列转换模式 -->
<#assign pivot = ''>

<#-- 区分各个不同类别的对象 -->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('master')>
    <#assign master = obj>
  <#elseif obj.isLabelled('slave')>
    <#assign slaves = slaves + [obj]>
  <#elseif obj.isLabelled('pivot')>
    <#assign pivot = obj>
  <#elseif obj.isLabelled('meta')>
    <#assign meta = obj>
  <#elseif obj.isLabelled('many')>
    <#assign manys = manys + [obj]>
  </#if>
</#list>
<#-- 主对象（mapping模式下第一个对象） -->
<#assign masterAttrIds = []>
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input == 'id'>
    <#assign masterAttrIds = masterAttrIds + [attr]>
  </#if>
</#list>

<#global printedAttrs = {}>
<#assign existingAttrIds = {}>
<#list masterAttrIds as masterAttrId>
  <#assign varMasterAttrId = modelbase.get_attribute_sql_name(masterAttrId)>
  <#assign existingAttrIds = existingAttrIds + {varMasterAttrId: masterAttrId}>
</#list>
<#list slaves as slave>
  <#assign slaveAttrIds = modelbase.get_id_attributes(slave)>
  <#if appbase.is_slave_being_master(master, slave)>
    <#assign existingAttrIds = existingAttrIds + {modelbase.get_attribute_sql_name(slaveAttrIds[0]): slaveAttrIds[0]}>
    <#continue>
  </#if>
  <#list slaveAttrIds as slaveAttrId>
    <#assign varSlaveAttrId = modelbase.get_attribute_sql_name(slaveAttrId)>
    <#if existingAttrIds[varSlaveAttrId]??><#continue></#if>
    <#assign existingAttrIds = existingAttrIds + {varSlaveAttrId: slaveAttrId}>
  </#list>
</#list>
<#-- 参数变量 -->
{
<#list master.attributes as attr>
  <#if attr.getLabelledOptions('properties')['input'] == 'id'>
  "${modelbase.get_attribute_sql_name(attr)}":"${tatabase.string(10)}",
  </#if>
</#list>
<@appbase.print_json_attributes obj=master varprefix='' />
  "modifierId":"10"
}
