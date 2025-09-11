<#import '/$/modelbase.ftl' as modelbase>

<#--  -->
<#function get_table_type obj>
  <#if obj.isLabelled('entity')>
    <#return "'N'">
  <#elseif obj.isLabelled('value')>
    <#return "'V'">
  <#elseif obj.isLabelled('conjunction')>
    <#return "'X'">
  <#elseif obj.isLabelled('series')>
    <#return "'S'">
  <#elseif obj.getLabelledOptions('entity')['revision']??>
    <#return "'R'">
  </#if>
  <#return 'null'>
</#function>
<#--  -->
<#function get_bool flag>
  <#if flag?? && flag>
    <#return 'T'>
  </#if>
  <#return 'F'>
</#function>
<#function get_ref attr>
  <#if attr.constraint.domainType.toString()?index_of('&') == 0>
    <#return "'" + attr.constraint.domainType.toString() + "'">
  </#if>
  <#return 'null'>
</#function>
<#list model.objects as obj>
  <#if !obj.persistenceName?? || obj.isLabelled('generated')><#continue></#if>
  <#assign tabId = statics["java.util.UUID"].randomUUID()?string?upper_case>
  <#assign labelObj = modelbase.get_object_label(obj)!''>
  <#if obj.isLabelled('entity')>
    <#assign entity = obj>
