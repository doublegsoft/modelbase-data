<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>

class Option {

  final String text;
  
  final String value;
  
  const Option({
    required this.text,
    required this.value,
  });
}

///
/// 【语言】枚举值
///
const List<Option> arrayOfLanguage = [
  Option(text: '中文', value: 'ZH',),
  Option(text: '英文', value: 'EN',),
  Option(text: '德文', value: 'DE',),
  Option(text: '日文', value: 'JP',),
];

const Map<String,Option> mapOfLanguage = {
  'ZH': Option(text: '中文', value: 'ZH',),
  'EN': Option(text: '英文', value: 'EN',),
  'DE': Option(text: '德文', value: 'DE',),
  'JP': Option(text: '日文', value: 'JP',),
};

String getTextOfLanguage(String? value) {
  if (value == null) {
    return '';
  }
  Option? option = mapOfLanguage[value];
  if (option == null) {
    return '';
  }
  return option.text;
}

String getValueOfLanguage(String? text) {
  if (text == null) {
    return '';
  }
  for (Option opt in arrayOfLanguage) {
    if (opt.text == text) {
      return opt.value;
    }
  }
  return '';
}
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
  Option(text: '${pair.value}', value: '${pair.key}',),    
      </#list>
];

const Map<String,Option> mapOf${dart.nameType(obj.name)}${dart.nameType(attr.name)} = {
      <#list pairs as pair>
  '${pair.key}': Option(text: '${pair.value}', value: '${pair.key}',),    
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