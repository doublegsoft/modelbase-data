<#import '/$/modelbase.ftl' as modelbase>

<#function get_redefined_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.isLabelled("redefined")>
      <#local ret += [attr]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function convert_guidbase_mini_to_attributes widget obj opt>
  <#local type = "">
  <#if widget.typename??>
    <#local type = widget.typename>
  <#else>
    <#local type = widget.type()>
  </#if>
  <#local ret = "(">
  <#if widget.attr??>
    <#if widget.attr("title")??>
      <#local ret += "title:\"" + widget.attr("title") + "\"">
    <#else>  
      <#local ret += "title:\"" + modelbase.get_object_label(obj) + "\"">
    </#if>
    <#if widget.attr("width")??>
      <#if ret != "("><#local ret += ", "></#if>
      <#local ret += "width:\"" + widget.attr("width") + "\"">
    </#if>
    <#if widget.attr("count")??>
      <#if ret != "("><#local ret += ", "></#if>
      <#local ret += "count:\"" + widget.attr("count") + "\"">
    </#if>
    <#list widget.attrs() as attr>
      <#if attr.name() == "url">
        <#if ret != "("><#local ret += ", "></#if>
        <#local url = attr.value()>
        <#local ret += "url:\"" + url[0] + app.name + "/" + modelbase.get_object_module(obj) + "/" + obj.name + "/" + url?substring(1) + "\"">
      </#if>
      <#if widget.id()?? && widget.id() == "button_edit">
        <#if ret != "("><#local ret += ", "></#if>
        <#local ret += "title:\"编辑\"">
      </#if>
    </#list>
  </#if>
  <#if type == "readonly_form" || type == "editable_form">
    <#if ret != "("><#local ret += ", "></#if>
    <#local ret += "title:\"" + modelbase.get_object_label(obj) + "\"">
    <#if obj.isLabelled("pivot")>
      <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
      <#local detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
      <#local detailKeyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["key"])>
      <#local detailValueAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["value"])>
      <#local detailPlural = modelbase.get_object_plural(detailObj)>
      <#local idAttrs = modelbase.get_id_attributes(masterObj)>
      <#local ret += ", object:\"" + modelbase.get_object_module(masterObj) + "/" + masterObj.name + "\"">
      <#local ret += ", pivot:\"" + modelbase.get_object_module(detailObj) + "/" + detailObj.name + "\"">
      <#local ret += ", pivotkey:\"" + detailKeyAttr.name + "\"">
      <#local ret += ", pivotval:\"" + detailValueAttr.name + "\"">
    <#elseif obj.isLabelled("meta")>  
       <#local masterObj = model.findObjectByName(obj.name)>
       <#local ret += ", object:\"" + modelbase.get_object_module(masterObj) + "/" + masterObj.name + "\"">
       <#local ret += ", meta:\"" + modelbase.get_object_module(masterObj) + "/" + masterObj.name + "_meta\"">
    </#if>
  </#if>
  <#if type == "list_view">
    <#if ret != "("><#local ret += ", "></#if>
    <#local ret += "url:\"/api/v3/common/script/stdbiz/" + modelbase4guidbase.get_object_data_path(obj) + "/paginate\"">
    <#if opt["more"]??>
      <#if ret != "("><#local ret += ", "></#if>
      <#local ret += "more:\"" + modelbase4guidbase.get_object_data_path(obj) + "/list\"">
    </#if>
  </#if>
  <#if type == "pagination_table">
    <#if ret != "("><#local ret += ", "></#if>
    <#local ret += "url:\"/api/v3/common/script/stdbiz/" + modelbase4guidbase.get_object_data_path(obj) + "/paginate\"">
    <#if opt["more"]??>
      <#if ret != "("><#local ret += ", "></#if>
      <#local ret += "more:\"" + modelbase4guidbase.get_object_data_path(obj) + "/list\"">
    </#if>
  </#if>
  <#if type == "tile">
    <#if ret != "("><#local ret += ", "></#if>
    <#local ret += "object:\"" + obj.name + "\"">
  </#if>
  <#local ret += ")">
  <#if ret == "()">
    <#return "">
  </#if>
  <#return ret>
