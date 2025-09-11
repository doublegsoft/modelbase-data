<#if role??>
  <#if role == 'checklist'>
<#include 'checklist.set.js.ftl'>
  <#elseif role == 'select'>
<#include 'select.set.js.ftl'>
  <#elseif role == 'date'>
<#include 'date.set.js.ftl'>
  <#elseif role == 'daterange'>
<#include 'daterange.set.js.ftl'>
  </#if>
</#if>