<#import '/$/guidbase.ftl' as guidbase>
<#assign objname = module?substring(module?index_of('/') + 1)>
<#assign widgetCollection = 'table'>
/**
 * It is the default constructor for ${bound} page.
 */
function Page${js.nameType(bound)}() {
  let self = this;
  this.observable = new ObservableObject({

  });
<#list app.pages as page>
  <#if page.module != module><#continue></#if>
  <#if page.id == 'list'>
    <#list page.pageWidgets as widget>
      <#if widget.type?? && widget.type == 'tree'>
        <#assign widgetCollection = 'tree'>
        <#break>
      </#if>
    </#list>
  </#if>
  <#list page.pageWidgets as widget>
${plugin.render(widget, 2, 'decl.js')}  
  </#list> 
</#list>
};

/**
 * 显示业务实体主页面。
 */
Page${js.nameType(bound)}.prototype.show = function () {
  this.showWidgetList();
};

/**
 * 显示列表页面。
 */
Page${js.nameType(bound)}.prototype.showWidgetList = function () {
  let self = this;

  // 显示
  self.widget${js.nameType(objname)}List.siblings().hide();
  self.widget${js.nameType(objname)}List.show();

  // 重置具体业务实体标识参数
  if (this.widgetBody${js.nameType(objname)}List.html().trim() != '') {
    this.widget${js.nameType(objname)}List.siblings().hide();
    this.widget${js.nameType(objname)}List.show();
    // 重新请求表格数据
    this.${widgetCollection}${js.nameType(objname)}.request();
    return;
  } 

  ajax.view({
    url: '/html<#if application??>/${application}</#if>/${pageOwner.module}/list.html',
    containerId: '#widget${js.nameType(objname)}List div.card-body',
    success: function() {
      self.setupWidgetList();
    }
  });
}; 

/**
 * 初始化列表页面的部件。
 */
Page${js.nameType(bound)}.prototype.setupWidgetList = function () {
  let self = this;
<#list app.pages![] as page>
  <#if page.getOption('bound')! == bound && page.getOption('role')! == 'list'>
    <#list page.pageWidgets as widget>
${plugin.render(widget, 2, 'init.js')}
    </#list>
    <#break>
  </#if>
</#list>
  this.observable.install('widget${js.nameType(objname)}List');
}; 

/**
 * 初始化列表页面的部件。
 */
Page${js.nameType(bound)}.prototype.queryWidgetList = function () {
  <#if widgetCollection == 'tree'>
  this.${widgetCollection}${js.nameType(objname)}.request();
  <#else>
  this.${widgetCollection}${js.nameType(objname)}.go(1);
  </#if>
};

/**
 * 显示编辑页面。
 */
Page${js.nameType(bound)}.prototype.showWidgetEdit = function (${js.nameVariable(objname)}Id) {
  let self = this;
  if (this.widgetBody${js.nameType(objname)}Edit.html().trim() != '') {
    this.widget${js.nameType(objname)}Edit.siblings().hide();
    this.widget${js.nameType(objname)}Edit.show();
    // 加载编辑页面数据
    this.readWidgetEdit(${js.nameVariable(objname)}Id);
    return;
  }

  ajax.view({
    url: '/html<#if application??>/${application}</#if>/${pageOwner.module}/edit.html',
    containerId: '#widget${js.nameType(objname)}Edit div.card-body',
    success: function() {
      self.widget${js.nameType(objname)}Edit.siblings().hide();
      self.widget${js.nameType(objname)}Edit.show();
      self.readWidgetEdit(${js.nameVariable(objname)}Id);
    }
  });
};

/**
 * 初始化编辑页面的部件。
 */
Page${js.nameType(bound)}.prototype.setupWidgetEdit = function (${js.nameVariable(objname)}Data) {
  let self = this;
<#list app.pages![] as page>
  <#if page.getOption('bound')! == bound && page.getOption('role')! == 'edit'>
    <#list page.pageWidgets as widget>
${plugin.render(widget, 2, 'init.js')}
    </#list>
    <#break>
  </#if>
</#list>
  this.observable.install('widget${js.nameType(objname)}Edit');
};

/**
 * 读取业务实体数据。
 */
Page${js.nameType(bound)}.prototype.readWidgetEdit = function (${js.nameVariable(objname)}Id) {
  let self = this;
  if (${js.nameVariable(objname)}Id) {
    xhr.post({
      url: HOST + '/api/v2/common/script',
      usecase: '<#if application??>${application}/</#if>${pageOwner.module}/read',
      data: {
        ${js.nameVariable(objname)}Id: ${js.nameVariable(objname)}Id
      },
      success: function (resp) {
        utils.assemble(resp.data, '${js.nameVariable(objname)}');
        $('#form${js.nameType(objname)}').formdata(resp.data);
        // 协同数据初始化部件
        self.setupWidgetEdit(resp.data);
      }
    });
    return;
  }
  this.setupWidgetEdit({});
  $('#form${js.nameType(objname)}').formdata({});
};

/**
 * 保存业务实体数据。
 */
Page${js.nameType(bound)}.prototype.saveWidgetEdit = function () {
  let self = this;
  let errors = $('#form${js.nameType(objname)}').validate();
  if (errors.length > 0) {
    dialog.error(utils.message(errors));
    return;
  }
  // 禁用所有按钮
  this.widgetBody${java.nameType(objname)}Edit.find('.btn').button('loading');

  // 提交数据
  let data = $('#form${js.nameType(objname)}').formdata();
<#list app.pages as page>
  <#if page.module != module><#continue></#if>
  <#if page.id == 'edit'>
    <#list page.pageWidgets as widget>
      <#if widget.getOption('role')! == 'checklist'>
  data.${js.nameVariable(widget.id)} = this.checklist${js.nameType(widget.id)}.getSelections();
      <#elseif widget.getOption('role')! == 'checktree'>
  data.${js.nameVariable(widget.id)} = [];
  this.checktree${js.nameType(widget.id)}.getSelections().forEach((node) => {
    data.${js.nameVariable(widget.id)}.push({${js.nameVariable(widget.getOption('bound'))}Id: node.${js.nameVariable(widget.getOption('bound'))}Id});
  });
      </#if>
    </#list>
  </#if>
</#list>
  xhr.post({
    url: HOST + '/api/v2/common/script',
    usecase: usecase = '<#if application??>${application}/</#if>${pageOwner.module}/save',
    data: data,
    success: function (resp) {
      if (resp.error) {
        dialog.error(resp.error.message);
        self.widgetBody${java.nameType(objname)}Edit.find('.btn').button('reset');
        return;
      }
      $('#form${js.nameType(objname)} input[name=${js.nameVariable(objname)}Id]').val(resp.data.id);
      self.widgetBody${java.nameType(objname)}Edit.find('.btn').button('reset');
      dialog.success('数据保存成功！', function() {
        self.showWidgetList();
      });
    }
  });
};

var page${js.nameType(bound)} = new Page${js.nameType(bound)}();
page${js.nameType(bound)}.show();