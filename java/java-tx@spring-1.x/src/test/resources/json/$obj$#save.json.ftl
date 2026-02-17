<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
{
<#list obj.attributes as attr>
  <#if attr.type.collection><#continue></#if>
  <#if attr.constraint.defaultValue??><#continue></#if>
  <#if attr.name == "state">
  "state":"E",
  <#else>
  "${modelbase.get_attribute_sql_name(attr)}":${modelbase4java.test_json_value(attr)},
  </#if>
</#list>
  "0":"0"
}