<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${rust.license(license)}
</#if>

<#list model.objects as obj>

#[allow(dead_code)]
#[derive(Debug)]
pub struct ${rust.nameType(obj.name)} {
<#list obj.attributes as attr>
  <#if attr.type.componentType??><#-- 优先判断，是否是自定义数组类型的对象 -->
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

  #[allow(dead_code)]
  pub fn new() -> Self {
    Self {
<#list obj.attributes as attr>  
  <#if attr.type.componentType??><#-- 优先判断，是否是自定义数组类型的对象 -->
      ${rust.nameVariable(attr.name)}: Option::None,
  <#elseif attr.type.custom><#-- 其次判断单个引用自定义类型 -->
      ${rust.nameVariable(attr.name)}: Option::None,
  <#elseif attr.constraint.domainType.name?starts_with("enum")>
      ${rust.nameVariable(attr.name)}: Option::None,
  <#elseif attr.name == "state">
      ${rust.nameVariable(attr.name)}: Option::None,
  <#elseif attr.type.name == "string">
      ${rust.nameVariable(attr.name)}: Option::None,
  <#elseif attr.type.name == "int" || attr.type.name == 'integer'>
      ${rust.nameVariable(attr.name)}: 0,
  <#elseif attr.type.name == "long">
      ${rust.nameVariable(attr.name)}: 0,
  </#if>  
</#list>        
    }
  }
}  
</#list>


