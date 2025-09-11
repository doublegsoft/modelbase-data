
<#function get_widget_name customObject>
  <#if customObject.name == 'form'>
    <#return '编辑表单'>
  <#elseif customObject.name == 'toolbar'>
    <#return '工具栏'>
  <#elseif customObject.name == 'code'>
    <#return '代码编辑器'>
  <#elseif customObject.name == 'graph'>
    <#return '图谱展示'>
  <#elseif customObject.name == 'chart'>
    <#return '示意图'>
  <#elseif customObject.name == 'listview'>
    <#return '列表'>
  <#elseif customObject.name == 'pagination_table'>
    <#return '分页表格'>
  <#elseif customObject.name == 'text'>
    <#return '文本输入框'>
  <#elseif customObject.name == 'text' && customObject.getAttribute('readonly')! == 'true'>
    <#return '文本显示框'>
  <#elseif customObject.name == 'avatar'>
    <#return '头像输入'>
  <#elseif customObject.name == 'avatar' && customObject.getAttribute('readonly')! == 'true'>
    <#return '头像显示'>
  <#elseif customObject.name == 'password'>
    <#return '密码输入框'>
  <#elseif customObject.name == 'password' && customObject.getAttribute('readonly')! == 'true'>
    <#return '密码显示框'>
  <#elseif customObject.name == 'select'>
    <#return '选择框'>
  <#elseif customObject.name == 'date'>
    <#return '日期输入框'>
  <#elseif customObject.name == 'button'>
    <#return '按钮'>
  <#else>
    <#return customObject.name!''>
  </#if>
</#function>

<#macro print_markdown_widgets indent customObjects>
<#list customObjects as customObject>
<#if customObject.type.name??>
${''?left_pad(indent)}* ${get_widget_name(customObject.type)}
<#else>
${''?left_pad(indent)}* <###>
</#if>
<@print_markdown_widgets indent = indent + 4 customObjects=customObject.type.children />
</#list>
</#macro>