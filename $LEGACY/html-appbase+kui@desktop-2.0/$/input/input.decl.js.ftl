<#if role??>
  <#if role == 'checklist'>
<#include 'checklist.decl.js.ftl'>
  </#if>
  <#if role == 'checktree'>
<#include 'checktree.decl.js.ftl'>
  </#if>
</#if>