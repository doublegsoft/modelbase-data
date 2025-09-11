<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
const sdk = {};

<#assign existingOptions = {}>
<#list model.objects as obj>
  <#list obj.attributes as attr>
    <#assign domainType = attr.constraint.domainType.toString()>
    <#if domainType?starts_with('enum') && !existingOptions[domainType]??>
      <#assign pairs = typebase.enumtype(domainType)>
      
///
/// 【${modelbase.get_object_label(obj)} ${modelbase.get_attribute_label(attr)}】枚举值
///        
sdk.arrayOf${js.nameType(obj.name)}${js.nameType(attr.name)} = [
      <#list pairs as pair>
  {text: '${pair.value}', value: '${pair.key}',},    
      </#list>
];

sdk.mapOf${js.nameType(obj.name)}${js.nameType(attr.name)} = {
      <#list pairs as pair>
  '${pair.key}': {text: '${pair.value}', value: '${pair.key}',},    
      </#list>
};   

sdk.getTextOf${js.nameType(obj.name)}${js.nameType(attr.name)} = function(value) {
  if (value == null || (typeof value === 'undefined')) {
    return '';
  }
  let option = sdk.mapOf${js.nameType(obj.name)}${js.nameType(attr.name)}[value];
  if (option == null) {
    return '';
  }
  return option.text;
}

sdk.getValueOf${js.nameType(obj.name)}${js.nameType(attr.name)} = function (text) {
  if (text == null || (typeof text === 'undefined')) {
    return '';
  }
  for (let opt in sdk.arrayOf${js.nameType(obj.name)}${js.nameType(attr.name)}) {
    if (opt.text == text) {
      return opt.value;
    }
  }
  return '';
}
      <#assign existingOptions += {domainType: ''}>
    </#if>
  </#list>
</#list>

if (typeof module !== 'undefined') {
  module.exports = { sdk };
}

export default sdk;