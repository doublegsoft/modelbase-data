<#import '/$/guidbase.ftl' as guidbase>
<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
$('#buttons${js.nameType(objname)} button[data-role=reset]').off('click');
$('#buttons${js.nameType(objname)} button[data-role=reset]').on('click', function() {
  $('#form${js.nameType(objname)}').formdata({});
<#list pageOwner.pageWidgets as widget>
  <#if widget.getOption('type')! == 'input' && widget.getOption('role')! == 'select'>
  $('#form${js.nameType(objname)} select[name=${js.nameVariable(widget.id)}]').val(null).trigger('change');
  </#if>
</#list>
});
