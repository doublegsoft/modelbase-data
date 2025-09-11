### ${app.name?upper_case} 页面集合

<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if !obj.isLabelled('entity') || !obj.isLabelled('value')><#continue></#if>
${modelbase.get_object_label(obj)} 只读页面
mobile/${app.name}/${obj.name}/read.html  

</#list>