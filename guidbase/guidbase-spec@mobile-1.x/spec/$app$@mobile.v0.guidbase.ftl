<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4guidbase.ftl' as modelbase4guidbase>
<#--
 ### 编辑页面
 --->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#assign attrs = modelbase4guidbase.get_attributes_to_edit(obj)>

/*!
** 【${modelbase.get_object_label(obj)}】编辑页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/edit:page(title:"${modelbase.get_object_label(obj)}编辑")<
  form_${obj.name}:editable_form(object:"${obj.name}")<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
    <#if masterIdAttr?? && modelbase.get_attribute_sql_name(masterIdAttr) == modelbase.get_attribute_sql_name(attr)>
      parameter:"&${modelbase.get_attribute_sql_name(masterIdAttr)}",  
    <#elseif masterIdAttr?? && attr.constraint.identifiable>
      parameter:"=${modelbase.get_attribute_sql_name(masterIdAttr)}",  
    </#if>
    <#if attr.constraint.domainType?string?starts_with("enum")>
      values:"${attr.constraint.domainType?string?substring(4)}",
    </#if>
      object:"${attr.parent.name}",
      attribute:"${attr.name}"
    )<#if attr?index != (attrs?size - 1) || modelbase4guidbase.exist_object_meta(obj)>,</#if>  
  </#list>
  <#list model.objects as metaObj>
    <#if (obj.name + "_meta") == metaObj.name>
    placeholder_a:text(
      title:"占位A",
      object:"${metaObj.name}",
      attribute: "content[]"   
    ),
    placeholder_a:text(
      title:"占位B",
      object:"${metaObj.name}",
      attribute:"content[]"   
    ),
    placeholder_a:text(
      title:"占位C",
      object:"${metaObj.name}",
      attribute:"content[]"   
    )
    </#if>
  </#list>
  >  
>
</#list>
<#--
 ### 集合页面
 --->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#assign levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj)>
  
/*!
** 【${modelbase.get_object_label(obj)}】集合页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/list:page(title:"${modelbase.get_object_label(obj)}列表")<
  search_${obj.name}:search_bar(object:"${obj.name}"),
  list_${obj.name}:list_view(url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_page_path(obj)}/paginate", title:"${modelbase.get_object_label(obj)}")<
  <#list modelbase4guidbase.sort_levelled_attributes(levelledAttrs) as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    ),
  </#list>
    buttons(title:"操作")<
      edit:button(title:"编辑", url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit?${modelbase4guidbase.attributes_as_url_params(attrIds)}", note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面"),
      delete:button(title:"删除", url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_page_path(obj)}/delete?${modelbase4guidbase.attributes_as_url_params(attrIds)}", note:"调用【${modelbase.get_object_label(obj)}】删除接口")
    >
  >  
>

${modelbase4guidbase.get_object_page_path(obj)}/coll:page(title:"${modelbase.get_object_label(obj)}集合")<
  search_${obj.name}:search_bar(object:"${obj.name}"),
  grid_${obj.name}:grid_view(url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_page_path(obj)}/paginate", title:"${modelbase.get_object_label(obj)}")<
  <#list modelbase4guidbase.sort_levelled_attributes(levelledAttrs) as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != levelledAttrs?size - 1>,</#if>  
  </#list>
  >  
>
</#list> 
<#--
 ### 详情页面
 --->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#assign attrs = modelbase4guidbase.get_attributes_to_edit(obj)>
  <#assign objsRefObj = modelbase4guidbase.get_objects_referencing(obj)>
  
/*!
** 【${modelbase.get_object_label(obj)}】详情页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/detail:page(title:"${modelbase.get_object_label(obj)}详情")<
  form_${obj.name}:readonly_form(object:"${obj.name}")<
  <#list attrs as attr>
    <#if attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
    ${modelbase.get_attribute_sql_plain_name(attr)}:hidden(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    ),  
    ${modelbase.get_attribute_sql_plain_name(attr)?replace("_code", "_name")?replace("_id", "_name")}:text(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${refObj.name}",
      attribute:"${attr.name?replace("_code", "_name")?replace("_id", "_name")}"
    ),
    <#else>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    ),  
    </#if>
  </#list>
    placeholder:hidden(
      title:"占位",
      object:"占位",
      attribute:"占位"
    )
  >, 
  tabs_category:tabs<
  <#list objsRefObj as objRefObj>
    tab_${objRefObj.name}:tab(
      title:"${modelbase.get_object_label(objRefObj)}"
    )<#if objRefObj?index != objsRefObj?size - 1>,</#if>
  </#list>  
  >
>

  <#assign levelledAttrs = modelbase4guidbase.level_attributes_to_list(obj)>
/*!
** 【${modelbase.get_object_label(obj)}】档案页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/profile:page(title:"${modelbase.get_object_label(obj)}档案")<
  base_info:tile(object:"${obj.name}")<
  <#list modelbase4guidbase.sort_levelled_attributes(levelledAttrs) as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != levelledAttrs?size - 1>,</#if>  
  </#list>
  >,
  navs_category:list_navigator<
  <#list objsRefObj as objRefObj>
    nav_${objRefObj.name}:navigator(
      title:"${modelbase.get_object_label(objRefObj)}",
      url:"@${modelbase4guidbase.get_object_page_path(objRefObj)}/detail"
    )<#if objRefObj?index != objsRefObj?size - 1>,</#if>
  </#list>  
  >
>

/*!
** 【${modelbase.get_object_label(obj)}】概览页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/overview:page(title:"${modelbase.get_object_label(obj)}概览")<
  base_info:tile(object:"${obj.name}")<
  <#list modelbase4guidbase.sort_levelled_attributes(levelledAttrs) as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      level:"${modelbase4guidbase.get_attribute_level(attr, levelledAttrs)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != levelledAttrs?size - 1>,</#if>  
  </#list>
  >,
  <#list objsRefObj as objRefObj>
  section_${objRefObj.name}:tile(
    title:"${modelbase.get_object_label(objRefObj)}"
  )<
    count:text(title:"占位")
  ><#if objRefObj?index != objsRefObj?size - 1>,</#if>
  </#list>  
>

/*!
** 【${modelbase.get_object_label(obj)}】指标页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/metric:page(title:"${modelbase.get_object_label(obj)}指标")<
  pie_${obj.name}:pie_chart(
    title:"${modelbase.get_object_label(obj)}"
  ),
  bar_${obj.name}:bar_chart(
    title:"${modelbase.get_object_label(obj)}"
  ),
  line_${obj.name}:line_chart(
    title:"${modelbase.get_object_label(obj)}"
  ),
  gauge_${obj.name}:gauge_chart(
    title:"${modelbase.get_object_label(obj)}"
  )
>
</#list>
 