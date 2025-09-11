<#import '/$/guidbase.ftl' as guidbase>
<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
$('#buttons${js.nameType(objname)} button[data-role=new]').off('click');
$('#buttons${js.nameType(objname)} button[data-role=new]').on('click', function() {
  self.showWidgetEdit();
});
