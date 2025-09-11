//
// 初始化【${title!''}】日期选择框。
//
$('#${js.nameVariable(container.id)} input[name=${js.nameVariable(id)}]').daterangepicker({
  autoUpdateInput: false,
  locale: { 
    cancelLabel: '取消', 
    applyLabel: '确定' 
  }  
}, function(start, end, label) {
  $(this).val(start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD'));
  return start.format('YYYY-MM-DD') + '至' + end.format('YYYY-MM-DD');
});