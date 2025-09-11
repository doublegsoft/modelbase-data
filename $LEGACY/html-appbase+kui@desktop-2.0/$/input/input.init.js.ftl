<#if role??>
  <#if role == 'checklist'>
<#include 'checklist.init.js.ftl'>
  <#elseif role == 'checktree'>
<#include 'checktree.init.js.ftl'>
  <#elseif role == 'date'>
<#include 'date.init.js.ftl'>
  <#elseif role == 'daterange'>
<#include 'daterange.init.js.ftl'>
  <#elseif role == 'datetime'>
<#include 'datetime.init.js.ftl'>
  <#elseif role == 'select'>
<#include 'select.init.js.ftl'>
  <#elseif role == 'time'>
<#include 'time.init.js.ftl'>
  </#if>
</#if>