</#function>

<#--  
 ###############################################################################
 ### UNIVERSAL
 ###############################################################################
 -->

<#macro print_universal_editable_form obj indent>
  <#local widget = {"typename":"editable_form"}>
  <#local attrs = modelbase4guidbase.get_attributes_to_edit(obj)>
${""?left_pad(indent)}form_${obj.name}:editable_form${convert_guidbase_mini_to_attributes(widget,obj,{})}${r"<"}
  <#list attrs as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
    <#if masterIdAttr?? && modelbase.get_attribute_sql_name(masterIdAttr) == modelbase.get_attribute_sql_name(attr)>
${""?left_pad(indent)}    parameter:"&${modelbase.get_attribute_sql_name(masterIdAttr)}",  
    <#elseif masterIdAttr?? && attr.constraint.identifiable>
${""?left_pad(indent)}    parameter:"=${modelbase.get_attribute_sql_name(masterIdAttr)}",  
    </#if>
    <#if attr.constraint.domainType?string?starts_with("enum")>
${""?left_pad(indent)}    values:"${attr.constraint.domainType?string?substring(4)}",
    </#if>
${""?left_pad(indent)}    object:"${attr.parent.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  )<#if attr?index != (attrs?size - 1) || modelbase4guidbase.exist_object_meta(obj)>,</#if>  
  </#list>
${""?left_pad(indent)}>
</#macro>

<#macro print_universal_readonly_form obj indent>
  <#local widget = {"typename":"readonly_form"}>
  <#local attrs = modelbase4guidbase.get_attributes_to_edit(obj)>
${""?left_pad(indent)}form_${obj.name}:readonly_form${convert_guidbase_mini_to_attributes(widget,obj,{})}${r"<"}
  <#list attrs as attr>
    <#if attr.type.custom>
      <#local refObj = model.findObjectByName(attr.type.name)>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:hidden(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  ),  
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)?replace("_code", "_name")?replace("_id", "_name")}:text(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    object:"${refObj.name}",
${""?left_pad(indent)}    attribute:"${attr.name?replace("_code", "_name")?replace("_id", "_name")}"
${""?left_pad(indent)}  ),
    <#else>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  )<#if attr?index != (attrs?size - 1)>,</#if>    
    </#if>
  </#list>
${""?left_pad(indent)}>
</#macro>

<#macro print_universal_list_view widget obj indent opt={}>
  <#local widget = widget + {"typename":"list_view"}>
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
    <#local idAttrs = modelbase.get_id_attributes(masterObj)>
  <#else>
    <#local idAttrs = modelbase.get_id_attributes(obj)>
  </#if>
  <#local levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj)>
  <#local attrs = modelbase4guidbase.sort_levelled_attributes(levelledAttrs)>
${""?left_pad(indent)}list_${obj.name}:list_view${convert_guidbase_mini_to_attributes(widget,obj,opt)}${r"<"}
  <#list attrs as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  ),
  </#list>
