<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4sql.ftl" as modelbase4sql>
<#----------------------------->
<#-- 找到没有被任何对象引用的对象 -->
<#----------------------------->
<#list model.objects as obj>
  <#if !obj.isLabelled("fact")><#continue></#if>
  <#list obj.attributes as attr>
    <#if attr.isLabelled("persistence")><#continue></#if>
    
  </#list>
</#list>