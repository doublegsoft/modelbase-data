<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = detailable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign idAttr = idAttrs[0]>
<#assign detailType = obj.getLabelledOptions("detailable")["type"]!"">
<#if detailType == "article">
<#include "/$/detail/article.vue.ftl">
<#elseif detailType == "profile">
<#include "/$/detail/profile.vue.ftl">
<#else>
<#include "/$/detail/confortable.vue.ftl">
</#if>