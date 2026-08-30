<#list model.objects as obj>
${obj.name}
  <#list obj.attributes as attr>
    <#if attr.type.collection>
  ${attr.name}: ${attr.type.componentType.name}[<#if attr.type.length != 0>${attr.type.length}<#elseif attr.type.lengthVariable??>${attr.type.lengthVariable}</#if>]
    <#else>
  ${attr.name}: ${attr.type.name}<#if attr.type.lengthVariable??>(${attr.type.lengthVariable})</#if>
    </#if>
  </#list>
</#list>