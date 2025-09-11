<#import '/$/modelbase.ftl' as modelbase>
if (typeof stdbiz === 'undefined') stdbiz = {};
if (typeof stdbiz.${app.name} === 'undefined') stdbiz.${app.name} = {};
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#if attrIds?size == 0><#continue></#if>

////////////////////////////////////////////////////////////////////////////////
//
// ${obj.name?upper_case} OPTIONS
//
////////////////////////////////////////////////////////////////////////////////

stdbiz.${app.name}.optionsTable${js.nameType(obj.name)} = {
  url: '/api/v3/common/script/stdbiz/${app.name}/${obj.name}/paginate',
  params: {
    state: 'E'
  },
  limit: 15,
  columns: [{

  }]
};

stdbiz.${app.name}.optionsGrid${js.nameType(obj.name)} = {
  url: '/api/v3/common/script/stdbiz/${app.name}/${obj.name}/paginate',
  params: {
    state: 'E'
  },
  limit: 8,
  render:  function(div, row, index) {

  },
  filter: {

  }
};

stdbiz.${app.name}.optionsSheet${js.nameType(obj.name)} = {
  
};

stdbiz.${app.name}.optionsChart${js.nameType(obj.name)} = {
  values: [{
    name: 'value0',
    text: '毛利润',
    operator: 'sum',
    color: '#283593'
  }, {
    name: 'value1',
    text: '销售额',
    operator: 'sum',
    color: '#2E7D32'
  }],
  category: {
    name: 'group',
    values: {
      '1': {text: '药品', color: 'blue'},
      '2': {text: '耗材', color: 'green'},
      '3': {text: '服务', color: 'yellow'}
    }
  },
  data: data
};

stdbiz.${app.name}.optionsListView${js.nameType(obj.name)} = {
  containerId: '#listFilter',
  local: data,
  height: 200,
  create: function(idx, row) {
    var span = dom.create('div');
    span.innerHTML = '<div>' + row.name + '</div>';
    return span;
  },
  onRemove: function(li, model) {
    console.log(li);
  },
  onCheck: function(checked, model) {
    console.log(checked);
  },
  onFilter: function(keyword) {

  }
};

stdbiz.${app.name}.optionsForm${js.nameType(obj.name)} = {
  columnCount: 1,
  save: {
    url: '/api/v3/common/script/stdbiz/dmm/database/save',
    callback: function() {
      stdbiz.pages['pageDatabaseList']['PAGINATIONTABLE.DATABASE.LIST'].request();
    }
  },
  read: {
    url: '/api/v3/common/script/stdbiz/dmm/database/read'
  },
  fields: [{
    name: 'databaseId',
    title: '数据库标识',
    required: false,
    input: 'hidden'
  }, {
    name: 'dataSourceId',
    title: '数据源',
    required: false,  
    input: 'select',
    options: {
      url: '/api/v3/common/script/stdbiz/dmm/data_source/find',
      placeholder: '请选择...',
      searchable: true,
      fields: {value: 'dataSourceId', text: 'dataSourceName'}
    }
  }, {
    name: 'databaseName',
    title: '数据库名称',
    required: true,  
    input: 'text'
  }, {
    name: 'databaseText',
    title: '数据库说明',
    required: true,  
    input: 'text'
  }, {
    name: 'version',
    title: '版本',
    required: true,  
    input: 'text'
  }, {
    name: 'databaseType',
    title: '数据库类型',
    required: false,  
    input: 'text'
  }, {
    name: 'note',
    title: '备注',
    required: false,  
    input: 'text'
  }, {
    name: 'creatorType',
    title: '创建者类型',
    required: false,  
    value: 'TODO',
    input: 'hidden'
  }, {
    name: 'creatorId',
    title: '创建者标识',
    required: false,  
    input: 'select',
    options: {
      url: '/api/v3/common/script/stdbiz/dmm/TODO/find',
      placeholder: '请选择...',
      searchable: true,
      fields: {value: 'TODO_ID', text: 'TODO_NAME'}
    }
  }, {
    name: 'status',
    title: '业务状态',
    required: false,  
    input: 'text'
  }]
};

