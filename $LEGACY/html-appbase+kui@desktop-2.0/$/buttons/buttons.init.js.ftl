<#list children as child>
  <#if !child.role??><#continue></#if>
    <#attempt>

//
// 绑定【${child.title!''}】按钮。
//  
<#include child.role + '.init.js.ftl'>
    <#recover>
    </#attempt>
</#list>