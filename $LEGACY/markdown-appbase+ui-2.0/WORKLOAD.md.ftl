<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
# ${app.name?upper_case}

## 桌面应用

<#assign indexObj = 1>
<#list model.objects as obj>
  <#if !obj.isLabelled('desktop') || obj.isLabelled('generated')><#continue></#if>
  <#assign alias = obj.getLabelledOptions('desktop')['alias']!obj.name>
  <#assign title = obj.getLabelledOptions('desktop')['title']!alias>
  <#assign entity = model.findObjectByName(obj.getLabelledOptions('desktop')['entity'])!''>
  <#if entity != ''>
    <#assign attrIds = modelbase.get_id_attributes(entity)>
  <#else>
    <#assign attrIds = []>
  </#if>
  <#assign indexAttr = 1>
### ${indexObj} ${title?upper_case}

  <#list obj.attributes as attr>
    <#if attr.isLabelled('outline')>
      <#assign title = attr.getLabelledOptions('outline')['title']>
      <#assign description = attr.getLabelledOptions('view')['note']!('用于在弹出式侧边框中显示“' + title + '”的概览页面。')>
      <#assign invokeMethod = 'sidebar'>
      <#assign containerId = '#page' + js.nameType(alias) + '[TODO]'>
    <#elseif attr.isLabelled('profile')>
      <#assign title = attr.getLabelledOptions('profile')['title']>
      <#assign description = attr.getLabelledOptions('view')['note']!('用于在弹出式侧边框中显示“' + title + '”的概览页面。')>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('editor')>
      <#assign title = attr.getLabelledOptions('editor')['title']>
      <#assign description = attr.getLabelledOptions('view')['note']!('用于在弹出式全屏框中显示“' + title + '”的代码页面。')>
      <#assign invokeMethod = 'shade'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('dialog')>
      <#assign title = attr.getLabelledOptions('dialog')['title']>
      <#assign description = attr.getLabelledOptions('view')['note']!('用于在弹出式对话框中显示“' + title + '”的紧凑页面。')>
      <#assign invokeMethod = 'dialog'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('table')>
      <#assign title = attr.getLabelledOptions('table')['title']>
      <#assign description = attr.getLabelledOptions('table')['note']!('用于在正常位置显示“' + title + '”的表格页面。')>
      <#assign invokeMethod = 'sidebar'>
      <#assign containerId = '#page' + js.nameType(alias) + '[TODO]'>
    <#elseif attr.isLabelled('edit')>
      <#assign title = attr.getLabelledOptions('edit')['title']>
      <#assign description = attr.getLabelledOptions('edit')['note']!('用于在弹出式侧边框中显示“' + title + '”的编辑页面。')>
      <#assign invokeMethod = 'sidebar'>
      <#assign containerId = '#page' + js.nameType(alias) + '[TODO]'>
    <#elseif attr.isLabelled('view')>
      <#assign title = attr.getLabelledOptions('view')['title']>
      <#assign description = attr.getLabelledOptions('view')['note']!('用于在弹出式侧边框中显示“' + title + '”的普通页面。')>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('list')>
      <#assign title = attr.getLabelledOptions('list')['title']>
      <#assign description = attr.getLabelledOptions('list')['note']!('用于在正常位置显示“' + title + '”的普通页面。')>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('graph')>
      <#assign title = attr.getLabelledOptions('graph')['title']>
      <#assign description = attr.getLabelledOptions('graph')['note']!('用于在弹出式全屏显示“' + title + '”的图例页面。')>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('dashboard')>
      <#assign title = attr.getLabelledOptions('dashboard')['title']>
      <#assign description = attr.getLabelledOptions('dashboard')['note']!('用于在正常页面位置显示“' + title + '”的普通页面。')>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    <#elseif attr.isLabelled('detail')>
      <#assign title = attr.getLabelledOptions('detail')['title']>
      <#assign description = attr.getLabelledOptions('detail')['note']!('用于在正常页面位置显示“' + title + '”的详情页面。')>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    <#else>
      <#assign title = '未知'>
      <#assign description = '正常显示的' + title + '”的页面。'>
      <#assign invokeMethod = 'view'>
      <#assign containerId = '#container'>
    </#if>
    <#assign pageLayout = typebase.customObjectType(attr.constraint.domainType.toString())>
#### ${indexObj}.${indexAttr} ${title}

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${description}

* **代码路径**

  `html/${app.name}/${alias}/${attr.name}.html`

* **应用组件**

<@appbase.print_markdown_widgets indent=4 customObjects=pageLayout.children />

* **调用参数**

      <#list attrIds![] as attrId>
  * ${modelbase.get_attribute_label(attrId)}: `${modelbase.get_attribute_sql_name(attrId)}`
      </#list>

* **调用示例**

  ```
    ajax.${invokeMethod}({
      url: 'html/${app.name}/${alias}/${attr.name}.html',
      containerId: '${containerId}',
      title: '${title}',
      allowClose: true,
      success: function() {
        page${js.nameType(alias)}Outline.show({
      <#list attrIds as attrId>
          ${modelbase.get_attribute_sql_name(attrId)}: model.${modelbase.get_attribute_sql_name(attrId)}<#if attrId?index != attrIds?size - 1>,</#if>
      </#list>
        });
      }
    });
  ```

    <#assign indexAttr = indexAttr + 1>
  </#list>
  <#assign indexObj = indexObj + 1>
</#list>

## 手机应用