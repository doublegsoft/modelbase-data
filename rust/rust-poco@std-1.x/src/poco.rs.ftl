<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4rust.ftl" as modelbase4rust>
<#if license??>
${rust.license(license)}
</#if>
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

#[allow(dead_code)]
#[derive(Debug, Default, Clone, PartialEq)]
pub struct ${rust.nameType(obj.name)} {
<#list obj.attributes as attr>
  <#if attr.name == "type">
  pub r#type: Option<String>,
  <#elseif attr.type.componentType??><#-- 优先判断，是否是自定义数组类型的对象 -->
  pub ${rust.nameVariable(attr.name)}: Option<String>,
  <#elseif attr.type.custom><#-- 其次判断单个引用自定义类型 -->
  pub ${rust.nameVariable(attr.name)}: Option<${rust.nameType(attr.type.name)}>,
  <#elseif attr.constraint.domainType.name?starts_with("enum")>
  pub ${rust.nameVariable(attr.name)}: Option<String>,
  <#elseif attr.name == "state">
  pub ${rust.nameVariable(attr.name)}: Option<String>,
  <#elseif attr.type.name == "string">
  pub ${rust.nameVariable(attr.name)}: Option<String>,
  <#elseif attr.type.name == "int" || attr.type.name == 'integer'>
  pub ${rust.nameVariable(attr.name)}: i32,
  <#elseif attr.type.name == "long">
  pub ${rust.nameVariable(attr.name)}: i32,
  </#if>  
</#list>  
}

impl ${rust.nameType(obj.name)} {

}  
</#list>


