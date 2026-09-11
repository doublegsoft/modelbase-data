<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4json.ftl" as modelbase4json>
<#macro print_json_object obj indent>
${""?left_pad(indent)}{
  <#list obj.attributes as attr>
    <#if attr.type.collection>
      <#local collObj = model.findObjectByName(attr.type.componentType.name)>
${""?left_pad(indent)}  "${modelbase.get_attribute_sql_name(attr)}":<@print_json_array obj=collObj indent=indent+2 /><#if attr?index != obj.attributes?size - 1>,</#if>
    <#elseif attr.type.custom && !attr.identifiable>     
      <#local refObj = model.findObjectByName(attr.type.name)>
${""?left_pad(indent)}  "${modelbase.get_attribute_sql_name(attr)}":<@print_json_object obj=refObj indent=indent+2 /><#if attr?index != obj.attributes?size - 1>,</#if>
    <#else>
${""?left_pad(indent)}  "${modelbase.get_attribute_sql_name(attr)}":${modelbase4json.test_json_value(attr)}<#if attr?index != obj.attributes?size - 1>,</#if>
    </#if>
  </#list>
${""?left_pad(indent)}}</#macro>
<#macro print_json_array obj indent>
${""?left_pad(indent)}${modelbase.get_attribute_sql_name(attr)}: [{
  <#list 1..3 as idx>
    <#if idx != 1>
${""?left_pad(indent)}},{
    </#if>}
<@print_json_object obj=obj indent=indent+2 />    
  </#list>
${""?left_pad(indent)}}]</#macro>
<@print_json_object obj=obj indent=0 />