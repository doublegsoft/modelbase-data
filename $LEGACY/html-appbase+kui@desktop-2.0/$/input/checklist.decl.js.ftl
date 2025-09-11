<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
//
// 【${title!''}】多选列表
// 
this.checklist${js.nameType(id)} = new Checklist({
  url: '/api/v2/common/script',
  usecase: '<#if application??>${application}/</#if>${pageOwner.module?replace(objname, bound)}/find',
  name: '${js.nameVariable(bound)}Id',
  fields: {text: '${fieldText!''}', value: '${fieldValue!''}'}
});