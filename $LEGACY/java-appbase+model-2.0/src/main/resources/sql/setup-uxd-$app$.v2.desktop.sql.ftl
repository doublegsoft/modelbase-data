<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
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
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value') && !obj.isLabelled('aggregate')><#continue></#if>
  <#assign tabId = statics["java.util.UUID"].randomUUID()?string?upper_case>
  <#assign labelObj = modelbase.get_object_label(obj)!''>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#assign attrWhos = []> <#-- 什么人 -->
  <#assign attrWhoms = []> <#-- 什么人 -->
  <#assign attrWhoses = []> <#-- 什么东西 -->
  <#assign attrWhens = []> <#-- 什么时候 -->
  <#assign attrWheres = []> <#-- 什么地方 -->
  <#assign attrWhats = []> <#-- 什么东西 -->
  <#assign attrWhiches = []>
  <#assign attrNumerics = []>
  <#assign primary = ''>
  <#assign secondary = ''>
  <#assign tertiary = ''>
  <#assign quaternary = ''>
  <#assign quinary = ''>
  <#assign coll = ''>
  <#assign when = modelbase.get_object_when(obj)!''>
  <#assign whose = modelbase.get_object_whose(obj)!''>
  <#assign who = modelbase.get_object_who(obj)!''>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('who')>
      <#assign attrWhos = attrWhos + [attr]>
    </#if>
    <#if attr.isLabelled('whom')>
      <#assign attrWhoms = attrWhoms + [attr]>
    </#if>
    <#if attr.isLabelled('whose')>
      <#assign attrWhoses = attrWhoses + [attr]>
    </#if>
    <#if attr.isLabelled('when')>
      <#assign attrWhens = attrWhens + [attr]>
    </#if>
    <#if attr.isLabelled('where')>
      <#assign attrWheres = attrWheres + [attr]>
    </#if>
    <#if attr.isLabelled('what')>
      <#assign attrWhats = attrWhats + [attr]>
    </#if>
    <#if attr.isLabelled('which')>
      <#assign attrWhiches = attrWhiches + [attr]>
    </#if>
    <#if attr.isLabelled('numeric')>
      <#assign attrNumerics = attrNumerics + [attr]>
    </#if>
    <#if attr.isLabelled('primary')>
      <#assign primary = attr>
    </#if>
    <#if attr.isLabelled('secondary')>
      <#assign secondary = attr>
    </#if>
    <#if attr.isLabelled('tertiary')>
      <#assign tertiary = attr>
    </#if>
    <#if attr.isLabelled('quaternary')>
      <#assign quaternary = attr>
    </#if>
    <#if attr.isLabelled('quinary')>
      <#assign quinary = attr>
    </#if>
    <#if attr.type?? && attr.type.collection>
      <#assign coll = attr>
    </#if>
  </#list>

<#----------------------------------------------------------------------------->
<#-- 页面
<#----------------------------------------------------------------------------->
<#-------------------------------->
<#-- 【集合展示】页面
<#-------------------------------->
  <#if obj.isLabelled('entity') || obj.isLabelled('value')>
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('LIST.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '【${labelObj}】集合展示', 'LIST', 'desktop/stdbiz/${app.name}/${obj.name}/list.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}List" class="card mb-0">
  <div class="card-header pl-3 pr-3">
    <i class="fa fa-list"></i>
    <strong>${labelObj}列表</strong>
    <div class="card-header-actions">
      <a class="card-header-action" data-toggle="dropdown" href="#" role="button">
        <i class="fas fa-ellipsis-v"></i>
      </a>
      <div class="dropdown-menu dropdown-menu-right">
        <a widget-id="buttonNew" class="dropdown-item text-light pointer font-14 bg-primary p-1"
           widget-model-url=":EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
           widget-model-view="sidebar">
          <i class="fas fa-plus-square text-white ml-0"></i>新  建
        </a>
      </div>
    </div>
  </div>
  <div class="card-body pb-0">
    <div widget-id="widget${js.nameType(obj.name)}List"
         widget-model-id="PAGINATION_TABLE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
         widget-model-name="table${js.nameType(obj.name)}"
         class="col-md-12 pl-0 pr-0">
    </div>
  </div>