stdbiz.${app.name}.optionsEditor${js.nameType(obj.name)} = {
  
};

////////////////////////////////////////////////////////////////////////////////
//
// ${obj.name?upper_case} RENDERER
//
////////////////////////////////////////////////////////////////////////////////

stdbiz.${app.name}.createLinkDisable = function (opt) {
  var link = dom.create('a', 'btn', 'text-danger');
  var icon = dom.create('i', 'fas', 'fa-trash-alt');
  if (opt)
    stdbiz.${app.name}.bindElementEnable(link, opt.message, opt.model, opt.success);
  return link;
};

stdbiz.${app.name}.createLinkEnable = function (opt) {
  var link = dom.create('a', 'btn', 'text-primary');
  var icon = dom.create('i', 'fas', 'fa-recycle');
  if (opt)
    stdbiz.${app.name}.bindElementDisable(link, opt.message, opt.model, opt.success);
  return link;
};

stdbiz.${app.name}.createLinkEdit = function (opt) {
  var link = dom.create('a', 'btn', 'text-primary');
  var icon = dom.create('i', 'fas', 'fa-edit');
  if (opt)
    stdbiz.${app.name}.bindElementEdit(link, opt.message, opt.model, opt.success);
  return link;
};

stdbiz.${app.name}.createLinkDelete = function (opt) {
  var link = dom.create('a', 'btn', 'text-primary');
  var icon = dom.create('i', 'fas', 'fa-times-circle');
  if (opt)
    stdbiz.${app.name}.bindElementEdit(link, opt.message, opt.model, opt.success);
  return link;
};

stdbiz.${app.name}.createLinkActions = function(opt) {
  var link = dom.create('a', 'btn', 'text-primary');
  var icon = dom.create('i', 'fas', 'fa-ellipse-v');
  return link;
};

// // 绑定元素触发【禁用】操作
stdbiz.${app.name}.bindElementDisable = function (selector, message, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
  dom.bind(trigger, 'click', function() {
    var model = dom.model(this);
    dialog.confirm(message, function() {
      stdbiz.${app.name}.disableStateOf${js.nameType(obj.name)}(model, function() {
        if (resolve) resolve(model);
      });
    });
  });
};

// 绑定元素触发【激活】操作
stdbiz.${app.name}.bindElementEnable = function (selector, message, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
  dom.bind(link, 'click', function() {
    var model = dom.model(this);
    dialog.confirm(message, function() {
      stdbiz.${app.name}.enableStateOf${js.nameType(obj.name)}(model, function() {
        if (resolve) resolve(model);
      });
    });
  });
};

// 绑定元素触发【保存】操作
stdbiz.${app.name}.bindElementSave = function (selector, message, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
  dom.bind(link, 'click', function() {
    var model = dom.model(this);
    stdbiz.${app.name}.save${js.nameType(obj.name)}(model, function() {
      if (resolve) resolve(model);
    });
  });
};

// 绑定元素触发【删除】操作
stdbiz.${app.name}.bindElementDelete = function (selector, message, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
  dom.bind(link, 'click', function() {
    var model = dom.model(this);
    dialog.confirm(message, function() {
      stdbiz.${app.name}.delete${js.nameType(obj.name)}(model, function() {
        if (resolve) resolve(model);
      });
    });
  });
};

// 绑定元素触发【编辑】操作
stdbiz.${app.name}.bindElementEdit = function (selector, message, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
  dom.bind(trigger, 'click', function() {
    var model = dom.model(this);
    ajax.sidebar({
      containerId: '#page${js.nameType(obj.name)}List',
      title: title,
      url: 'html/stdbiz/${app.name}/${obj.name}/edit.html',
      success: function() {
        page${js.nameType(obj.name)}Edit.show(model);
      }
    });
  });
};

