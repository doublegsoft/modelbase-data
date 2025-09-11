<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4guidbase.ftl' as modelbase4guidbase>
<#import '/$/guidbase.ftl' as guidbase>
<#function get_text_by_page page>
  <#local trimmedPage = page?trim>
  <#if trimmedPage == "list">
    <#return "列表">     
  <#elseif trimmedPage == "edit">
    <#return "编辑">  
  <#elseif trimmedPage == "coll">
    <#return "集合">
  <#elseif trimmedPage == "detail">
    <#return "详情">    
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
  </#if>
  <#return page>
</#function>
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#if !obj.isLabelled("page") || !obj.getLabelledOptions("page")["mobile"]??><#continue></#if>
  <#assign pages = obj.getLabelledOptions("page")["mobile"]?split(",")>
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
** 【${modelbase.get_object_label(obj)}】${get_text_by_page(pagename)}页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/${pagename}:page(title:"${modelbase.get_object_label(obj)}${get_text_by_page(pagename)}")${r"<"}
    <#if trimmedPage == "edit">  
<@guidbase.print_universal_editable_form obj=obj indent=2 />
    <#elseif trimmedPage == "list">
  search_${obj.name}:search_bar(object:"${obj.name}"),    
<@guidbase.print_universal_list_view widget={} obj=obj indent=2 />      
    <#elseif trimmedPage == "coll">
  search_${obj.name}:search_bar(object:"${obj.name}"),    
<@guidbase.print_universal_grid_view obj=obj indent=2 />       
    <#elseif trimmedPage == "detail">
<@guidbase.print_universal_readonly_form obj=obj indent=2 />, 
  tabs_category:tabs(swipeable:"false")<
  >	
    <#else><#-- 以下逻辑是用GuidbaseMini来处理自定义布局 -->
      <#assign pageContainer = guidbase_mini.from(page)>
      <#list pageContainer.children() as widget>
        <#if widget.id()??>
  ${widget.id()}:${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget,obj,{})}<#if widget?index != pageContainer.children()?size - 1>,</#if>
        <#elseif widget.type() == "swiper_navigator">
          <#assign obj4SwiperNavigator = obj>
          <#if widget.attr("object")??>
            <#assign obj4SwiperNavigator = model.findObjectByName(widget.attr("object"))>
          </#if>
  swiper_${obj.name}:swiper_navigator(url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_data_path(obj4SwiperNavigator)}/find?")<#if widget?index != pageContainer.children()?size - 1>,</#if>
        <#elseif widget.type() == "list_view">
          <#assign obj4ListView = obj>
          <#if widget.attr("object")??>
            <#assign obj4ListView = model.findObjectByName(widget.attr("object"))>
          </#if>
<@guidbase.print_universal_list_view widget=widget obj=obj4ListView indent=2 opt={"more":true} /><#if widget?index != pageContainer.children()?size - 1>,</#if>
        <#elseif widget.type() == "calendar">
  calendar_${obj.name}:${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget,obj,{})}${r"<"}   
  ><#if widget?index != pageContainer.children()?size - 1>,</#if>
        <#elseif widget.type() == "tile">
          <#assign obj4Tile = obj>
          <#assign levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj4Tile)>
          <#assign attrs = modelbase4guidbase.sort_levelled_attributes(levelledAttrs)>
  ${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget,obj4Tile,{})}${r"<"}
          <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != attrs?size - 1>,</#if>
          </#list>
  ><#if widget?index != pageContainer.children()?size - 1>,</#if>        
        <#else>
  ${widget.type()}${guidbase.convert_guidbase_mini_to_attributes(widget, obj,{})}${r"<"} 
  ><#if widget?index != pageContainer.children()?size - 1>,</#if>
        </#if>
      </#list>
    </#if>
>
  </#list>
</#list> 
