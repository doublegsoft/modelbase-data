
<#function get_object_page_path obj>
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local module = modelbase.get_object_module(masterObj)>
    <#if module == "" || module == "UNKNOWN">
      <#return obj.name>
    </#if>
    <#return module + "/" + obj.name>
  </#if>
  <#local module = modelbase.get_object_module(obj)>
  <#if module == "" || module == "UNKNOWN">
    <#return obj.name>
  </#if>
  <#return module + "/" + obj.name>
</#function>

<#function get_object_data_path obj>
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local module = modelbase.get_object_module(masterObj)>
    <#if module == "">
      <#return masterObj.name>
    </#if>
    <#if module == "aux">
      <#local module = "aux2">
    </#if>
    <#return module + "/" + masterObj.name>
  </#if>
  <#local module = modelbase.get_object_module(obj)>
  <#if module == "aux">
    <#local module = "aux2">
  </#if>
  <#if module == "">
    <#return obj.name>
  </#if>
  <#return module + "/" + obj.name>
</#function>

<#function ignore_attribute_to_edit attr attrs>
  <#if modelbase.is_attribute_system(attr)><#return true></#if>
  <#if attr.type.componentType??><#return true></#if>
  <#if attr.type.name == "json"><#return true></#if>
  <#list attrs as existingAttr>
    <#if modelbase.get_attribute_sql_name(attr) == modelbase.get_attribute_sql_name(existingAttr)>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function get_attributes_to_edit obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if ignore_attribute_to_edit(attr, ret)><#continue></#if>
    <#local ret = ret + [attr]>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#list refObj.attributes as refObjAttr>
        <#if modelbase.is_attribute_system(refObjAttr)><#continue></#if>
        <#if refObjAttr.type.componentType??><#continue></#if>
        <#if refObjAttr.type.name == 'json'><#continue></#if>
        <#local ret = ret + [refObjAttr]>
      </#list>
    </#if>
    <#-- 如果存在一对一对象，则需要选出一个主要标识 -->
    <#if !masterIdAttr?? && attr.constraint.identifiable>
      <#assign masterIdAttr = attr>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_attribute_input attr>
  <#if attr.derivative?? && attr.derivative == true>
    <#return "text">
  </#if>
  <#local typename = attr.type.name>
  <#if attr.name == "mobile" || typename == "mobile">
    <#return "mobile">
  <#elseif attr.name == "email" || typename == "email">
    <#return "email">  
  <#elseif attr.name == "thumbnail">
    <#return "image">    
  <#elseif typename == "datetime" || typename == "date">
    <#return "date">
  <#elseif typename == "number">  
    <#return "number">  
  <#elseif attr.constraint.identifiable || typename == "id" || typename == "uuid">
    <#return "hidden">
  <#elseif attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
    <#return "select">  
  <#elseif attr.name == "status">  
    <#return "select">
  <#elseif attr.type.custom>  
    <#return "select">  
  <#elseif attr.type.name == "string" && (attr.type.length > 200)>  
    <#return "longtext">    
  </#if>  
  <#return "text">  
</#function>

<#function exist_object_meta obj>
  <#list model.objects as o>
    <#if (obj.name + "_meta") == o.name>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function attributes_as_url_params attrs>
  <#local ret = "">
  <#list attrs as attr>
    <#if attr?index != 0>
      <#local ret = ret + "&">
    </#if>
    <#local ret = ret + modelbase.get_attribute_sql_name(attr)>
  </#list>
  <#return ret>
</#function>

<#--
 ### 获得在模型中引用了指定对象的所有对象。
 -->
<#function get_objects_referencing obj>
  <#local ret = []>
  <#local existings = {}>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#if idAttrs?size != 1><#return ret></#if>
  <#local idAttr = idAttrs[0]>
  <#if idAttr.type.custom>
    <#local idObj = model.findObjectByName(idAttr.type.name)>
    <#local objsRefObj = get_objects_referencing(idObj)>
    <#local ret = ret + objsRefObj>
  </#if>
  <#list model.objects as otherObj>
    <#list otherObj.attributes as attr>
      <#if !attr.type.custom><#continue></#if>
      <#if attr.constraint.identifiable><#continue></#if>
      <#if attr.type.name == obj.name && !existings[otherObj.name]??>
        <#local ret = ret + [otherObj]>
        <#local existings = existings + {otherObj.name: otherObj}>
      </#if>
    </#list>
  </#list>
  <#return ret>
</#function>

<#--
 ### 给属性标记信息等级。
 ###
 ### @param attr
 ###        待标记等级的属性
 ###
 ### @param levelledAttrs
 ###        已经标记了等级的属性
 -->
