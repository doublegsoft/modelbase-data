//
// 初始化【${title!''}】日期时间选择框。
//
$('#${js.nameVariable(container.id)} input[name=${js.nameVariable(id)}]').datetimepicker({
  format: 'YYYY-MM-DD hh:mm',
  locale: 'zh_CN'
});