stdbiz.${app.name}.decorateReadonlyProgress = function (selector, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
};

stdbiz.${app.name}.decorateReadonlyTags = function (selector, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
};

stdbiz.${app.name}.decorateEditableTags = function (selector, model, resolve) {
  var trigger;
  if (typeof selector === 'string') 
    trigger = dom.find(selector);
  else
    trigger = selector;
  
  dom.model(trigger, model);
};

// 渲染【可删除】列表
stdbiz.${app.name}.render${js.nameType(obj.name)}List = function (selector, params, resolve) {
  var container;
  if (typeof selector === 'string') 
    container = dom.find(selector);
  else
    container = selector;
  
  stdbiz.${app.name}.find${js.nameType(obj.name)}(model, function(data) {
    if (!data) return;
    for (var i = 0; i < data.length; i++) {
      var li = dom.create('li', 'list-group-item');
      // 名称，还有什么
      container.appendChild(li);
    }
  });
};

stdbiz.${app.name}.viewPage${js.nameType(obj.name)}List = function (params) {
  ajax.view({
    containerId: 'container',
    url: ':PAGE.${app.name?upper_case}.${obj.name?upper_case}.LIST',
    success: function(resp) {
      var page = dom.find('div[widget-type=Page]');
      if (page) {
        page.classList.add('show');
        stdbiz.render(page.id, document.querySelector('[widget-type=Page]'), params);
      }
    }
  });
};

stdbiz.${app.name}.appendPage${js.nameType(obj.name)}List = function (title, params) {
  ajax.append({
    containerId: 'container',
    title: title,
    url: ':PAGE.${app.name?upper_case}.${obj.name?upper_case}.LIST',
    params: params || {},
    success: function(resp) {
      var page = dom.find('div[widget-type=Page]');
      if (page) {
        page.classList.add('show');
        stdbiz.render(page.id, document.querySelector('[widget-type=Page]'), params);
      }
    }
  });
};

stdbiz.${app.name}.stackPage${js.nameType(obj.name)}List = function (params) {
  ajax.stack({
    containerId: 'container',
    url: ':PAGE.${app.name?upper_case}.${obj.name?upper_case}.LIST',
    params: params || {},
    success: function(resp) {
      var page = dom.find('div[widget-type=Page]');
      if (page) {
        page.classList.add('show');
        stdbiz.render(page.id, document.querySelector('[widget-type=Page]'), params);
      }
    }
  });
};

stdbiz.${app.name}.sidebarPage${js.nameType(obj.name)}Edit = function (title, params) {
  stdbiz.sidebar('#page${js.nameType(obj.name)}List', 
    'PAGE.${app.name?upper_case}.${obj.name?upper_case}.EDIT', 
    '#page${js.nameType(obj.name)}Edit', 
    params, title);
};

stdbiz.${app.name}.promptToEnable${js.nameType(obj.name)} = function (message, params, resolve) {
  dialog.confirm(message, function() {
    stdbiz.${app.name}.enableStateOf${js.nameType(obj.name)}(params, resolve);
  });
};

stdbiz.${app.name}.promptToDisable${js.nameType(obj.name)} = function (message, params, resolve) {
  dialog.confirm(message, function() {
    stdbiz.${app.name}.disableStateOf${js.nameType(obj.name)}(params, resolve);
  });
};

stdbiz.${app.name}.promptToStatus${js.nameType(obj.name)} = function (message, params, resolve) {
  dialog.confirm(message, function() {
    stdbiz.${app.name}.changeStatusOf${js.nameType(obj.name)}(params, resolve);
  });
};

stdbiz.${app.name}.promptToDelete${js.nameType(obj.name)} = function (message, params, resolve) {
  dialog.confirm(message, function() {
    stdbiz.${app.name}.delete${js.nameType(obj.name)}(params, resolve);
  });
};

</#list>