<#function level_attribute obj attr levelledAttrs>
  <#-- 已经定义过了 -->
  <#if attr.isLabelled("primary")>
    <#return "primary">
  </#if>
  <#if attr.isLabelled("secondary")>
    <#return "secondary">
  </#if>
  <#if attr.isLabelled("tertiary")>
    <#return "tertiary">
  </#if>
  <#if attr.isLabelled("quaternary")>
    <#return "quaternary">
  </#if>
  <#if attr.isLabelled("quinary")>
    <#return "quinary">
  </#if>
  <#if attr.isLabelled("senary")>
    <#return "senary">
  </#if>
  <#if attr.isLabelled("septenary")>
    <#return "septenary">
  </#if>
  <#if attr.isLabelled("octonary")>
    <#return "octonary">
  </#if>
  <#if attr.isLabelled("nonary")>
    <#return "nonary">
  </#if>
  <#if attr.isLabelled("image")>
    <#return "image">
  </#if>
  <#if attr.isLabelled("avatar")>
    <#return "avatar">
  </#if>
  <#if attr.isLabelled("accent")>
    <#return "accent">
  </#if>
  <#-- 名称 -->
  <#if attr.name?ends_with("name")>
    <#return level_attribute_internal("primary", levelledAttrs)>
  </#if>
  <#-- 直接引用对象 -->
  <#if attr.type.custom && !attr.constraint.identifiable>
    <#return level_attribute_internal("secondary", levelledAttrs)>
  </#if>
  <#-- 日期 -->
  <#if attr.type.name == "date" || attr.type.name == "datetime">
    <#return level_attribute_internal("tertiary", levelledAttrs)>
  </#if>
  <#-- 数字 -->
  <#if attr.type.name == "number">
    <#return level_attribute_internal("quinary", levelledAttrs)>
  </#if>
  <#-- 数值 -->
  <#if attr.type.name == "int" || attr.type.name == "integer">
    <#return level_attribute_internal("senary", levelledAttrs)>
  </#if>
  <#-- 间接引用对象 -->
  <#if modelbase.is_attribute_reference_id(attr, obj)>
    <#return level_attribute_internal("secondary", levelledAttrs)>
  </#if>
  <#-- 头像 -->
  <#if attr.name?ends_with("avatar") || attr.type.name == "avatar">
    <#return "avatar">
  </#if>
  <#-- 图片 -->
  <#if attr.name?ends_with("thumbnail") || attr.name?ends_with("poster")>
    <#return "image">
  </#if>
  <#-- 业务状态、价格 -->
  <#if attr.name == "status" || attr.name == "price">
    <#return "accent">
  </#if>
  <#return "unknown">
</#function>

<#function level_attributes_to_list obj>
  <#local ret = {}>
  <#list obj.attributes as attr>
    <#if ignore_attribute_to_edit(attr, ret?values)><#continue></#if>
    <#local level = level_attribute(obj, attr, ret)>
    <#if level != "unknown">
      <#local ret = ret + {level: attr}>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function sort_levelled_attributes levelledAttrs>
  <#local ret = []>
  <#if levelledAttrs["image"]??>
    <#local ret = ret + [levelledAttrs["image"]]>
  </#if>
  <#if levelledAttrs["avatar"]??>
    <#local ret = ret + [levelledAttrs["avatar"]]>
  </#if>
  <#if levelledAttrs["accent"]??>
    <#local ret = ret + [levelledAttrs["accent"]]>
  </#if>
  <#if levelledAttrs["primary"]??>
    <#local ret = ret + [levelledAttrs["primary"]]>
  </#if>
  <#if levelledAttrs["secondary"]??>
    <#local ret = ret + [levelledAttrs["secondary"]]>
  </#if>
  <#if levelledAttrs["tertiary"]??>
    <#local ret = ret + [levelledAttrs["tertiary"]]>
  </#if>
  <#if levelledAttrs["quaternary"]??>
    <#local ret = ret + [levelledAttrs["quaternary"]]>
  </#if>
  <#if levelledAttrs["quinary"]??>
    <#local ret = ret + [levelledAttrs["quinary"]]>
  </#if>
  <#if levelledAttrs["senary"]??>
    <#local ret = ret + [levelledAttrs["senary"]]>
  </#if>
  <#if levelledAttrs["septenary"]??>
    <#local ret = ret + [levelledAttrs["septenary"]]>
  </#if>
  <#if levelledAttrs["octonary"]??>
    <#local ret = ret + [levelledAttrs["octonary"]]>
  </#if>
  <#if levelledAttrs["nonary"]??>
    <#local ret = ret + [levelledAttrs["nonary"]]>
  </#if>
  <#if levelledAttrs["denary"]??>
    <#local ret = ret + [levelledAttrs["denary"]]>
  </#if>
  <#return ret>
</#function>

<#function level_attribute_internal level levelledAttrs>
  <#if !levelledAttrs[level]??>
    <#return level>
  </#if>
  <#if level == "primary">
    <#return level_attribute_internal("secondary", levelledAttrs)>
  <#elseif level == "secondary">  
    <#return level_attribute_internal("tertiary", levelledAttrs)>
  <#elseif level == "tertiary">  
    <#return level_attribute_internal("quaternary", levelledAttrs)>
  <#elseif level == "quaternary">  
    <#return level_attribute_internal("quinary", levelledAttrs)>
  <#elseif level == "quinary">  
    <#return level_attribute_internal("senary", levelledAttrs)>
  <#elseif level == "senary">  
    <#return level_attribute_internal("septenary", levelledAttrs)>
  <#elseif level == "septenary">  
    <#return level_attribute_internal("octonary", levelledAttrs)>
  <#elseif level == "octonary">  
    <#return level_attribute_internal("nonary", levelledAttrs)>
  <#elseif level == "nonary">  
    <#return level_attribute_internal("denary", levelledAttrs)>
  </#if>
  <#return "unknown">
</#function>

<#function get_attribute_level attr levelledAttrs>
  <#list levelledAttrs as level,levelledAttr>
    <#if levelledAttr.name == attr.name>
      <#return level>
    </#if>
  </#list>
  <#return "unknown">
</#function>