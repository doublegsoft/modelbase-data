<#--
 ### get re-assembling attribute type object.
 -->
<#function type_attribute attr>
  <#if attr.type.name == "string">
    <#return {"name": "char*"}>
  <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <#return {"name": "int"}>
  <#elseif attr.type.name == "date" || attr.type.name == "time" || attr.type.name == "datetime">
    <#return {"name": "char*"}>
  <#elseif attr.type.name == "bool">
    <#return {"name": "char"}>
  <#elseif attr.type.custom>
    <#return {"name": namespace + "_" + attr.type.name + "_p"}>  
  </#if>
  <#return {"name": "char*"}>
</#function>

<#--
 ### get struct field name of attribute.
 -->
<#function name_attribute attr>
  <#if attr.type.custom>
    <#return attr.name>  
  </#if>
  <#return c.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_as_primitive attr>
  <#return c.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_as_primitive_plural attr>
  <#return c.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>
