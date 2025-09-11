<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
//
// 【功能】树选择器
//
this.checktree${js.nameType(id)} = new Checktree({
  url: '/api/v2/common/script',
  usecase: '<#if application??>${application}/</#if>${pageOwner.module?replace(objname, bound)}/treerize',
  data: {},
  name: '${js.nameVariable(bound)}Id',
  fields: {
    name: '${js.nameVariable(bound)}Name',
    id: '${js.nameVariable(bound)}Id',
    parentId: 'parent${js.nameType(bound)}Id'
  }
});