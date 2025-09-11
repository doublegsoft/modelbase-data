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
<#assign attrRefDetailSlave = ''>
<#-- 连接作用的对象 -->
<#assign conjSlave = ''>
<#assign conjSlaveEnum = {}>
<#-- 连接的主要对象 -->
<#assign masterInSlave = ''>
<#-- 连接的详细对象 -->
<#assign detailSlave = ''>
<#-- 算法：分别找到以上三个对象 -->
<#list slaves as slave>
  <#if modelbase.get_id_attributes(slave)?size != 1>
    <#assign conjSlave = slave>
    <#assign conjSlaveEnum = appbase.get_conj_enum(conjSlave)>
  </#if>
  <#list slave.attributes as attr>
    <#if attr.type.name == master.name>
      <#assign masterInSlave = master>
      <#break>
    </#if>
    <#list slaves as innerSlave>
      <#if attr.type.name == innerSlave.name>
        <#assign masterInSlave = innerSlave>
        <#break>
      </#if>
    </#list>
  </#list>
</#list>
<#if conjSlave != ''>
  <#list conjSlave.attributes as attr>
    <#list slaves as slave>
      <#if attr.type.name == slave.name>
        <#assign detailSlave = slave>
        <#assign attrRefDetailSlave = attr>
        <#break>
      </#if>
    </#list>
  </#list>
</#if>

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
<@appbase.print_json_attributes obj=master varprefix='' />
<#list slaves as slave>
  <#if conjSlave != '' && (slave == conjSlave || detailSlave == slave)><#continue></#if>
<@appbase.print_json_attributes obj=slave varprefix='' />
</#list>
<#if conjSlave != ''>
  <#list conjSlaveEnum.values as val>
<@appbase.print_json_attributes obj=detailSlave varprefix=conjSlaveEnum.codes[val?index] />
  </#list>
</#if>
<#if meta != ''>
  <#assign metaColumns = []>
  <#assign valueAttr = ''>
  <#list meta.attributes as attr>
    <#if attr.name?index_of('meta_') == 0>
      <#assign metaColumns = metaColumns + [attr]>
    </#if>
  </#list>
  <#list metaColumns as metaColumn>
  "${metaColumn.getLabelledOptions('properties')['title']}": "${tatabase.string(12)}",
  </#list>
</#if>
<#if pivot != ''>
  <#list pivot.attributes as attr>
    <#assign custom = attr.getLabelledOptions("properties")["custom"]!''>
    <#if custom?is_boolean && custom == true>
      <#assign firstCustomAttr = attr>
      <#break>
    </#if>
  </#list>
  <#assign pivotColumns = []>
  <#list pivot.attributes as attr>
    <#if attr.name?index_of('pivot_') == 0>
      <#assign pivotColumns = pivotColumns + [attr]>
    </#if>
  </#list>
  <#list pivotColumns as pivotColumn>
    <#list pivotColumn.getLabelledOptions('properties') as key, val>
      <#if val?string == '@'>
  "${java.nameVariable(key)}": "${tatabase.number(60, 100)}",
      </#if>
    </#list>
  </#list>
</#if>
  "modifierId":"10"
}