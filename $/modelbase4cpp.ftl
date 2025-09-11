<#--
 ### get re-assembling attribute type object.
 -->
<#function type_attribute attr>
  <#if attr.type.componentType??>
    <#return {"name": "std::vector<" + type_component(attr.type.componentType).name + ">*"}>
  </#if>
  <#return type_component(attr.type)>
</#function>

<#function type_component type>
  <#if type.name == "any" || type.name == "any[]">
    <#return {"name": "std::any*"}>
  <#elseif type.name == "string">
    <#return {"name": "std::string"}>
  <#elseif type.name == "int" || type.name == "integer">
    <#return {"name": "int"}>
  <#elseif type.name == "date" || type.name == "time" || type.name == "datetime">
    <#return {"name": "std::string"}>
  <#elseif type.name == "bool">
    <#return {"name": "bool"}>
  <#elseif type.custom>
    <#return {"name": namespace + "::" + cpp.nameType(type.name) + "*"}>  
  </#if>
  <#return {"name": "std::string"}>
</#function>

<#--
 ### get struct field name of attribute.
 -->
<#function name_attribute attr>
  <#if attr.type.custom>
    <#return cpp.nameVariable(attr.name)>  
  </#if>
  <#return cpp.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_as_primitive attr>
  <#return cpp.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_as_primitive_plural attr>
  <#return cpp.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>