</div>
<script>
function Page${js.nameType(obj.name)}List() {
  this.page = dom.find(''#page${js.nameType(obj.name)}List'');
}

Page${js.nameType(obj.name)}List.prototype.show = function(params) {
  this.initialize(params);
};

Page${js.nameType(obj.name)}List.prototype.initialize = async function(params) {
  let self = this;
  await stdbiz.init(this, params);

  PubSub(''${parentApplication}/${app.name}/${obj.name}/saved'').subscribe(data => {
    page${js.nameType(obj.name)}List.table${js.nameType(obj.name)}.request();
  });
  PubSub(''${parentApplication}/${app.name}/${obj.name}/disabled'').subscribe(data => {
    page${js.nameType(obj.name)}List.table${js.nameType(obj.name)}.request();
  });
};

delete page${js.nameType(obj.name)}List;
page${js.nameType(obj.name)}List = new Page${js.nameType(obj.name)}List();
page${js.nameType(obj.name)}List.show();
</script>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('LIST.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'PAGINATION_TABLE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);

<#-------------------------------->
<#-- 【信息编辑】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '【${labelObj}】信息编辑', 'EDIT', 'desktop/stdbiz/${app.name}/${obj.name}/edit.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Edit" class="card ml-2 mr-2">
  <div widget-id="widget${js.nameType(obj.name)}Edit"
       widget-model-id="FORM_LAYOUT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
       widget-model-name="form${js.nameType(obj.name)}Edit"
       class="card-body mb-3">
  </div>
</div>

<script>
function Page${js.nameType(obj.name)}Edit () {
  this.page = dom.find(''#page${js.nameType(obj.name)}Edit'');
}

Page${js.nameType(obj.name)}Edit.prototype.show = function (params) {
  this.initialize(params);
};

Page${js.nameType(obj.name)}Edit.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
};

delete page${js.nameType(obj.name)}Edit;
page${js.nameType(obj.name)}Edit = new Page${js.nameType(obj.name)}Edit();
</script>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'FORM_LAYOUT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);

<#-------------------------------->
<#-- 【只读展示】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('READ.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '【${labelObj}】只读展示', 'READ', 'desktop/stdbiz/${app.name}/${obj.name}/view.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Read" class="card ml-2 mr-2">
  <div widget-id="widget${js.nameType(obj.name)}Read"
       widget-model-id="READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
       widget-model-name="form${js.nameType(obj.name)}Read"
       class="card-body mb-3">
  </div>
</div>

<script>
function Page${js.nameType(obj.name)}Read () {
  this.page = dom.find(''#page${js.nameType(obj.name)}Read'');
}

Page${js.nameType(obj.name)}Read.prototype.show = function (params) {
  this.initialize(params);
};

Page${js.nameType(obj.name)}Read.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
};

delete page${js.nameType(obj.name)}Read;
page${js.nameType(obj.name)}Read = new Page${js.nameType(obj.name)}Read();
</script>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('READ.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);
<#-------------------------------->
<#-- 【档案章节】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '【${labelObj}】档案章节', 'SECTION', 'desktop/stdbiz/${app.name}/${obj.name}/section.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Section" class="row mr-0 ml-0">
  <#list obj.attributes as attr>
    <#if attr.isLabelled('which') || attr.isLabelled('where') || attr.isLabelled('when')>
  <div class="col-md-6 height-200"
       widget-id="widgetChart${js.nameType(obj.name)}By${js.nameType(attr.name)}"
       widget-model-id="CHART_WRAPPER_BY_${attr.name?upper_case}.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
       widget-model-name="chart${js.nameType(obj.name)}By${js.nameType(attr.name)}">
  </div>
    </#if>
  </#list>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#if obj.isLabelled('entity') && attrIds[0].type.custom>
  <div class="col-md-12"
       widget-id="widget${js.nameType(obj.name)}"
       widget-model-options=''{"columnCount":3}''
       widget-model-id="READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
       widget-model-name="form${js.nameType(obj.name)}">
  </div>
  <#else>
  <div class="col-md-12">
    <button widget-id="button${js.nameType(obj.name)}New"
            widget-model-url=":EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
            widget-model-view="sidebar"
            class="btn btn-sm btn-new pull-right">新建</button>
  </div>
  <div class="col-md-12"
       widget-id="widget${js.nameType(obj.name)}"
       widget-model-id="PAGINATION_TABLE_AS_SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
       widget-model-name="table${js.nameType(obj.name)}">
  </div>
  </#if>
</div>

<script>
function Page${js.nameType(obj.name)}Section () {
  this.page = dom.find(''#page${js.nameType(obj.name)}Section'');
}

Page${js.nameType(obj.name)}Section.prototype.show = function (params) {
  this.initialize(params);
};

Page${js.nameType(obj.name)}Section.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
};

delete page${js.nameType(obj.name)}Section;
page${js.nameType(obj.name)}Section = new Page${js.nameType(obj.name)}Section();
</script>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'PAGINATION_TABLE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);

    <#list obj.attributes as attr>
      <#if attr.isLabelled('which') || attr.isLabelled('where') || attr.isLabelled('when')>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'CHART_WRAPPER_BY_${attr.name?upper_case}.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);
      </#if>
    </#list>

  </#if> <#--if obj.isLabelled('entity') || obj.isLabelled('value')-->

  <#if obj.isLabelled('aggregate')>
    <#assign aggregate = obj>
    <#list aggregate.attributes as attr>
      <#if attr.isLabelled('root')>
        <#assign rootAttr = attr>
        <#break>
      </#if>
    </#list>
    <#if !rootAttr?? || !rootAttr.type??><#continue></#if>
    <#if rootAttr.type.custom>
      <#assign rootObj = model.findObjectByName(rootAttr.type.name)>
      <#assign rootObjIds = modelbase.get_id_attributes(rootObj)>
    </#if>
<#-------------------------------->
<#-- 【档案展示】页面
<#-------------------------------->
delete from tn_uxd_bltwin where bltwinid = 'PROFILE.${parentApplication?upper_case}.${modelbase.get_object_module(rootObj)?upper_case}.${aggregate.name?replace('_aggregate','')?upper_case}@DESKTOP';
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('PROFILE.${parentApplication?upper_case}.${modelbase.get_object_module(rootObj)?upper_case}.${aggregate.name?replace('_aggregate','')?upper_case}@DESKTOP', '【${modelbase.get_object_label(aggregate)}】档案展示', 'PROFILE', 'desktop/stdbiz/${app.name}/${aggregate.name?replace('_aggregate','')}/profile.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${java.nameType(rootAttr.name)}Profile" class="row ml-0 mr-0">
    <#if rootObj??>
      <#assign primary = modelbase.get_object_primary(rootObj)!''>
      <#assign secondary = modelbase.get_object_secondary(rootObj)!''>
      <#assign tertiary = modelbase.get_object_tertiary(rootObj)!''>
      <#assign quaternary = modelbase.get_object_quaternary(rootObj)!''>
      <#assign avatar = modelbase.get_object_avatar(rootObj)!''>
      <#assign image = modelbase.get_object_image(rootObj)!''>
      <#assign when = modelbase.get_object_when(rootObj)!''>
      <#assign whose = modelbase.get_object_whose(rootObj)!''>
      <#assign who = modelbase.get_object_who(rootObj)!''>
      <#list rootObjIds as attrId>
  <input type="hidden" name="${modelbase.get_attribute_sql_name(attrId)}">
      </#list>
    </#if>
  <div widget-id="widgetPortrait" class="card mr-2" style="width: 300px;">
    <div class="card-body" style="text-align: center;">
    <#if avatar != ''>    
      <img widget-id="image${js.nameType(modelbase.get_attribute_sql_name(avatar))}" src="img/user.png" class="circle-128"/>
    </#if>
    <#if primary != ''>
      <h2 widget-id="text${js.nameType(modelbase.get_attribute_sql_name(primary))}" class="mt-2"></h2>
    </#if>
      <div class="text-left ml-2 mr-2">
    <#if secondary != ''>
        <p widget-id="text${js.nameType(modelbase.get_attribute_sql_name(secondary))}"></p>
    </#if>
    <#if tertiary != ''>
        <p widget-id="text${js.nameType(modelbase.get_attribute_sql_name(tertiary))}"></p>
    </#if>
        <p><i class="fas fa-mobile mr-2"></i></p>
        <p><i class="fas fa-home mr-2"></i></p>
      </div>
      <div class="text-left"> 
        <span class="badge badge-success text-white mr5 mb10 ib lh15">特征A</span> 
        <span class="badge badge-primary text-white mr5 mb10 ib lh15">特征B</span> 
        <span class="badge badge-info text-white mr5 mb10 ib lh15">特征C</span> 
      </div>
      <div class="d-flex mt-2">
        <div style="flex: 1">
          <a class="btn-link"><i class="fab fa-weixin font-20"></i></a>
        </div>
        <div style="flex: 1">
          <a class="btn-link"><i class="fas fa-comments font-20"></i></a>
        </div>
        <div style="flex: 1">
          <a class="btn-link"><i class="fa fa-user-plus font-20"></i></a>
        </div>
      </div>
    </div>
  </div>
  <div widget-id="widgetSection" class="card" style="width: calc(100% - 308px);">
    <div class="card-header">
      <div widget-id="navigator${js.nameType(aggregate.name)}" class="nav nav-tabs mt-0"></div> 
    </div>
    <div class="card-body" widget-id="content${js.nameType(aggregate.name)}">
    </div>
  </div>
</div>
<script>
function Page${js.nameType(rootAttr.name)}Profile () {
  this.page = dom.find(''#page${java.nameType(rootAttr.name)}Profile'');
}

Page${js.nameType(rootAttr.name)}Profile.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
  // 加载基本数据
  ${parentApplication}.${modelbase.get_object_module(rootObj)}.find${js.nameType(modelbase.get_object_plural(rootObj))}({
    ${modelbase.get_attribute_sql_name(rootObjIds[0])}: params.${modelbase.get_attribute_sql_name(rootObjIds[0])},
  }).then(data => {
    let row = data[0];
    <#if avatar != ''>
    this.image${js.nameType(modelbase.get_attribute_sql_name(avatar))}.src = ${appbase.get_attribute_transform_in_sql('row', avatar)};
    </#if>
    <#if primary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(primary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', primary)};
    </#if>
    <#if secondary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(secondary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', secondary)};
    </#if>
    <#if tertiary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(tertiary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', tertiary)};
    </#if>
    <#if quaternary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(quaternary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', quaternary)};
    </#if>
    <#if quinary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(quinary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', quinary)};
    </#if>
  });
  this.tabs${js.nameType(aggregate.name)} = new Tabs({
    lazy: true,
    tabActiveClass: ''active-bg-info'',
    navigatorId: this.navigator${js.nameType(aggregate.name)},
    contentId: this.content${js.nameType(aggregate.name)},
    tabs: [{
    <#assign index = 0>
    <#list aggregate.attributes as attr>
      <#assign appname = attr.getLabelledOptions('app')['name']>
      <#if attr.type.collection>
        <#assign refObj = model.findObjectByName(attr.type.componentType.name)!''>
      <#else>
        <#assign refObj = model.findObjectByName(attr.type.name)!''>
      </#if>
      <#if refObj == ''><#continue></#if>
      <#if (index > 0)>
    },{
      </#if>
      id: ''tab${js.nameType(attr.name)}'',
      text: ''${modelbase.get_object_label(refObj)}'',
      url: '':SECTION.${parentApplication?upper_case}.${appname?upper_case}.${refObj.name?upper_case}@DESKTOP'',
      success: function() {
        page${js.nameType(refObj.name)}Section.show(params);
      },
      <#assign index = index + 1>
    </#list>
    }]
  });
  this.tabs${js.nameType(aggregate.name)}.render();

  dom.height(this.widgetPortrait, 8, document.body);
  dom.height(this.widgetSection, 8, document.body);
};

Page${js.nameType(rootAttr.name)}Profile.prototype.show = function (params) {
  this.initialize(params);
};

page${js.nameType(rootAttr.name)}Profile = new Page${js.nameType(rootAttr.name)}Profile();
</script>
');

    <#if rootObj??>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('PROFILE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);
    
    </#if>

<#-------------------------------->
<#-- 【概览展示】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${aggregate.name?replace('_aggregate','')?upper_case}@DESKTOP', '【${modelbase.get_object_label(aggregate)}】概览展示', 'OUTLINE', 'desktop/stdbiz/${app.name}/${aggregate.name?replace('_aggregate','')}/outline.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${java.nameType(rootAttr.name)}Outline" class="page">
    <#if rootObj??>
      <#list rootObjIds as attrId>
  <input type="hidden" name="${modelbase.get_attribute_sql_name(attrId)}">
      </#list>
    </#if>
  <div class="card b-a-0">
    <div class="card-body pt-0">
      <div class="row mb-3"
           style="justify-content: center; background: #7aa6da; margin-right: -20px; margin-left: -20px;">
        <div class="avatar avatar-128">
          <img src="img/user.png">
        </div>
      </div>
    <#if rootObj??>
      <div class="mt-3">
        <div class="title-bordered mb-2"><strong>基本信息</strong></div>
        <div class="form form-horizontal">
      <#if primary != ''>
          <div class="form-group row m-auto">
            <label class="col-md-2 col-form-label">${modelbase.get_attribute_label(primary)}：</label>
            <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(primary))}" class="col-md-10 col-form-label"></label>
          </div>
      </#if>
      <#if secondary != ''>
          <div class="form-group row m-auto">
            <label class="col-md-2 col-form-label">${modelbase.get_attribute_label(secondary)}：</label>
            <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(secondary))}" class="col-md-10 col-form-label"></label>
          </div>
      </#if>
      <#if tertiary != ''>
          <div class="form-group row m-auto">
            <label class="col-md-2 col-form-label">${modelbase.get_attribute_label(tertiary)}：</label>
            <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(tertiary))}" class="col-md-10 col-form-label"></label>
          </div>
      </#if>
      <#if quaternary != ''>
          <div class="form-group row m-auto">
            <label class="col-md-2 col-form-label">${modelbase.get_attribute_label(quaternary)}：</label>
            <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(quaternary))}" class="col-md-10 col-form-label"></label>
          </div>
      </#if>
      <#if quinary != ''>
          <div class="form-group row m-auto">
            <label class="col-md-2 col-form-label">${modelbase.get_attribute_label(quinary)}：</label>
            <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(quinary))}" class="col-md-10 col-form-label"></label>
          </div>
      </#if>
        </div>
    </#if>
    <#list aggregate.attributes as attr>
      <#if attr.isLabelled('root')><#continue></#if>
      <#if !attr.type.collection><#continue></#if>
      <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
        <div class="mt-3">
          <div class="title-bordered mb-2"><strong>${modelbase.get_object_label(refObj)}列表</strong></div>
          <div class="col-md-12 height-200"
              widget-id="widgetList${js.nameType(attr.name)}"
              widget-model-id="LIST_VIEW.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@DESKTOP"
              widget-model-name="list${js.nameType(attr.name)}">
          </div>
        </div>
      <#list refObj.attributes as refObjAttr>
        <#if refObjAttr.isLabelled('which') || refObjAttr.isLabelled('where') || refObjAttr.isLabelled('when')>
        <div class="mt-3">  
          <div class="title-bordered mb-2"><strong>${modelbase.get_object_label(refObj)}统计</strong></div>
          <div class="col-md-12 height-200"
              widget-id="widgetChart${js.nameType(attr.name)}By${js.nameType(refObjAttr.name)}"
              widget-model-id="CHART_WRAPPER_BY_${refObjAttr.name?upper_case}.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@DESKTOP"
              widget-model-name="chart${js.nameType(attr.name)}By${js.nameType(refObjAttr.name)}">
          </div>
        </div>
        </#if>
      </#list>
    </#list>
      </div>
    </div>
  </div>
