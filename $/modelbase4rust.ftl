<#--
 ### get struct field name of attribute.
 -->
<#function name_attribute attr>
  <#if attr.type.custom>
    <#return attr.name>  
  </#if>
  <#return rust.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_as_primitive attr>
  <#return rust.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_as_primitive_plural attr>
  <#return rust.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>
