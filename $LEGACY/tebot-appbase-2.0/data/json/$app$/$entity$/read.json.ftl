<#import '/$/modelbase.ftl' as modelbase>
<#assign Timestamp = statics['java.sql.Timestamp']>
<#assign Date = statics['java.sql.Date']>
{
  "data": {
<#list entity.attributes as attr>
  <#if attr.constraint.domainType.name?contains('enum')>
    "${modelbase.get_attribute_sql_name(attr)}":"${tatabase.enumcode(attr.constraint.domainType.name)}",
  <#elseif attr.constraint.domainType.name == 'json'>
    "${modelbase.get_attribute_sql_name(attr)}":{},
  <#elseif attr.type.name == 'string'>
    "${modelbase.get_attribute_sql_name(attr)}":"${tatabase.string((attr.type.length!12)/4)}",
  <#elseif attr.type.name == 'bool'>
    "${modelbase.get_attribute_sql_name(attr)}":"true",
  <#elseif attr.type.name == 'number'>
    "${modelbase.get_attribute_sql_name(attr)}":${tatabase.number(0,100)},
  <#elseif attr.type.name == 'date'>
    "${modelbase.get_attribute_sql_name(attr)}":${Date.valueOf(tatabase.date())?long?string('#')},
  <#elseif attr.type.name == 'datetime'>
    "${modelbase.get_attribute_sql_name(attr)}":${Timestamp.valueOf(tatabase.datetime())?long?string('#')},
  <#elseif attr.type.custom>
    "${java.nameVariable(attr.name)}":{},
  <#else>
    "${modelbase.get_attribute_sql_name(attr)}":"123456",
  </#if>
</#list>
    "0":"0"    
  }
}