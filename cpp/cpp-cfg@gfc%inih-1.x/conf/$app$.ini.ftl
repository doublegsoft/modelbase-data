
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
[${obj.name}]
<#list obj.attributes as attr>
${attr.name} = 
</#list>
<#
</#list>