<#import '/$/modelbase.ftl' as modelbase>
{
  "data": [{
<#list entity.attributes as attr>
  <#if attr.type.collection>
    "${js.nameVariable(attr.name)}":[]<#if attr?index != entity.attributes?size - 1>,</#if>
  <#else>
    "${js.nameVariable(attr.name)}":""<#if attr?index != entity.attributes?size - 1>,</#if>
  </#if>
</#list>    
  },{
<#list entity.attributes as attr>
  <#if attr.type.collection>
    "${js.nameVariable(attr.name)}":[]<#if attr?index != entity.attributes?size - 1>,</#if>
  <#else>
    "${js.nameVariable(attr.name)}":""<#if attr?index != entity.attributes?size - 1>,</#if>
  </#if>
</#list>    
  },{
<#list entity.attributes as attr>
  <#if attr.type.collection>
    "${js.nameVariable(attr.name)}":[]<#if attr?index != entity.attributes?size - 1>,</#if>
  <#else>
    "${js.nameVariable(attr.name)}":""<#if attr?index != entity.attributes?size - 1>,</#if>
  </#if>
</#list>    
  },{
<#list entity.attributes as attr>
  <#if attr.type.collection>
    "${js.nameVariable(attr.name)}":[]<#if attr?index != entity.attributes?size - 1>,</#if>
  <#else>
    "${js.nameVariable(attr.name)}":""<#if attr?index != entity.attributes?size - 1>,</#if>
  </#if>
</#list>    
  },{
<#list entity.attributes as attr>
  <#if attr.type.collection>
    "${js.nameVariable(attr.name)}":[]<#if attr?index != entity.attributes?size - 1>,</#if>
  <#else>
    "${js.nameVariable(attr.name)}":""<#if attr?index != entity.attributes?size - 1>,</#if>
  </#if>
</#list>    
  }]
}