</div>
<script>
function Page${js.nameType(rootAttr.name)}Outline () {
  this.page = dom.find(''#page${java.nameType(rootAttr.name)}Outline'');
}

Page${js.nameType(rootAttr.name)}Outline.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
  // 加载基本数据
  ${parentApplication}.${modelbase.get_object_module(rootObj)}.find${js.nameType(modelbase.get_object_plural(rootObj))}({
    ${modelbase.get_attribute_sql_name(rootObjIds[0])}: params.${modelbase.get_attribute_sql_name(rootObjIds[0])},
  }).then(data => {
    let row = data[0];
    <#if avatar != ''>
    this.image${js.nameType(modelbase.get_attribute_sql_name(avatar))}.src = ${appbase.get_attribute_transform_in_sql('row', avatar)};
    </#if>
    <#if primary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(primary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', primary)};
    </#if>
    <#if secondary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(secondary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', secondary)};
    </#if>
    <#if tertiary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(tertiary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', tertiary)};
    </#if>
    <#if quaternary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(quaternary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', quaternary)};
    </#if>
    <#if quinary != ''>
    this.text${js.nameType(modelbase.get_attribute_sql_name(quinary))}.innerText = ${appbase.get_attribute_transform_in_sql('row', quinary)};
    </#if>
  });
};