-- 列表  
insert into tn_uxd_custwin (custwinid, custwinnm, custwintyp, pth, dev, sta, srp)
values ('PAGE.${app.name?upper_case}.${obj.name?upper_case}.LIST', '${labelObj}列表', 'LIST', '/html/stdbiz/${app.name}/${obj.name}/list.html', 'DESKTOP', 'E', '
<div id="page${java.nameType(entity.name)}List" widget-type="Page" class="card fade fadeIn">
  <div class="card-header">
    <i class="fas fa-list"></i>
    <strong>${modelbase.get_object_label(entity)}列表</strong>
    <div class="card-header-actions">
      <a class="card-header-action text-primary" data-toggle="dropdown">
        <i class="fas fa-ellipsis-v"></i>
      </a>
      <div class="dropdown-menu dropdown-menu-right" style="min-width: 80px;">
        <a class="dropdown-item font-15 text-white bg-success p-1" style="font-weight: unset;"
           href="javascript:stdbiz.sidebar(''#page${java.nameType(obj.name)}List'', ''PAGE.${app.name?upper_case}.${obj.name?upper_case}.EDIT'', ''#page${java.nameType(obj.name)}Edit'', {}, ''新建${labelObj}'');" >
          <i class="far fa-plus-square text-white ml-0"></i>新  建
        </a>
      </div>
    </div>
  </div>
  <div class="card-body">
    <#if entity.isLabelled('treelike')>
    <div class="col-md-12 pl-0 pr-0" style="height: calc(100% - 20px)"
         widget-id="TREELIKETABLE.${entity.name?upper_case}.LIST" widget-type="TreelikeTable">
    </div>
    <#else>
    <div class="col-md-12 pl-0 pr-0" style="height: calc(100% - 20px)"
         widget-id="PAGINATIONTABLE.${entity.name?upper_case}.LIST" widget-type="PaginationTable">
    </div>
    </#if>
  </div>
</div>
');

-- 编辑
insert into tn_uxd_custwin (custwinid, custwinnm, custwintyp, pth, dev, sta, srp)
values ('PAGE.${app.name?upper_case}.${obj.name?upper_case}.EDIT', '${labelObj}编辑', 'EDIT', '/html/stdbiz/${app.name}/${obj.name}/edit.html', 'DESKTOP', 'E', '
<div id="page${js.nameType(entity.name)}Edit" widget-type="Page" class="card b-a-0">
  <div widget-id="FORM.${entity.name?upper_case}.EDIT" widget-type="FormLayout" class="card-body mb-3">
  </div>
</div>
');

-- 概览
insert into tn_uxd_custwin (custwinid, custwinnm, custwintyp, pth, dev, sta, srp)
values ('PAGE.${app.name?upper_case}.${obj.name?upper_case}.VIEW', '${labelObj}概览', 'VIEW', '/html/stdbiz/${app.name}/${obj.name}/view.html', 'DESKTOP', 'E', '
<div id="page${js.nameType(entity.name)}View" widget-type="Page" class="card b-a-0">
  <div widget-id="GROUPINGBOX.${entity.name?upper_case}.VIEW" widget-type="GroupingBox" class="card-body mb-3">
  </div>
</div>
');

    <#if obj.getLabelledOptions('entity')['revision']??>
-- 修改日志
insert into tn_uxd_custwin (custwinid, custwinnm, custwintyp, pth, dev, sta, srp)
values ('PAGE.${app.name?upper_case}.${obj.name?upper_case}.LOG', '${labelObj}日志', 'LOG', '/html/stdbiz/${app.name}/${obj.name}/log.html', 'DESKTOP', 'E', '
<div id="page${js.nameType(entity.name)}Log" widget-type="Page" class="card b-a-0">
  <div widget-id="TIMELINE.${entity.name?upper_case}.LOG" widget-type="Timeline" class="card-body mb-3">
  </div>
</div>
');

    </#if>
    <#list obj.attributes as attr>
      <#if attr.name == 'status'>
-- 状态
insert into tn_uxd_custwin (custwinid, custwinnm, custwintyp, pth, dev, sta, srp)
values ('PAGE.${app.name?upper_case}.${obj.name?upper_case}.STATUS', '${labelObj}状态', 'STATUS', '/html/stdbiz/${app.name}/${obj.name}/status.html', 'DESKTOP', 'E', '
<div id="page${js.nameType(entity.name)}Status" widget-type="Page" class="card b-a-0">
  <div widget-id="TIMELINE.${entity.name?upper_case}.STATUS" widget-type="Timeline" class="card-body mb-3">
  </div>
</div>
');

-- 向导
insert into tn_uxd_custwin (custwinid, custwinnm, custwintyp, pth, dev, sta, srp)
values ('PAGE.${app.name?upper_case}.${obj.name?upper_case}.STEP', '${labelObj}步骤', 'STEP', '/html/stdbiz/${app.name}/${obj.name}/step.html', 'DESKTOP', 'E', '
<div id="page${js.nameType(entity.name)}Step" widget-type="Page" class="card b-a-0">
  <div widget-id="TIMELINE.${entity.name?upper_case}.STEP" widget-type="Timeline" class="card-body mb-3">
  </div>
</div>
');

      </#if>
    </#list>
<#---------------->
<#-- 页面查询列表 -->
<#---------------->
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('TABLE.${parentApplication?upper_case}.${obj.name?upper_case}.LIST', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'table${js.nameType(obj.name)}List', '${labelObj}分页列表', 'PaginationTable', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/paginate'',
  limit: 15,
    <#if obj.isLabelled('treelike')>
  fields: {
    id: ''${js.nameVariable(obj.name)}Id'', 
    name: ''${js.nameVariable(obj.name)}Name'',
    parentId: ''parent${js.nameType(obj.name)}Id''
  },
  params: {
    root: {
      _and_condition: ''and ${obj.persistenceName?split('_')[2]}.par${modelbase.get_id_attributes(obj)[0].persistenceName} = \\''0\\''''
    },
    child: {

    }
  },
    <#else>
  params: params,
    </#if>
  columns: [{
    title: ''名称'',
    style: ''text-align: left;'',
    display: function(row, td, rowidx, colidx) {
      let strong = dom.create(''strong'');
      strong.innerText = row.${js.nameVariable(obj.name)}Name;
      let small = dom.create(''div'', ''small'', ''text-muted'');
      small.innerText = '''';

      td.appendChild(strong);
      td.appendChild(small);
    }
  },{
    title: ''操作'',
    style: ''text-align: center;'',
    display: function(row, td, rowidx, colidx) {
      // 编辑
      let link = dom.create(''a'', ''btn'', ''text-primary'');
      dom.model(link, row);
      let icon = dom.create(''i'', ''fas'', ''fa-edit'');
      link.appendChild(icon);
      td.appendChild(link);
      dom.bind(link, ''click'', function() {
        let params = dom.model(this);
        stdbiz.sidebar(''#page${js.nameType(obj.name)}List'', ''PAGE.${app.name?upper_case}.${obj.name?upper_case}.EDIT'', ''#page${js.nameType(obj.name)}Edit'', params);
      });

      if (!row.state) return;

      // 禁用和恢复
      link = dom.create(''a'', ''btn'');
      dom.model(link, row);
      if (row.state == ''E'') {
        link.classList.add(''text-danger'');
        icon = dom.create(''i'', ''fas'', ''fa-trash-alt'');
        dom.bind(link, ''click'', function() {
          let ${js.nameVariable(obj.name)}Id = this.getAttribute(''data-model-${obj.name?replace('_', '-')}-id'');
          let ${js.nameVariable(obj.name)}Name = this.getAttribute(''data-model-${obj.name?replace('_', '-')}-name'');
          dialog.confirm(''确定要禁用【'' + ${js.nameVariable(obj.name)}Name + ''】？'', function() {
            stdbiz.${app.name}.disableStateOf${js.nameType(obj.name)}({${js.nameVariable(obj.name)}Id: ${js.nameVariable(obj.name)}Id}, function(data) {
              stdbiz.pages[''page${js.nameType(obj.name)}List''][''PAGINATIONTABLE.${obj.name?upper_case}.LIST''].request();
            });
          });
        });
      } else {
        link.classList.add(''text-success'');
        icon = dom.create(''i'', ''fas'', ''fa-recycle'');
        dom.bind(link, ''click'', function() {
          let ${js.nameVariable(obj.name)}Id = this.getAttribute(''data-model-${obj.name?replace('_', '-')}-id'');
          let ${js.nameVariable(obj.name)}Name = this.getAttribute(''data-model-${obj.name?replace('_', '-')}-name'');
          dialog.confirm(''确定要恢复【'' + ${js.nameVariable(obj.name)}Name + ''】？'', function() {
            stdbiz.${app.name}.enableStateOf${js.nameType(obj.name)}({${js.nameVariable(obj.name)}Id: ${js.nameVariable(obj.name)}Id}, function(data) {
              stdbiz.pages[''page${js.nameType(obj.name)}List''][''PAGINATIONTABLE.${obj.name?upper_case}.LIST''].request();
            });
          });
        });
      }
      link.appendChild(icon);
      td.appendChild(link);
    }
  }],
  // 查询条件
  filter: {
    fields: [{
      title: ''名称'',
      name: ''${js.nameVariable(obj.name)}Name'',
      input: ''text''
    },{
      title: ''系统状态'',
      input: ''check'',
      name: ''state[]'',
      values: [{
        value: stdbiz.uxd.ENABLED, text: ''已激活'', checked: true
      }, {
        value: stdbiz.uxd.DISABLED, text: ''已禁用''
      }]
    }]
  },
  // 排序
  sort: {
    fields: [{
      title: ''名称'',
      name: ''${js.nameVariable(obj.name)}Name''
    }]
  }
}
');

<#---------------->
<#-- 页面编辑表单 -->
<#---------------->
    <#assign displayAttrs = []>
    <#list obj.attributes as attr>
      <#if attr.name == 'last_modified_time'><#continue></#if>
      <#if attr.name == 'state'><#continue></#if>
      <#if attr.type.collection><#continue></#if>
      <#if modelbase.is_attribute_system(attr)><#continue></#if>
      <#if attr.constraint.identifiable && attr.type.custom>
        <#assign refObj = model.findObjectByName(attr.type.name)>
        <#list refObj.attributes as refObjAttr>
          <#if refObjAttr.constraint.identifiable><#continue></#if>
          <#if refObjAttr.type.collection><#continue></#if>
          <#if refObjAttr.type.custom><#continue></#if>
          <#if refObjAttr.name == 'state'><#continue></#if>
          <#if refObjAttr.name == 'last_modified_time'><#continue></#if>
          <#assign displayAttrs = displayAttrs + [refObjAttr]>
        </#list>
        <#continue>
      </#if>
      <#assign displayAttrs = displayAttrs + [attr]>
    </#list>
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('FORM.${obj.name?upper_case}.EDIT', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'form${js.nameType(obj.name)}Edit', '${labelObj}编辑表单', 'FormLayout', 'E', '
{
  columnCount: 1,
  save: {
    url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/save'',
    callback: function() {
      stdbiz.pages[''page${js.nameType(obj.name)}List''][''PAGINATIONTABLE.${obj.name?upper_case}.LIST''].request();
    },
    convert: function(data) {
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('reference')><#continue></#if>
      data.${modelbase.get_attribute_sql_name(attr)} = '';
    </#list>
      data.state = 'E';
      data.lastModifiedTime = 'now';
      return data;
    }
  },
  read: {
    url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/read'',
    convert: function(data) {
      return data;
    }
  },
  fields: [{
    <#list displayAttrs as attr>
      <#if attr?index != 0>
  }, {
      </#if>
    name: ''${modelbase.get_attribute_sql_name(attr)}'',
    title: ''${modelbase.get_attribute_label(attr)}'',
      <#if attr.constraint.identifiable>
    required: false,
      <#else>
    required: <#if attr.constraint.nullable>false<#else>true</#if>,  
      </#if>
      <#if attr.type.custom>
        <#assign refObj = model.findObjectByName(attr.type.name)>
    input: ''select'',
    options: {
      url: ''/api/v3/common/script/stdbiz/${app.name}/${refObj.name}/find'',
      placeholder: ''请选择...'',
      searchable: true,
      fields: {value: ''${java.nameVariable(refObj.name)}Id'', text: ''${java.nameVariable(refObj.name)}Name''}
    }
      <#elseif attr.constraint.domainType.name?index_of('enum') == 0>
        <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
    input: ''select'',
    options: {
      placeholder: ''请选择...'',
      searchable: false,
      values: [
          <#list pairs as pair>
        {value: "${pair.key}", text: "${pair.value}"}<#if pair?index != pairs?size - 1>,</#if>
          </#list>
      ]
    }
      <#elseif attr.constraint.identifiable>
    input: ''hidden''
      <#elseif attr.getLabelledOptions('reference')['value']! == 'type'>
    value: ''TODO'',
    input: ''hidden''
      <#elseif attr.getLabelledOptions('reference')['value']! == 'id'>
    input: ''select'',
    options: {
      url: ''/api/v3/common/script/stdbiz/${app.name}/TODO/find'',
      placeholder: ''请选择...'',
      searchable: true,
      fields: {value: ''TODO_ID'', text: ''TODO_NAME''}
    }
      <#else>
    input: ''text''
      </#if>
    </#list>    
  }]
}
');

<#------------------>
<#-- 页面概览展示 -->
<#------------------>
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('GROUPINGBOX.${obj.name?upper_case}.VIEW', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'GROUPINGBOX.${obj.name?upper_case}.VIEW', '${labelObj}展示分组', 'GroupingBox', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/read'',
  groups: [{
    title: ''头像、商标'',
    type: ''avatar'',
    items: [{
      name: ''''
    }]
  },{
    title: ''基本信息'',
    type: ''base'',
    items: [{
      label: ''名称'',
      type: ''text'',
      name: ''${java.nameVariable(obj.name)}Name''
    }]
  }, {
    <#list obj.attributes as attr>
      <#if !attr.type.collection><#continue></#if>
      <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
    title: ''列表信息'',
    type: ''list'',
    url: ''/api/v3/common/script/stdbiz/${app.name}/${refObj.name}/find'',
    render: function(container, data) {

    }
  }, {
    </#list>
    title: ''图表信息'',
    type: ''chart'',
    url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/aggregate'',
    render: function(container, data) {

    }
  }]
}
');

<#------------------>
<#-- 分页格子展示 -->
<#------------------>
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('PAGINATIONBOX.${obj.name?upper_case}.LIST', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'box${js.nameType(obj.name)}List', '${labelObj}分页卡片', 'PaginationBox', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/paginate'',
  limit: 5,
  colspan: 4,
  borderless: true,
  render: function(container, row, index) {
  },
  filter: {
    fields: [{
      title: ''名称'',
      input: ''text'',
      name: ''databaseName''
    }]
  }
}
');

    <#if obj.getLabelledOptions('entity')['revision']??>
<#------------------------>
<#-- 【修改日志】时间线展示 -->
<#------------------------>
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('TIMELINE.${obj.name?upper_case}.LOG', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'timeline${js.nameType(obj.name)}Log', '${labelObj}修改日志', 'Timeline', 'E', '
{
  
}
');

    </#if>
    <#list obj.attributes as attr>
      <#if attr.name == 'status'>
<#------------------------>
<#-- 【状态变化】时间线展示 -->
<#------------------------>
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('TIMELINE.${obj.name?upper_case}.STATUS', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'timeline${js.nameType(obj.name)}Status', '${labelObj}状态变化', 'Timeline', 'E', '
{
  
}
');

<#------------------------>
<#-- 【信息向导】时间线展示 -->
<#------------------------>
insert into tn_uxd_custelem (custelemid, parcustelemid, refid, reftyp, custelemnm, custelemtxt, custelemtyp, sta, srp)
values ('TIMELINE.${obj.name?upper_case}.STEP', '0', '${obj.name?upper_case}', 'STDBIZ.SAM.MANAGED_ENTITY', 'timeline${js.nameType(obj.name)}Step', '${labelObj}变化步骤', 'Timeline', 'E', '
{
  
}
');

      </#if>
    </#list>
  </#if> <#--if obj.isLabelled('entity')-->
</#list>
