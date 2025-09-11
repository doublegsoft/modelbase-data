<#import "/$/modelbase.ftl" as modelbase>
<#--
 ### 可编辑表单
 -->
<#macro print_field_form_editable obj indent>
${""?left_pad(indent)}GtkWidget* form_${obj.name} = NULL;
  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
${""?left_pad(indent)}//【${modelbase.get_attribute_label(attr)}】      
    <#if attr.type.name == "date" || attr.type.name == "datetime">  
${""?left_pad(indent)}GtkWidget* entry_${attr.name} = NULL;    
    <#else>
${""?left_pad(indent)}GtkWidget* entry_${attr.name} = NULL;
    </#if>
${""?left_pad(indent)}GtkWidget* error_${attr.name} = NULL;    
  </#list>
</#macro>

