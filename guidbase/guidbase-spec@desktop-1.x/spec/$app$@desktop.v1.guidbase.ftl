<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4guidbase.ftl' as modelbase4guidbase>
<#import '/$/guidbase.ftl' as guidbase>
<#function get_text_by_name name>
  <#if name?trim == "list">
    <#return "列表">     
  <#elseif name?trim == "edit">
    <#return "编辑">  
  <#elseif name?trim == "coll">
    <#return "集合">
  <#elseif name?trim == "detail">
    <#return "详情">
  <#elseif name?trim == "index">
    <#return "门户">  
  </#if>
  <#return "">
</#function>
<#function get_name_by_page page>
  <#local trimmedPage = page?trim>
  <#if trimmedPage?index_of("list") == 0>
    <#return "list">     
  <#elseif trimmedPage?index_of("edit") == 0>
    <#return "edit">  
  <#elseif trimmedPage?index_of("coll") == 0>
    <#return "coll">
  <#elseif trimmedPage?index_of("detail") == 0>
    <#return "detail">
  <#elseif trimmedPage?index_of("{") != -1>
    <#return trimmedPage?substring(0,trimmedPage?index_of("{"))> 
  </#if>
  <#return page>
</#function>
<#macro print_guidbase_for_container container obj indent>
  <#list container.children() as widget>
    <#if widget.id()??>
${""?left_pad(indent)}${widget.id()}:${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget,obj,{})}<#if widget?index != container.children()?size - 1>,</#if>
    <#elseif widget.type() == "row">
${""?left_pad(indent)}${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget, obj, {})}${r"<"} 
<@print_guidbase_for_container container=widget obj=obj indent=indent+2 />
${""?left_pad(indent)}><#if widget?index != container.children()?size - 1>,</#if> 
    <#elseif widget.type() == "col">
${""?left_pad(indent)}${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget, obj, {})}${r"<"} 
<@print_guidbase_for_container container=widget obj=obj indent=indent+2 />
${""?left_pad(indent)}><#if widget?index != container.children()?size - 1>,</#if>        
    <#elseif widget.type() == "swiper_navigator">
      <#assign obj4SwiperNavigator = obj>
      <#if widget.attr("object")??>
        <#assign obj4SwiperNavigator = model.findObjectByName(widget.attr("object"))>
      </#if>
${""?left_pad(indent)}swiper_${obj.name}:swiper_navigator(url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_data_path(obj4SwiperNavigator)}/find?")<#if widget?index != container.children()?size - 1>,</#if>
    <#elseif widget.type() == "list_view">
      <#assign obj4ListView = obj>
      <#if widget.attr("object")??>
        <#assign obj4ListView = model.findObjectByName(widget.attr("object"))>
      </#if>
<@guidbase.print_universal_list_view widget=widget obj=obj4ListView indent=indent opt={"more":true} /><#if widget?index != container.children()?size - 1>,</#if>
    <#elseif widget.type() == "list_navigator">
      <#assign obj4ListNavigator = obj>
      <#if widget.attr("object")??>
        <#assign obj4ListNavigator = model.findObjectByName(widget.attr("object"))>
      </#if>
<@guidbase.print_universal_list_navigator widget=widget obj=obj4ListNavigator indent=indent /><#if widget?index != container.children()?size - 1>,</#if>
    <#elseif widget.type() == "pagination_table">
      <#assign obj4PaginationTable = obj>
      <#if widget.attr("object")??>
        <#assign obj4PaginationTable = model.findObjectByName(widget.attr("object"))>
      </#if>
<@guidbase.print_desktop_pagination_table widget=widget obj=obj4PaginationTable indent=indent /><#if widget?index != container.children()?size - 1>,</#if>      
    <#elseif widget.type() == "calendar">
${""?left_pad(indent)}calendar_${obj.name}:${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget,obj,{})}${r"<"}   
${""?left_pad(indent)}><#if widget?index != container.children()?size - 1>,</#if>
    <#elseif widget.type() == "tile">
      <#assign obj4Tile = obj>
      <#assign levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj4Tile)>
      <#assign attrs = modelbase4guidbase.sort_levelled_attributes(levelledAttrs)>
${""?left_pad(indent)}${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget,obj4Tile,{})}${r"<"}
      <#list attrs as attr>
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
${""?left_pad(indent)}    title:"${modelbase.get_attribute_label(attr)}",
${""?left_pad(indent)}    level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
${""?left_pad(indent)}    object:"${obj.name}",
${""?left_pad(indent)}    attribute:"${attr.name}"
${""?left_pad(indent)}  )<#if attr?index != attrs?size - 1>,</#if>
      </#list>
${""?left_pad(indent)}><#if widget?index != container.children()?size - 1>,</#if>        
    <#else>
${""?left_pad(indent)}${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget, obj,{})}${r"<"} 
${""?left_pad(indent)}><#if widget?index != container.children()?size - 1>,</#if>
    </#if>
  </#list>
</#macro>
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#if !obj.isLabelled("page") || !obj.getLabelledOptions("page")["desktop"]??><#continue></#if>
  <#assign pages = obj.getLabelledOptions("page")["desktop"]?split(",")>
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
    <#assign detailKeyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["key"])>
    <#assign detailValueAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["value"])>
    <#assign detailPlural = modelbase.get_object_plural(detailObj)>
    <#assign idAttrs = modelbase.get_id_attributes(masterObj)>
  </#if>
  <#list pages as page>
    <#assign trimmedPage = page?trim>
    <#assign pagename = get_name_by_page(page)>
    
/*!
** 【${modelbase.get_object_label(obj)}】${get_text_by_name(page)}页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/${pagename}:page(title:"${modelbase.get_object_label(obj)}${get_text_by_name(pagename)}")${r"<"}
    <#if trimmedPage == "edit">  
<@guidbase.print_universal_editable_form obj=obj indent=2 />
    <#elseif trimmedPage == "list">  
  toolbar<
    button_add:button(title:"新增${modelbase.get_object_label(obj)}",
                      url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit", 
                      note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面")
  >,    
<@guidbase.print_desktop_pagination_table widget={"typename":"pagination_table"} obj=obj indent=2 />      
    <#elseif trimmedPage == "coll">  
 toolbar<
    button_add:button(title:"新增${modelbase.get_object_label(obj)}",
                      url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit", 
                      note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面")
  >,   
<@guidbase.print_desktop_pagination_grid obj=obj indent=2 />        
    <#elseif trimmedPage == "detail">
<@guidbase.print_universal_readonly_form obj=obj indent=2 />, 
  tabs_category:tabs<
  >
    <#else><#-- 以下逻辑是用GuidbaseMini来处理自定义布局 -->
      <#assign pageContainer = guidbase_mini.from(page)>
  toolbar<
    button_add:button(title:"新增${modelbase.get_object_label(obj)}",
                      url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit", 
                      note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面")
  >,         
<@print_guidbase_for_container container=pageContainer obj=obj indent=2 />  
    </#if>
>
  </#list>
</#list> 
