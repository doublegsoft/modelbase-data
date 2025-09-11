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
${modelbase4guidbase.get_object_page_path(obj)}/edit:page(title:"${modelbase.get_object_label(obj)}编辑",style:"sidebar")<
  form_${obj.name}:editable_form<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
    <#if masterIdAttr?? && modelbase.get_attribute_sql_name(masterIdAttr) == modelbase.get_attribute_sql_name(attr)>
      parameter:"&${modelbase.get_attribute_sql_name(masterIdAttr)}",  
    <#elseif masterIdAttr?? && attr.constraint.identifiable>
      parameter:"=${modelbase.get_attribute_sql_name(masterIdAttr)}",  
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
** 【${modelbase.get_object_label(obj)}】列表页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/list:page(title:"${modelbase.get_object_label(obj)}列表",style:"view")<
  toolbar<
    button_add:button(title:"新增${modelbase.get_object_label(obj)}",
                      url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit", 
                      note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面")
  >,
  table_${obj.name}:pagination_table<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
    <#if attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      object:"${refObj.name}",
      attribute:"${refObj.name}_name"
    <#else>
      object:"${obj.name}",
      attribute:"${attr.name}"
    </#if>  
    ),
  </#list>
    buttons(title:"操作", align:"center")<
      button_edit:button(title:"编辑", url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit?${modelbase4guidbase.attributes_as_url_params(attrIds)}", 
                         note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面"),
      button_detail:button(title:"详情", url:"#${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/detail?${modelbase4guidbase.attributes_as_url_params(attrIds)}", 
                           note:"跳转到【${modelbase.get_object_label(obj)}】详情页面"),
      button_delete:button(title:"删除", url:"/api/v3/common/script/stdbiz/${modelbase4guidbase.get_object_page_path(obj)}/delete?${modelbase4guidbase.attributes_as_url_params(attrIds)}", 
                           note:"调用【${modelbase.get_object_label(obj)}】删除接口")
    >
  >  
>

/*!
** 【${modelbase.get_object_label(obj)}】栅格页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/coll:page(title:"${modelbase.get_object_label(obj)}集合",style:"view")<
  toolbar<
    button_add:button(title:"新增${modelbase.get_object_label(obj)}",
                      url:"%${namespace}/${modelbase4guidbase.get_object_page_path(obj)}/edit", 
                      note:"跳转到【${modelbase.get_object_label(obj)}】编辑页面")
  >,
  grid_${obj.name}:pagination_grid<
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
${modelbase4guidbase.get_object_page_path(obj)}/detail:page(title:"${modelbase.get_object_label(obj)}详情",style:"overlay")<
  form_${obj.name}:readonly_form<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != attrs?size - 1>,</#if>  
  </#list>
  >, 
  tabs_category:tabs<
  <#list objsRefObj as objRefObj>
    tab_${objRefObj.name}:tab(
      title:"${modelbase.get_object_label(objRefObj)}"
    )<#if objRefObj?index != objsRefObj?size - 1>,</#if>
  </#list>  
  >
>
</#list> 
<#--
 ### 多选页面（提供给其他页面使用）
 --->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('entity')>
    <#assign attrs = []>
    <#list obj.attributes as attr>
      <#if modelbase.is_attribute_system(attr)><#continue></#if>
      <#if attr.type.name == 'json'><#continue></#if>
      <#assign attrs = attrs + [attr]>
    </#list>
    
/*!
** 【${modelbase.get_object_label(obj)}】多选页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/select:page(title:"${modelbase.get_object_label(obj)}多选页面",style:"sidebar")<
  form_${obj.name}:readonly_form<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != attrs?size - 1>,</#if>  
  </#list>
  >  
>
  </#if>
</#list> 
<#--
 ### 基本信息页面（提供给其他页面使用）
 --->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('entity')>
    <#assign attrs = []>
    <#list obj.attributes as attr>
      <#if modelbase.is_attribute_system(attr)><#continue></#if>
      <#if attr.type.name == 'json'><#continue></#if>
      <#assign attrs = attrs + [attr]>
    </#list>
    
/*!
** 【${modelbase.get_object_label(obj)}】基本信息页面。
*/
${modelbase4guidbase.get_object_page_path(obj)}/detail/base:page(title:"${modelbase.get_object_label(obj)}基本信息", style:"view")<
  form_${obj.name}:readonly_form<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != attrs?size - 1>,</#if>  
  </#list>
  >  
>
  </#if>
</#list> 
<#--
 ### 集合页面（提供给其他页面使用）
 --->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('entity')>
    <#assign attrs = []>
    <#list obj.attributes as attr>
      <#if modelbase.is_attribute_system(attr)><#continue></#if>
      <#if attr.type.name == 'json'><#continue></#if>
      <#assign attrs = attrs + [attr]>
    </#list>
    
/*!
** 【${modelbase.get_object_label(obj)}】概览列表。
*/
${modelbase4guidbase.get_object_page_path(obj)}/detail/list:page(title:"${modelbase.get_object_label(obj)}概览列表", style:"view")<
  form_${obj.name}:readonly_form<
  <#list attrs as attr>
    ${modelbase.get_attribute_sql_plain_name(attr)}:${modelbase4guidbase.get_attribute_input(attr)}(
      title:"${modelbase.get_attribute_label(attr)}",
      object:"${obj.name}",
      attribute:"${attr.name}"
    )<#if attr?index != attrs?size - 1>,</#if>  
  </#list>
  >  
>
  </#if>
</#list> 
 