Page${js.nameType(rootAttr.name)}Outline.prototype.show = function (params) {
  this.initialize(params);
};

page${js.nameType(rootAttr.name)}Outline = new Page${js.nameType(rootAttr.name)}Outline();
</script>
');

    <#if rootObj??>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', null, null, null, null);
    
    </#if>
    <#list aggregate.attributes as attr>
      <#if attr.isLabelled('root')><#continue></#if>
      <#if !attr.type.custom><#continue></#if>
      <#assign refObj = model.findObjectByName(attr.type.name)>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@DESKTOP', null, null, null, null);

    </#list>
    <#list aggregate.attributes as attr>
      <#if attr.isLabelled('root')><#continue></#if>
      <#if !attr.type.collection><#continue></#if>
      <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'PAGINATION_TABLE.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@DESKTOP', null, null, null, null);

      <#list refObj.attributes as refObjAttr>
        <#if refObjAttr.isLabelled('which') || refObjAttr.isLabelled('where') || refObjAttr.isLabelled('when')>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'CHART_WRAPPER_BY_${refObjAttr.name?upper_case}.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@DESKTOP', null, null, null, null);
        </#if>
      </#list>

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'LIST_VIEW.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@DESKTOP', null, null, null, null);

    </#list>
  </#if>

  <#if obj.getLabelledOptions('entity')['revision']??>
