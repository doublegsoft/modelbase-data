<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4rust.ftl" as modelbase4rust>
use ${app.name}::query::*;
#[cfg(test)]
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*
** 测试【modelbase.get_object_label(obj)】对象。
*/
#[test]
fn test_new_${obj.name}_query() {
  let mut query = ${rust.nameType(obj.name)}Query::default();
<#list obj.attributes as attr>
  <#if attr.type.name == "string">
  query.${modelbase4rust.name_attribute_primitive(attr)} = Some(String::from("hello, 中国"));
  </#if>
</#list>  
<#list obj.attributes as attr>
  <#if attr.type.name == "string">
  query.${modelbase4rust.name_attribute_primitive(attr)} = Some(String::from("hello, 世界"));
  </#if>
</#list>  
}
</#list>  
