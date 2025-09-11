//
// 初始化【${title!''}】时间选择框。
//
$('#${js.nameVariable(container.id)} input[name=${js.nameVariable(id)}]').datetimepicker({
  format: 'hh:mm',
  locale: 'zh_CN'
});