<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4rust.ftl" as modelbase4rust>
<#if license??>
${rust.license(license)}
</#if>
mod ${namespace} {

pub mod sql {

<#list model.objects as obj>

#[allow(dead_code)]
pub struct ${rust.nameType(obj.name)}Query {
<#list obj.attributes as attr>  
  pub ${modelbase4rust.name_attribute_as_primitive(attr)}: Option<String>,
</#list>  
}

impl ${rust.nameType(obj.name)}Query {

  #[allow(dead_code)]
  pub fn new() -> Self {
    Self {
<#list obj.attributes as attr>  
      ${modelbase4rust.name_attribute_as_primitive(attr)}: Option::None,
</#list>        
    }
  }
}
</#list>

} // mod sql

} // mod ${namespace}

#[cfg(test)]
mod tests {
  use ${namespace}::sql::*;
<#list model.objects as obj>

  /*
  ** 测试【modelbase.get_object_label(obj)】对象。
  */
  #[test]
  fn test_new_${obj.name}_query() {
    let mut query = ${rust.nameType(obj.name)}Query::new();
<#list obj.attributes as attr>
    <#if attr.type.name == "string">
    query.${modelbase4rust.name_attribute_as_primitive(attr)} = Some(String::from("hello, 中国"));
    </#if>
</#list>  
<#list obj.attributes as attr>
    <#if attr.type.name == "string">
    query.${modelbase4rust.name_attribute_as_primitive(attr)} = Some(String::from("hello, 世界"));
    </#if>
</#list>  
  }
</#list>  
} // mod tests
