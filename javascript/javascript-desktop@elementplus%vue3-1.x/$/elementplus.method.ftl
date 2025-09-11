
<#macro print_method_editable_form obj indent>
${""?left_pad(indent)}
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 【${modelbase.get_object_label(obj)}】保存操作。
${""?left_pad(indent)} */
${""?left_pad(indent)}const doSave${js.nameType(obj.name)} = async () => {
${""?left_pad(indent)}  try {
${""?left_pad(indent)}    await refForm${js.nameType(obj.name)}.value.validate();
${""?left_pad(indent)}    console.log(toRaw(props.${js.nameVariable(obj.name)}));
${""?left_pad(indent)}    sdk.save${js.nameType(obj.name)}(toRaw(props.${js.nameVariable(obj.name)}));
${""?left_pad(indent)}  } catch (err) {
${""?left_pad(indent)}    ElMessage({
${""?left_pad(indent)}      message: '请正确填写${modelbase.get_object_label(obj)}信息！',
${""?left_pad(indent)}      type: 'error',
${""?left_pad(indent)}    });
${""?left_pad(indent)}  }
${""?left_pad(indent)}};
${""?left_pad(indent)}
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 【${modelbase.get_object_label(obj)}】关闭编辑窗体。
${""?left_pad(indent)} */
${""?left_pad(indent)}const doClose${js.nameType(obj.name)}Edit = async () => {
${""?left_pad(indent)}  emit('close');
${""?left_pad(indent)}};
</#macro>

<#--
 ### 【迷你图】需要的全部方法。
 -->
<#macro print_method_sparkline obj indent>
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 渲染【${modelbase.get_object_label(obj)}】迷你趋势图。
${""?left_pad(indent)} */
${""?left_pad(indent)}const renderSparkline${js.nameType(obj.name)} = () => {
${""?left_pad(indent)}  if (!sparkline${js.nameType(obj.name)}.value) return;
${""?left_pad(indent)}  sparklineInst${js.nameType(obj.name)} = echarts.init(sparkline${js.nameType(obj.name)}.value);
${""?left_pad(indent)}  sparklineInst${js.nameType(obj.name)}.setOption({
${""?left_pad(indent)}    grid: { left: 0, right: 0, top: 0, bottom: 0 },
${""?left_pad(indent)}    xAxis: { type: 'category', show: false, data: [10, 15, 13, 18, 16, 22, 19].map((_, i) => i) },
${""?left_pad(indent)}    yAxis: { type: 'value', show: false },
${""?left_pad(indent)}    tooltip: { show: false },
${""?left_pad(indent)}    series: [{
${""?left_pad(indent)}      type: 'line',
${""?left_pad(indent)}      data: [10, 15, 13, 18, 16, 22, 19],
${""?left_pad(indent)}      smooth: true,
${""?left_pad(indent)}      symbol: 'none',
${""?left_pad(indent)}      lineStyle: {
${""?left_pad(indent)}        width: 2
${""?left_pad(indent)}      },
${""?left_pad(indent)}    }],
${""?left_pad(indent)}  });
${""?left_pad(indent)}};
</#macro> 

<#--
 ### 【文档编辑】需要的全部方法。
 -->
<#macro print_method_richtext obj indent>
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 渲染【${modelbase.get_object_label(obj)}】文字文档。
${""?left_pad(indent)} */
${""?left_pad(indent)}const renderRichtextFor${js.nameType(obj.name)} = () => {
${""?left_pad(indent)}  // TODO: 实现此方法
${""?left_pad(indent)}};
</#macro>

<#--
 ### 【广义表格】需要的全部方法。
 -->
<#macro print_method_spreadsheet obj indent>
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 渲染【${modelbase.get_object_label(obj)}】广义表格。
${""?left_pad(indent)} */
${""?left_pad(indent)}const renderSpreadsheetFor${js.nameType(obj.name)} = () => {
${""?left_pad(indent)}  // TODO: 实现此方法
${""?left_pad(indent)}};
</#macro>

<#--
 ### 【泳道图示】需要的全部方法。
 -->
<#macro print_method_swimlane obj indent>
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 渲染【${modelbase.get_object_label(obj)}】泳道图示。
${""?left_pad(indent)} */
${""?left_pad(indent)}const renderSwimlaneFor${js.nameType(obj.name)} = () => {
${""?left_pad(indent)}  // TODO: 实现此方法
${""?left_pad(indent)}};
</#macro>

<#--
 ### 【流程图示】需要的全部方法。
 -->
<#macro print_method_flowchart obj indent>
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 渲染【${modelbase.get_object_label(obj)}】流程图示。
${""?left_pad(indent)} */
${""?left_pad(indent)}const renderFlowchartFor${js.nameType(obj.name)} = () => {
${""?left_pad(indent)}  // TODO: 实现此方法
${""?left_pad(indent)}};
</#macro>

<#--
 ### 【打印品类】需要的全部方法。
 -->
<#macro print_method_printout obj indent>
${""?left_pad(indent)}/**
${""?left_pad(indent)} * 渲染【${modelbase.get_object_label(obj)}】打印品类。
${""?left_pad(indent)} */
${""?left_pad(indent)}const renderPrintoutFor${js.nameType(obj.name)} = () => {
${""?left_pad(indent)}  // TODO: 实现此方法
${""?left_pad(indent)}};
</#macro>