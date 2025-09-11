<#function test_json_value attr>
  <#assign Timestamp = statics['java.sql.Timestamp']>
  <#assign Date = statics['java.sql.Date']>
  <#if attr.constraint.domainType.name?contains('enum')>
    <#return '"' + tatabase.enumcode(attr.constraint.domainType.name) + '"'>
  <#elseif attr.constraint.domainType.name == 'id' || attr.name == 'id' || attr.type.custom || attr.identifiable>
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return "\"" + val + "\"">
  <#elseif attr.constraint.domainType.name == 'json'>
    <#return '{}'>
  <#elseif attr.constraint.domainType.name == 'state'>
    <#return '"E"'>
  <#elseif attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
    <#return '"123456"'>  
  <#elseif attr.type.name == 'bool'>
    <#return '"true"'>
  <#elseif attr.type.name == 'number'>
    <#return '"' + tatabase.number(0,100) + '"'>
  <#elseif attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return '36'>
  <#elseif attr.type.name == 'long'>
    <#return '36'>
  <#elseif attr.type.name == 'date'>
    <#return '"' + tatabase.datetime() + '"'>
  <#elseif attr.type.name == 'datetime'>
    <#return '"' + tatabase.datetime() + '"'>
  <#elseif attr.type.custom>
    <#return '"654321"'>
  <#elseif attr.type.collection>
    <#return '[]'>
  <#elseif attr.type.name == 'string'>
    <#return '"' + tatabase.string((attr.type.length!12)/4) + '"'>  
  <#else>
    <#return '"666666"'>
  </#if>
</#function>