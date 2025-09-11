<#import "/$/modelbase.ftl" as modelbase>
<#assign widgets = []>
<#list model.objects as obj>
  <#if obj.isLabelled("widget") && (obj.getLabelledOptions("widget")["fragment"]!"") != "true">
    <#assign widgets= widgets + [obj]>
  </#if>
</#list>
<#list widgets as widget>
${r"<#--"}
${r" ###############################################################################"}
${r" ###"} 【${modelbase.get_object_label(widget)}】
${r" ###############################################################################"}
${r" -->"}
  <#list languages as lang>
${r"<#macro print_"}${lang}${r"_declare_"}${widget.name}${r" widget indent>"}
${r'${""?left_pad(indent)}'}
${r'${""?left_pad(indent)}'}
${r'${""?left_pad(indent)}'}
${r"</#macro>"}

    <#if lang?index == 0>
${r"<#macro print_"}${lang}${r"_fields_"}${widget.name}${r" widget indent>"}
${r'${""?left_pad(indent)}'}
${r'${""?left_pad(indent)}'}
${r'${""?left_pad(indent)}'}
${r"</#macro>"}

${r"<#macro print_"}${lang}${r"_methods_"}${widget.name}${r" widget indent>"}
${r'${""?left_pad(indent)}'}
${r'${""?left_pad(indent)}'}
${r'${""?left_pad(indent)}'}
${r"</#macro>"}

    </#if>
  </#list>
</#list>

${r"<#--"}
${r" ###############################################################################"}
${r" ###"} 【整体部件】
${r" ###############################################################################"}
${r" -->"}
<#list languages as lang>

${r'<#-- '}${lang?upper_case}${r' DECLARE -->'}
${r"<#macro print_"}${lang}${r"_declare_widget widget indent>"}
  <#list widgets as widget>
    <#if widget?index == 0>
${r'  <#if widget.type == "'}${widget.name}${r'">'}  
${r'<@'}${app.name}${r'.print_'}${lang}${r'_declare_'}${widget.name} ${r'widget=widget indent=indent />'}
    <#else>
${r'  <#elseif widget.type == "'}${widget.name}${r'">'}  
${r'<@'}${app.name}${r'.print_'}${lang}${r'_declare_'}${widget.name} ${r'widget=widget indent=indent />'}
    </#if>
  </#list>
  <#if widgets?size != 0>
${r"  </#if>"}
  </#if>
</#list>
${r"</#macro>"}  
<#-- FIELDS -->
<#list languages as lang>
  <#if lang?index != 0><#continue></#if>

${r'<#-- '}${lang?upper_case}${r' FIELDS -->'}
${r"<#macro print_"}${lang}${r"_fields_widget widget indent>"}
  <#list widgets as widget>
    <#if widget?index == 0>
${r'  <#if widget.type == "'}${widget.name}${r'">'}  
${r'<@'}${app.name}${r'.print_'}${lang}${r'_fields_'}${widget.name} ${r'widget=widget indent=indent />'}
    <#else>
${r'  <#elseif widget.type == "'}${widget.name}${r'">'}  
${r'<@'}${app.name}${r'.print_'}${lang}${r'_fields_'}${widget.name} ${r'widget=widget indent=indent />'}
    </#if>
  </#list>
  <#if widgets?size != 0>
${r"  </#if>"}
  </#if>
${r"</#macro>"}  
</#list>

<#-- METHODS -->
<#list languages as lang>
  <#if lang?index != 0><#continue></#if>

${r'<#-- '}${lang?upper_case}${r' METHODS -->'}
${r"<#macro print_"}${lang}${r"_methods_widget widget indent>"}
  <#list widgets as widget>
    <#if widget?index == 0>
${r'  <#if widget.type == "'}${widget.name}${r'">'}  
${r'<@'}${app.name}${r'.print_'}${lang}${r'_methods_'}${widget.name} ${r'widget=widget indent=indent />'}
    <#else>
${r'  <#elseif widget.type == "'}${widget.name}${r'">'} 
${r'<@'}${app.name}${r'.print_'}${lang}${r'_methods_'}${widget.name} ${r'widget=widget indent=indent />'}
    </#if>
  </#list>
  <#if widgets?size != 0>
${r"  </#if>"}
  </#if>
${r"</#macro>"}  
</#list>