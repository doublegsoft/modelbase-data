<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
<#assign boundobj = bound!objname>
<#assign dataname = js.nameVariable(id)?replace(js.nameVariable(objname), '')?replace(js.nameType(objname), '')>
<#assign defaultOption = '请选择...'>
<#if container.type == 'query'>
  <#assign defaultOption = '不限'>
</#if>
//
// 初始化【${title!''}】下拉选择框。
//
<#if bound??>
$('#${js.nameVariable(container.type)}${js.nameType(objname)} select[name=${js.nameVariable(id)}]').searchselect({
  url: '/api/v2/common/script',
  placeholder: '${defaultOption}',
  usecase: '<#if application??>${application}/</#if>${pageOwner.module?replace(objname, boundobj)}/find',
  fields: {
    text: '${fieldText!'name'}',
    value: '${fieldValue!'id'}'
  },
  data: {},
<#if container.type == 'form'>
  selection: ${js.nameVariable(objname)}Data ? ${js.nameVariable(objname)}Data.${js.nameVariable(dataname)} : null
</#if>
});
<#else>
$('#${js.nameVariable(container.type)}${js.nameType(objname)} select[name=${js.nameVariable(id)}]').searchselect({
<#if container.type == 'form'>
  placeholder: '${defaultOption}',
  selection: ${js.nameVariable(objname)}Data ? ${js.nameVariable(objname)}Data.${js.nameVariable(dataname)} : null
</#if>
});
</#if>
