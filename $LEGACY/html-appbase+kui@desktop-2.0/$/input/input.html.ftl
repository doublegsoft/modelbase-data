<#if role??>
  <#attempt>
<#include role + '.html.ftl'>
  <#recover>
  </#attempt>
</#if>