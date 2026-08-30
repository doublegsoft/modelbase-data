<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4rust.ftl" as modelbase4rust>
<#if license??>
${rust.license(license)}
</#if>
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

#[allow(dead_code)]
#[derive(Debug, Default, Clone, PartialEq)]
pub struct ${rust.nameType(obj.name)}Query {
<#list obj.attributes as attr>  
  pub ${modelbase4rust.name_attribute_primitive(attr)}: Option<String>,
</#list>  
}

impl ${rust.nameType(obj.name)}Query {

}
</#list>