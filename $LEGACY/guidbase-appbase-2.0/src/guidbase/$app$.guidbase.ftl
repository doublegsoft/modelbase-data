<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/guidbase.ftl' as guidbase>

<#--#################################################################################################################-->
<#-- 表单【form】                                                                                                     -->
<#--#################################################################################################################-->
<#list model.objects as obj>
  <#assign formObj = obj.getLabelledOptions('widget')['form']!>
  <#if formObj == ''><#continue></#if>

//
// ${modelbase.get_object_label(obj)}
// 
page_${obj.name}:page(title: "${modelbase.get_object_label(obj)}")<
  form_${obj.name}:form(title: "${modelbase.get_object_label(obj)}编辑表单")<
  <#list obj.attributes as attr>
    <#assign formAttr = attr.getLabelledOptions('widget')['form']!>
    <#if formAttr == ''><#continue></#if>
    attr.name:any(title: "")>,
  </#list>
  >
>
</#list>