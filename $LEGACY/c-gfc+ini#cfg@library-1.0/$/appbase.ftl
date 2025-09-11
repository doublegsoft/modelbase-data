<#function get_domain_type_name domainType>
  <#local ret = domainType.name>
  <#if ret?index_of("&") == 0>
    <#local ret = ret?substring(1)>
  </#if>
  <#local leftIndex = ret?index_of("(")>
  <#if leftIndex == -1>
    <#return ret>
  </#if>
  <#return ret?substring(0, leftIndex)>
</#function>

<#function get_domain_type_length domainType>
  <#local leftIndex = domainType.name?index_of("(")>
  <#if leftIndex == -1>
    <#return 0>
  </#if>
  <#return (domainType.name?substring(leftIndex + 1, domainType.name?index_of(")")))?number>
</#function>

<#function sort_objects objects>
  <#local ret = []>
  <#local cache = {}>
  <#list objects as obj>
    <#if cache[obj.name]??><#continue></#if>
    <#local customless = false>
    <#list obj.attributes as attr>
      <#if attr.type.custom>
        <#local customless = true>
        <#break>
      </#if>
    </#list>
    <#if !customless>
      <#local ret = ret + [obj]>
      <#local cache = cache + {obj.name: obj}>
    </#if>
  </#list>
  <#list objects as obj>
    <#if cache[obj.name]??><#continue></#if>
    <#local ret = ret + [obj]>
    <#local cache = cache + {obj.name: obj}>
  </#list>
  <#return ret>
</#function>