<#-------------------------------->
<#-- 【修订版本】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('REVISION.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '【${labelObj}】修订版本', 'REVISION', '/desktop/stdbiz/${app.name}/${obj.name}/revision.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Revision"  class="card ml-2 mr-2">
  <div widget-id="widget${js.nameType(obj.name)}" 
       widget-model-id="TIMELINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}.REVISION@DESKTOP"
       widget-model-name="timeline${js.nameType(obj.name)}Revision"
       class="card-body mb-3">
  </div>
</div>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('REVISION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'TIMELINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}.REVISION@DESKTOP', null, null, null, null);

  </#if>
  <#if obj.isLabelled('journal')>
<#-------------------------------->
<#-- 【状态日志】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('JOURNAL.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '【${labelObj}】状态日志', 'STATUS', '/desktop/stdbiz/${app.name}/${obj.name}/journal.html', 'DESKTOP', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Journal" class="card ml-2 mr-2">
  <div widget-id="widget${js.nameType(obj.name)}" 
       widget-model-id="TIMELINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}.JOURNAL@DESKTOP"
       widget-model-name="timeline${js.nameType(obj.name)}Journal"
       class="card-body mb-3">
  </div>
</div>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('JOURNAL.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', 
        'TIMELINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}.JOURNAL@DESKTOP', null, null, null, null);

  </#if>
<#----------------------------------------------------------------------------->
<#-- 组件
<#----------------------------------------------------------------------------->

