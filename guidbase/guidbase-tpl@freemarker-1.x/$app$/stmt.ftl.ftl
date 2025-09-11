<#import "/$/modelbase.ftl" as modelbase>
<#assign widgets = []>
<#list model.objects as obj>
  <#if obj.isLabelled("widget") && (obj.getLabelledOptions("widget")["fragment"]!"") != "true">
    <#assign widgets = widgets + [obj]>
  </#if>
</#list>

<#list languages as lang>

${r'<#-- '}${lang?upper_case}${r' DECLARE -->'}
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

<#-- FIELDS -->
<#list languages as lang>
  <#if lang?index != 0><#continue></#if>

${r'<#-- '}${lang?upper_case}${r' FIELDS -->'}
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
</#list>

<#-- METHODS -->
<#list languages as lang>
  <#if lang?index != 0><#continue></#if>

${r'<#-- '}${lang?upper_case}${r' METHODS -->'}
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
</#list>
