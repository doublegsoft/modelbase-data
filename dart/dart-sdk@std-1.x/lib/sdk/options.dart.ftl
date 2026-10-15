<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'base.dart';
<#assign existingOptions = {}>
<#list model.objects as obj>
  <#list obj.attributes as attr>
    <#assign domainType = attr.constraint.domainType.toString()>
    <#if domainType?starts_with('enum') && !existingOptions[domainType]??>
      <#assign pairs = typebase.enumtype(domainType)>
      
///
/// 【${modelbase.get_object_label(obj)} ${modelbase.get_attribute_label(attr)}】枚举值
///        
const List<Option> arrayOf${dart.nameType(obj.name)}${dart.nameType(attr.name)} = [
      <#list pairs as pair>
  Option(text: '${pair.text}', value: '${pair.code}',),    
      </#list>
];

const Map<String,Option> mapOf${dart.nameType(obj.name)}${dart.nameType(attr.name)} = {
      <#list pairs as pair>
  '${pair.code}': Option(text: '${pair.text}', value: '${pair.code}',),    
      </#list>
};   

String getTextOf${dart.nameType(obj.name)}${dart.nameType(attr.name)}(String? value) {
  if (value == null) {
    return '';
  }
  Option? option = mapOf${dart.nameType(obj.name)}${dart.nameType(attr.name)}[value];
  if (option == null) {
    return '';
  }
  return option.text;
}

String getValueOf${dart.nameType(obj.name)}${dart.nameType(attr.name)}(String? text) {
  if (text == null) {
    return '';
  }
  for (Option opt in arrayOf${dart.nameType(obj.name)}${dart.nameType(attr.name)}) {
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