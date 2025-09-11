<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
$('#buttons${js.nameType(objname)} button[data-role=query]').off('click');
$('#buttons${js.nameType(objname)} button[data-role=query]').on('click', function () {
  self.queryWidgetList();
});