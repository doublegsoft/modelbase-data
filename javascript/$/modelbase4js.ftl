<#function test_unit_value attr> 
  <#if attr.name == 'name'>
    <#return "'" + tatabase.string(4) + "'">
  <#elseif attr.isLabelled("listable") && (attr.getLabelledOptions("listable")["level"]!"") == "image">
    <#return "'" + modelbase.test_image_path() + "'">
  <#elseif attr.constraint.domainType.name == "id">  
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return val>
  <#elseif attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
    <#return test_unit_value(refObjIdAttr)>  
  <#elseif attr.constraint.identifiable && attr.type.name == "string">
    <#assign UUID = statics['java.util.UUID']>
    <#assign id = UUID.randomUUID()?string?upper_case>
    <#return "'" + id + "'">    
  <#elseif attr.type.name?starts_with('enum')>
    <#return "'" + tatabase.enumcode("enum" + widget.options["values"]) + "'">
  <#elseif attr.type.name == "string" && (attr.type.length > 400)>
    <#return "'" + tatabase.value("note") + "'"> 
  <#elseif attr.type.name == "number">  
    <#return tatabase.number(1, 100)>
  <#elseif attr.type.name == "int" || attr.type.name == 'integer'>  
    <#return "parseInt(" + tatabase.number(1, 100) + ")">  
  <#elseif attr.type.name == "date">  
    <#return "'" + tatabase.datetime() + "'">
  <#elseif attr.type.name == "datetime">  
    <#return "'" + tatabase.datetime() + "'">  
  <#elseif attr.type.name == "lmt">  
    <#return "'" + tatabase.datetime() + "'">  
  <#else>
    <#return "'" + tatabase.string(8) + "'">
  </#if>
</#function>

<#function get_object_page_path obj>
  <#local module = modelbase.get_object_module(obj)>
  <#if module == "" || module == "unknown">
    <#return obj.name?replace("_", "-")>
  </#if>
  <#return module?replace("_","-") + "/" + obj.name?replace("_", "-")>
</#function>