<#-------------------------------->
<#-- 分页表格（主）
<#-------------------------------->
  <#if obj.isLabelled('aggregate')><#-- 聚合对象不产生下列组件 --><#continue></#if>
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('PAGINATION_TABLE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'table${js.nameType(obj.name)}List', '【${labelObj}】分页表格', 'PaginationTable', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/<#if obj.isLabelled('entity')>paginate<#else>get</#if>'',
  limit: 15,
  params: {
    state: ''E'',
  },
  columns: [{
    title: ''#'',
    style: ''text-align: center;'',
    display: function(row, td, colidx, rowidx, start) {
      td.innerText = start + rowidx + 1;
    }
  },{
  <#if when != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=when indent=4 />
  },{
  </#if>
  <#if whose != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=whose indent=4 />
  },{
  </#if>
  <#if primary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=primary indent=4 />
  },{
  </#if>
  <#if secondary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=secondary indent=4 />
  },{
  </#if>
  <#if tertiary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=tertiary indent=4 />
  },{
  </#if>
  <#if quaternary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=quaternary indent=4 />
  },{
  </#if>
  <#if quinary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=quinary indent=4 />
  },{
  </#if>
  <#if who != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=who indent=4 />
  },{
  </#if>
    title: ''操作'',
    style: ''text-align: center;'',
    display: function(row, td, rowidx, colidx) {
      <#list attrIds as attrId>
        <#if attrId.type.name == 'datetime'>
      row.${modelbase.get_attribute_sql_name(attrId)} = moment(row.${modelbase.get_attribute_sql_name(attrId)}).format(''YYYY-MM-DD HH:mm:ss'');
        </#if>
      </#list>
      // 编辑
      let edit = stdbiz.action(self.page, `
        <a class="btn text-primary"
      <#list attrIds as attrId>
        <#if attrId.type.custom>
          <#assign refObj = model.findObjectByName(attrId.type.name)>
           data-model-${obj.name?replace('_', '-')}-id="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        <#else>
           data-model-${modelbase.get_attribute_html_name(attrId)}="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        </#if>
      </#list>
           widget-model-tooltip="编辑"
           widget-model-url=":EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
           widget-model-view="sidebar">
          <i class="fa fa-edit"></i>
        </a>
      `, row);
      td.appendChild(edit);

      // 档案
      let profile = stdbiz.action(self.page, `
        <a class="btn text-primary"
      <#list attrIds as attrId>
        <#if attrId.type.custom>
           data-model-${obj.name?replace('_', '-')}-id="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        <#else>
           data-model-${modelbase.get_attribute_html_name(attrId)}="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        </#if>
      </#list>
           widget-model-tooltip="详情"
           widget-model-url=":PROFILE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
           widget-model-view="stack">
          <i class="fa fa-info-circle"></i>
        </a>
      `, row);
      td.appendChild(profile);

      // 删除
      let remove = stdbiz.action(self.page, `
        <a class="btn text-danger"
      <#list attrIds as attrId>
        <#if attrId.type.custom>
           data-model-${obj.name?replace('_', '-')}-id="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        <#else>
           data-model-${modelbase.get_attribute_html_name(attrId)}="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        </#if>
      </#list>
      <#if primary != ''>
           widget-model-tooltip="删除"
           widget-model-message="确定要删除“{{${modelbase.get_attribute_sql_name(primary)}}}”？"
      <#else>
					 widget-model-message="确定要删除此条记录？"
      </#if>
					 widget-model-topic="stdbiz/uxd/custom_element/disabled"
           widget-model-url="/api/v3/common/script/stdbiz/uxd/custom_element/disable">
          <i class="fas fa-trash-alt"></i>
        </a>
      `, row);
      td.appendChild(remove);
    }
  }],
  // 查询条件
  filter2: {
    fields: [{
      title: ''名称'',
      name: ''${js.nameVariable(obj.name)}Name'',
      input: ''text''
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

<#-------------------------------->
<#-- 分页表格（详情部分）
<#-------------------------------->
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('PAGINATION_TABLE_AS_SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'table${js.nameType(obj.name)}List', '【${labelObj}】分页表格（部分）', 'PaginationTable', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/<#if obj.isLabelled('entity')>paginate<#else>get</#if>'',
  limit: -1,
  showTop: false,
  params: {
    state: ''E'',
  },
  columns: [{
    title: ''#'',
    style: ''text-align: center;'',
    display: function(row, td, colidx, rowidx, start) {
      td.innerText = start + rowidx + 1;
    }
  },{
  <#if when != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=when indent=4 />
  },{
  </#if>
  <#if primary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=primary indent=4 />
  },{
  </#if>
  <#if secondary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=secondary indent=4 />
  },{
  </#if>
  <#if tertiary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=tertiary indent=4 />
  },{
  </#if>
  <#if quaternary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=quaternary indent=4 />
  },{
  </#if>
  <#if quinary != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=quinary indent=4 />
  },{
  </#if>
  <#if who != ''>
<@appbase.print_html_cell_in_sql obj=obj attr=who indent=4 />
  },{
  </#if>
    title: ''操作'',
    style: ''text-align: center;'',
    display: function(row, td, rowidx, colidx) {
      <#list attrIds as attrId>
        <#if attrId.type.name == 'datetime'>
      row.${modelbase.get_attribute_sql_name(attrId)} = moment(row.${modelbase.get_attribute_sql_name(attrId)}).format(''YYYY-MM-DD HH:mm:ss'');
        </#if>
      </#list>
      // 编辑
      let edit = stdbiz.action(self.page, `
        <a class="btn text-primary"
      <#list attrIds as attrId>
        <#if attrId.type.custom>
          <#assign refObj = model.findObjectByName(attrId.type.name)>
           data-model-${refObj.name?replace('_', '-')}-id="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        <#else>
           data-model-${modelbase.get_attribute_html_name(attrId)}="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        </#if>
      </#list>
           widget-model-url=":EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP"
           widget-model-view="sidebar">
          <i class="fa fa-edit"></i>
        </a>
      `, row);
      td.appendChild(edit);

      // 删除
      let remove = stdbiz.action(self.page, `
        <a class="btn text-danger"
      <#list attrIds as attrId>
        <#if attrId.type.custom>
           data-model-${obj.name?replace('_', '-')}-id="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        <#else>
           data-model-${modelbase.get_attribute_html_name(attrId)}="{{${modelbase.get_attribute_sql_name(attrId)}}}"
        </#if>
      </#list>
      <#if primary != ''>
           widget-model-message="确定要删除“{{${modelbase.get_attribute_sql_name(primary)}}}”？"
      <#else>
					 widget-model-message="确定要删除此条记录？"
      </#if>
					 widget-model-topic="stdbiz/uxd/custom_element/disabled"
           widget-model-url="/api/v3/common/script/stdbiz/uxd/custom_element/disable">
          <i class="fas fa-trash-alt"></i>
        </a>
      `, row);
      td.appendChild(remove);
    }
  }]
}
');

<#-------------------------------->
<#-- 编辑表单
<#-------------------------------->
  <#assign displayAttrs = []>
  <#list obj.attributes as attr>
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
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('FORM_LAYOUT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'form${js.nameType(obj.name)}Edit', '【${labelObj}】编辑表单', 'FormLayout', 'E', '
{
  columnCount: 1,
  save: {
    url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/save'',
    success: function(data) {
    <#list attrIds as attr>
      dom.find(''input[name=${modelbase.get_attribute_sql_name(attr)}]'', self.page).value = data.${modelbase.get_attribute_sql_name(attr)};
    </#list>
      PubSub.publish(''${parentApplication}/${app.name}/${obj.name}/saved'', data);
    },
    convert: function(data) {
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('reference')><#continue></#if>
      data.${modelbase.get_attribute_sql_name(attr)} = ''TODO'';
    </#list>
      data.modifierId = window.user.userId;
      data.modifierType = ''STDBIZ.SAM.USER'';
      data.state = ''E'';
      data.lastModifiedTime = ''now'';
      return data;
    }
  },
  read: {
    url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/<#if obj.isLabelled('entity')>read<#else>get</#if>'',
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
      url: ''/api/v3/common/script/stdbiz/${modelbase.get_object_module(refObj)}/${refObj.name}/find'',
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
      <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
    input: ''date''
      <#elseif attr.type.name == 'text' || (attr.type.length?? && (attr.type.length >= 400))>
    input: ''longtext''
      <#else>
    input: ''text''
      </#if>
    </#list>    
  }]
}
');

<#-------------------------------->
<#-- 只读展示
<#-------------------------------->
  <#assign readonlyAttrs = []>
  <#list displayAttrs as attr>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign readonlyAttrs = readonlyAttrs + [attr]>
  </#list>
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', '', '【${labelObj}】只读展示', 'ReadonlyForm', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/find'',
  columnCount: 1,
  convert: function(data) {
    if (Array.isArray(data)) {
      data = data[0];
    }
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name?index_of('enum') == 0>
    if (data.${modelbase.get_attribute_sql_name(attr)}) {
      data.${modelbase.get_attribute_sql_name(attr)} = ${parentApplication}.${app.name}.${obj.name?upper_case}_${attr.name?upper_case}[data.${modelbase.get_attribute_sql_name(attr)}];
    }
    <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
    if (data.${modelbase.get_attribute_sql_name(attr)}) {
      data.${modelbase.get_attribute_sql_name(attr)} = moment(data.${modelbase.get_attribute_sql_name(attr)}).format(''YYYY-MM-DD'');
    }
    </#if>
  </#list>
    return data;
  },
  fields: [{
    <#list readonlyAttrs as attr>
      <#if attr?index != 0>
  }, {
      </#if>
    name: ''${modelbase.get_attribute_sql_name(attr)}'',
    title: ''${modelbase.get_attribute_label(attr)}'',
    </#list>    
  }]
}
');

<#-------------------------------->
<#-- 分页栅格
<#-------------------------------->
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('PAGINATION_GRID.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'box${js.nameType(obj.name)}List', '【${labelObj}】分页卡片', 'PaginationGrid', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/<#if obj.isLabelled('entity')>paginate<#else>get</#if>'',
  limit: 15,
  colspan: 3,
  favourite: false,
  borderless: true,
  render: function(container, row, index) {
    let el = dom.templatize(`
      <div class="col-md-12">
        <div class="card border" style="min-height: 125px;">
          <div class="card-body">
            <div class="d-flex">
              <div class="pl-2">
                <strong>{{${js.nameVariable(obj.name)}Name}}</strong>
                <span class="small text-muted">{{TODO}}</span>
                <div class="small text-muted">{{TODO}}</div>
              </div>
              <div class="ml-auto">
                <img class="avatar avatar-36" src="{{avatar}}">
              </div>
            </div>
            <div class="ml-2 mt-2">
              <i class="fas fa-phone-alt mr-1"></i>
              <a class="btn-link" href="tel: {{mobile}}">{{mobile}}</a>
            </div>
          </div>
        </div>
      </div>
    `, row);
    container.appendChild(el);
  },
  filter: {
    fields: [{
      title: ''名称'',
      input: ''text'',
      name: ''${js.nameVariable(obj.name)}Name'',
    <#if primary != ''>
    },{
      title: ''${modelbase.get_attribute_label(primary)}'',
      name: ''${modelbase.get_attribute_sql_name(primary)}'',
      <#if primary.type.name == 'date' || primary.type.name == 'datetime'>
      input: ''date'',
      <#elseif primary.type.name == 'enum'>
      input: ''select'',
      values: ${parentApplication?upper_case}.${app.name?upper_case}.${primary.name?upper_case}_VALUES || [],
      <#else>
      input: ''text'',
      </#if>
    </#if>
    <#if secondary != ''>
    },{
      title: ''${modelbase.get_attribute_label(secondary)}'',
      name: ''${modelbase.get_attribute_sql_name(secondary)}'',
      <#if secondary.type.name == 'date' || secondary.type.name == 'datetime'>
      input: ''date'',
      <#elseif secondary.type.name == 'enum'>
      input: ''select'',
      values: ${parentApplication?upper_case}.${app.name?upper_case}.${secondary.name?upper_case}_VALUES || [],
      <#else>
      input: ''text'',
      </#if>
    </#if>
    <#if tertiary != ''>
    },{
      title: ''${modelbase.get_attribute_label(tertiary)}'',
      name: ''${modelbase.get_attribute_sql_name(tertiary)}'',
      <#if tertiary.type.name == 'date' || tertiary.type.name == 'datetime'>
      input: ''date'',
      <#elseif tertiary.type.name == 'enum'>
      input: ''select'',
      values: ${parentApplication?upper_case}.${app.name?upper_case}.${tertiary.name?upper_case}_VALUES || [],
      <#else>
      input: ''text'',
      </#if>
    </#if>
    }]
  }
}
');

<#-------------------------------->
<#-- 瓦片列表
<#-------------------------------->
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('LIST_VIEW.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'list${js.nameType(obj.name)}', '【${labelObj}】瓦片列表', 'ListView', 'E', '
{
  url: ''/api/v3/common/script/stdbiz/${app.name}/${obj.name}/find'',
  params: {
    state: ''E'',
  },
  create: function(idx, row) {
  <#list obj.attributes as attr>
    <#if attr.type.name == 'datetime'>
    if (row.${modelbase.get_attribute_sql_name(attr)}) {
      row.${modelbase.get_attribute_sql_name(attr)} = moment(row.${modelbase.get_attribute_sql_name(attr)}).format(''YYYY-MM-DD'');
    }
    <#elseif attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#if !refObj.isLabelled('constant')>
      row.${modelbase.get_attribute_sql_name(attr)} = row.${modelbase.get_attribute_sql_name(attr)?replace('Code','Name')};
      <#else>
      row.${modelbase.get_attribute_sql_name(attr)} = row.${modelbase.get_attribute_sql_name(attr)?replace('Id','Name')};
      </#if>
    </#if>
  </#list>
    let ret = dom.templatize(`
<@appbase.print_html_tile_in_sql obj=obj indent=4 />
    `, row);
    return ret;
  },
}
');

<#-------------------------------->
<#-- 时间线条
<#-------------------------------->
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('TIMELINE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'timeline${js.nameType(obj.name)}', '【${labelObj}】时间线条', 'Timeline', 'E', '
{
  url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(obj)}/${obj.name}/find'',
  params: {
    state: ''E'',
    <#list obj.attributes as attr>
      <#if attr.isLabelled('what') || attr.isLabelled('who')>
    ${modelbase.get_attribute_sql_name(attr)}: params.${modelbase.get_attribute_sql_name(attr)},
      </#if>
    </#list>
    <#if coll != ''>
      <#assign refObj = model.findObjectByName(coll.type.componentType.name)>
    ''//${parentApplication}/${modelbase.get_object_module(refObj)}/${refObj.name}/<#if refObj.isLabelled('entity')>find<#else>get</#if>'': {
      _source_field: ''${modelbase.get_attribute_sql_name(attrIds[0])}'',
      _target_field: ''${modelbase.get_attribute_sql_name(attrIds[0])}'',
      _hierarchy_name: ''${js.nameVariable(coll.name)}'',
    },
    </#if>
  },
  title: function(row) {
    <#if primary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=primary holder='row' indent=4/>
    </#if>
  },
  subtitle: function(row) {
    <#if when != ''>
<@appbase.print_attribute_html_return_value_in_sql attr=when holder='row' indent=4/>
    <#elseif secondary != ''>    
<@appbase.print_attribute_html_return_value_in_sql attr=secondary holder='row' indent=4/>
    <#else>
    return '''';
    </#if>
  },
  content: function(row) {
    <#if tertiary != ''>
<@appbase.print_attribute_html_return_value_in_sql attr=tertiary holder='row' indent=4/>
    <#elseif coll != ''>
      <#assign refObj = model.findObjectByName(coll.type.componentType.name)>
      <#assign refObjPrimary = modelbase.get_object_primary(refObj)!''>
      <#assign refObjSecondary = modelbase.get_object_secondary(refObj)!''>
      <#assign refObjTertiary = modelbase.get_object_tertiary(refObj)!''>
    let ret = dom.templatize(`
      <div>
      {{#each ${js.nameVariable(coll.name)}}}
        <div>
          <span>{{${modelbase.get_attribute_sql_name(refObjPrimary)}}}</span>&nbsp;&nbsp;<span>{{${modelbase.get_attribute_sql_name(refObjSecondary)}}}</span>
        </div>
      {{/each}}
      </div>
    `, row);
    return ret.innerHTML;
    <#else>
    return '''';
    </#if>
  },
}
'); 

<#if obj.getLabelledOptions('persistence')['revision']??>
<#-------------------------------->
<#-- 修订日志
<#-------------------------------->
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('TIMELINE_AS_REVISION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP.REVISION', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'timeline${js.nameType(obj.name)}Revision', '【${labelObj}】修改日志', 'Timeline', 'E', '
{
  url: ''/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/revision'',
  params: {
    state: ''E'',
  },
  title: function(row) {
    <#if primary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=primary holder='row' indent=4/>
    </#if>
  },
  subtitle: function(row) {
    <#if secondary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=secondary holder='row' indent=4/>
    </#if>
  },
  content: function(row) {
    <#if tertiary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=tertiary holder='row' indent=4/>
    </#if>
  },
}
'); 

  </#if>
  <#if obj.isLabelled('journal')>
<#-------------------------------->
<#-- 变化日志
<#-------------------------------->
insert into tn_uxd_bltelem (bltelemid, parbltelemid, refid, reftyp, bltelemnm, bltelemtxt, bltelemtyp, sta, srp)
values ('TIMELINE_AS_JOURNAL.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@DESKTOP.JOURNAL', '0', '${obj.name?upper_case}@DESKTOP', 'STDBIZ.SAM.MANAGED_ENTITY', 'timeline${js.nameType(obj.name)}Journal', '【${labelObj}】变化日志', 'Timeline', 'E', '
{
  url: ''/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/find'',
  params: {
    state: ''E'',
  },
  title: function(row) {
    <#if primary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=primary holder='row' indent=4/>
    </#if>
  },
  subtitle: function(row) {
    <#if secondary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=secondary holder='row' indent=4/>
    </#if>
  },
  content: function(row) {
    <#if tertiary == ''>
    return '''';
    <#else>
<@appbase.print_attribute_html_return_value_in_sql attr=tertiary holder='row' indent=4/>
    </#if>
  },
}
');
  </#if>

<#-------------------------------->
<#-- 统计图表
<#-------------------------------->
<@appbase.print_object_chart_sql attrDims=attrWhiches attrMetrics=attrWhos attrNumerics=attrNumerics obj=obj indent=0/>
<@appbase.print_object_chart_sql attrDims=attrWhens attrMetrics=attrWhos attrNumerics=attrNumerics obj=obj indent=0/>
<@appbase.print_object_chart_sql attrDims=attrWheres attrMetrics=attrWhos attrNumerics=attrNumerics obj=obj indent=0/>

</#list>