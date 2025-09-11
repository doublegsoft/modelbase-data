<#function name_attribute attr>
  <#if attr.type.custom>
    <#return attr.name>  
  </#if>
  <#return objc.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#--
<#function type_attribute attr>
  <#if attr.type.custom>
    <#return {"name": (namespace!"") + objc.nameType(attr.type.name) + "*"}>
  <#elseif attr.type.name == "string">
    <#return {"name":"NSString*"}>
  <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <#return {"name":"NSInteger"}>
  </#if>
  <#return {"name":"NSObject*"}>
</#function>
-->

<#function type_attribute attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#return objc.nameType(refObj.name) + "*">
  <#elseif attr.constraint.domainType.name == "id">
    <#return "NSInteger">    
  <#elseif attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">
    <#return "NSInteger">   
  <#elseif attr.type.name == "number" || attr.type.name == "decimal">
    <#return "NSDecimalNumber*">      
  <#elseif attr.name == "state">
    <#return "BOOL">   
  <#elseif attr.type.name == "bool">
    <#return "BOOL">          
  <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
    <#return "NSDate*">  
  <#elseif attr.type.name == "json">
    <#return "NSString*">
  <#elseif attr.type.collection>
    <#assign fakeAttr = {"type": attr.type.componentType}>
    <#return "NSMutableArray<" + type_attribute(fakeAttr) + ">*">
  <#elseif attr.type.name == "string">
    <#return "NSString*">  
  </#if>
  <#return "NSObject*">
</#function>

<#function type_attribute_primitive attr>
  <#if attr.type.custom>
    <#return "NSInteger">
  <#elseif attr.constraint.domainType.name == "id">
    <#return "NSInteger">    
  <#elseif attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">
    <#return "NSInteger">   
  <#elseif attr.type.name == "number" || attr.type.name == "decimal">
    <#return "NSDecimalNumber*">      
  <#elseif attr.name == "state">
    <#return "BOOL">   
  <#elseif attr.type.name == "bool">
    <#return "BOOL">          
  <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
    <#return "NSDate*">  
  <#elseif attr.type.name == "json">
    <#return "NSString*">
  <#elseif attr.type.collection>
    <#assign fakeAttr = {"type": attr.type.componentType}>
    <#return "NSMutableArray<" + type_attribute(fakeAttr) + ">*">
  <#elseif attr.type.name == "string">
    <#return "NSString*">  
  </#if>
  <#return "NSObject*">
</#function>

<#function type_object obj>
  <#return (namespace!"") + objc.nameType(obj.name)>
</#function>

<#function type_application app>
  <#return (namespace!"") + objc.nameType(app.name)>
</#function>

<#function name_attribute_as_primitive_plural attr>
  <#return objc.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#function name_attribute_as_primitive attr>
  <#return objc.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>