<#--
 ### Gets type name for the attribute. And supports both collection and
 ### non-collection types.
 ### <p>
 ### And attribute type could be primitive, custom and collection.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return
 ###        the programming language type name
 #-->
<#function type_attribute attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#return java.nameType(refObj.name)>
  <#elseif attr.type.name == "json">
    <#return "string">
  <#elseif attr.type.primitive>
    <#return typebase.typename(attr.type.name, "csharp", "string")>
  <#elseif attr.type.collection>
    <#assign fakeAttr = {"type": attr.type.componentType}>
    <#return "List<" + type_attribute(fakeAttr) + ">">
  <#elseif attr.type.domain>
    <#assign exprDomain = attr.type.toString()>
    <#if exprDomain?index_of("&") == 0>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#return java.nameType(refObj.name)>
    <#else>
      <#return typebase.typename(attr.type.name, "csharp", "string")>
    </#if>
  </#if>
  <#return typebase.typename(attr.type.name, "csharp", "string")>
</#function>