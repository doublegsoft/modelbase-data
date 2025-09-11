<#import '/$/guidbase.ftl' as guidbase>
<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
$('#buttons${js.nameType(objname)} button[data-role=back]').off('click');
$('#buttons${js.nameType(objname)} button[data-role=back]').on('click', function() {
  self.showWidgetList();
});