${""?left_pad(indent)}  buttons(title:"操作")${r"<"}
${""?left_pad(indent)}    button_edit:button(title:"编辑", url:"%${namespace}/${modelbase4guidbase.get_object_data_path(obj)}/edit?${modelbase4guidbase.attributes_as_url_params(idAttrs)}", note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面"),
${""?left_pad(indent)}    button_delete:button(title:"删除", url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_data_path(obj)}/delete?${modelbase4guidbase.attributes_as_url_params(idAttrs)}", note:"调用【${modelbase.get_object_label(obj)}】删除接口")
${""?left_pad(indent)}  >
${""?left_pad(indent)}>
</#macro>

<#macro print_universal_grid_view obj indent>
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local idAttrs = modelbase.get_id_attributes(masterObj)>
  <#else>
    <#local idAttrs = modelbase.get_id_attributes(obj)>
  </#if>
  <#local levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj)>
  <#local attrs = modelbase4guidbase.sort_levelled_attributes(levelledAttrs)>
${""?left_pad(indent)}grid_${obj.name}:grid_view(url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_data_path(obj)}/paginate", title:"${modelbase.get_object_label(obj)}")${r"<"}
  <#list modelbase4guidbase.sort_levelled_attributes(levelledAttrs) as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  )<#if attr?index != levelledAttrs?size - 1>,</#if>  
${""?left_pad(indent)}>
  </#list>
</#macro>

<#macro print_universal_list_navigator widget obj indent>
${""?left_pad(indent)}list_${obj.name}:list_navigator${guidbase.convert_guidbase_mini_to_attributes(widget,obj,{})}${r"<"}
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local idAttrs = modelbase.get_id_attributes(masterObj)>
  <#else>
    <#local idAttrs = modelbase.get_id_attributes(obj)>
    <#local masterObj = obj>
  </#if>
  <#list obj.attributes as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
  <#if obj.isLabelled("pivot")>
${""?left_pad(indent)}    category:"${obj.name}",
${""?left_pad(indent)}    name:"${attr.name}",
${""?left_pad(indent)}    object:"${masterObj.name}",
${""?left_pad(indent)}    attribute:"component_code"
  <#else>
${""?left_pad(indent)}    object:"${masterObj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"  
  </#if>
${""?left_pad(indent)}  )<#if attr?index != obj.attributes?size - 1>,</#if>  
  </#list>
${""?left_pad(indent)}>  
</#macro>

<#--  
 ###############################################################################
 ### DESKTOP
 ###############################################################################
 -->
<#macro print_desktop_pagination_table widget obj indent opt={}>
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local idAttrs = modelbase.get_id_attributes(masterObj)>
  <#else>
    <#local idAttrs = modelbase.get_id_attributes(obj)>
  </#if>
  <#local levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj)>
  <#local attrs = get_redefined_attributes(obj)>
  <#if attrs?size == 0>
    <#local attrs = modelbase4guidbase.sort_levelled_attributes(levelledAttrs)>
  </#if>  
${""?left_pad(indent)}table_${obj.name}:pagination_table${guidbase.convert_guidbase_mini_to_attributes(widget,obj,{})}${r"<"}
  <#list attrs as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  ),
  </#list>
${""?left_pad(indent)}  buttons(title:"操作")${r"<"}
${""?left_pad(indent)}    button_edit:button(title:"编辑", url:"%${namespace}/${modelbase4guidbase.get_object_data_path(obj)}/edit?${modelbase4guidbase.attributes_as_url_params(idAttrs)}", note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面"),
${""?left_pad(indent)}    button_detail:button(title:"详情", url:"%${namespace}/${modelbase4guidbase.get_object_data_path(obj)}/detail?${modelbase4guidbase.attributes_as_url_params(idAttrs)}", note:"跳转到【${modelbase.get_object_label(obj)}】详情页面"),
${""?left_pad(indent)}    button_delete:button(title:"删除", url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_data_path(obj)}/delete?${modelbase4guidbase.attributes_as_url_params(idAttrs)}", note:"调用【${modelbase.get_object_label(obj)}】删除接口")
${""?left_pad(indent)}  >
${""?left_pad(indent)}>
</#macro>

<#macro print_desktop_pagination_grid obj indent>
  <#if obj.isLabelled("pivot")>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local idAttrs = modelbase.get_id_attributes(masterObj)>
  <#else>
    <#local idAttrs = modelbase.get_id_attributes(obj)>
  </#if>
  <#local levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj)>
  <#local attrs = modelbase4guidbase.sort_levelled_attributes(levelledAttrs)>
${""?left_pad(indent)}grid_${obj.name}:pagination_grid(url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_data_path(obj)}/paginate", title:"${modelbase.get_object_label(obj)}")${r"<"}
  <#list modelbase4guidbase.sort_levelled_attributes(levelledAttrs) as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  )<#if attr?index != levelledAttrs?size - 1>,</#if>  
${""?left_pad(indent)}>
  </#list>
</#macro> 