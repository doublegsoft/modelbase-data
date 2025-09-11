<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
this.${js.nameVariable(id)} = new TreelikeTable({
  url: '/api/v2/common/script',
  usecase: '<#if application??>${application}/</#if>${pageOwner.module}/treerize',
  queryId: 'query${java.nameType(objname)}',
  fields: {
    id: '${js.nameVariable(objname)}Id',
    parentId: 'parent${js.nameType(objname)}Id',
    name: '${js.nameVariable(objname)}Name'
  },
  data: {
    usecase: '${pageOwner.module}/treerize'
  },
  columns: [{
<#list children as child>
  <#if child?index != 0>
  },{
  </#if>
    title: '${child.title!''}',
    style: 'text-align: left',
    display: function (row, td) {
  <#if child.elements??>
    <#assign elements = child.elements?split('+')>
    <#list elements as element>
      <#if element?index == 0>
      let elm = $('<strong>');
      elm.text(row.${js.nameVariable(element?replace('@', ''))});
      $(td).append(elm);
      <#else>
      elm = $('<div>');
      elm.addClass('small text-muted');
      elm.text(row.${js.nameVariable(element?replace('@', ''))});
      $(td).append(elm);
      </#if>
    </#list>
  <#elseif child.id??>
      <#assign cellname = child.id>
      <#if cellname == 'name' || cellname == 'type'><#assign cellname = objname + '_' + child.id></#if>
      let ${js.nameVariable(cellname)} = row.${js.nameVariable(cellname)};
      $(td).html(${js.nameVariable(cellname)});
  </#if>
    }
</#list>    
  }, {
    title: '操作',
    style: 'text-align: center',
    display: function (row, td) {
      let a = $('<a>');
      a.attr('data-id', row.${js.nameVariable(objname)}Id);
      a.addClass('btn btn-link');
      a.text('编辑');
      a.on('click', function() {
        self.showWidgetEdit($(this).attr('data-id'));
      });
      $(td).append(a);
    }
  }]
});