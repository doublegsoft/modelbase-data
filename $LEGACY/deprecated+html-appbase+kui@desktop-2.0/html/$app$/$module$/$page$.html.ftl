<#import '/$/guidbase.ftl' as guidbase>
<#assign objName = module?substring(module?index_of('/') + 1)>
<#list children as child>
${plugin.render(child, 0, 'html')}
</#list>

<#if id == 'main'>
<script src="/html<#if application??>/${application}</#if>/${module}/${js.nameVariable(id)}.js" type="application/javascript"></script>
</#if>