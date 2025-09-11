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

<#-------------------------------->
<#-- ToC首页
<#-------------------------------->
delete from tn_uxd_bltwin where bltwinid = 'HOME.TOC@MOBILE';
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('HOME.TOC@MOBILE', '主页', 'HOME', 'mobile/${parentApplication}/toc.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="pageHomeToC" class="page mobile">
  <div widget-id="widgetAdvertisement" class="swiper">
    <div class="swiper-wrapper">
      <div class="swiper-slide height-150">
        <img src="https://via.placeholder.com/360x150">
      </div>
      <div class="swiper-slide height-150">
        <img src="https://via.placeholder.com/360x150">
      </div>
      <div class="swiper-slide height-150">
        <img src="https://via.placeholder.com/360x150">
      </div>
    </div>
    <div class="swiper-pagination"></div>
  </div>
  <div class="square-menu">
<#assign countEntry = 0>
<#list model.objects as obj>
  <#if !obj.isLabelled('aggregate')><#continue></#if>
  <#assign attrRoot = modelbase.get_aggregate_root(obj)>
  <#if !attrRoot?? || !attrRoot.type??><#continue></#if>
  <#assign objRoot = model.findObjectByName(attrRoot.type.name)>
  <#assign countEntry = countEntry + 1>
    <a widget-id="button${js.nameType(attrRoot.type.name)}List"
       widget-model-url=":LIST.${parentApplication?upper_case}.${modelbase.get_object_module(objRoot)?upper_case}.${objRoot.name?upper_case}@MOBILE"
       widget-model-view="view"
       widget-model-container="main"
       class="entry btn">
      <div class="d-flex flex-column">
        <i class="fas fa-monument color-primary font-4xl"></i>
        <span class="font-14 color-primary mt-2">${modelbase.get_object_label(objRoot)!'功能入口'}</span>
      </div>
    </a>
</#list>  
<#if countEntry % 3 != 0>
	<#list 1..(3 - countEntry % 3) as i>  
    <div class="entry btn"></div>
  </#list>  
</#if>
  </div>
  <div widget-id="widgetPropaganda" class="swiper">
    <div class="swiper-wrapper">
      <div class="swiper-slide height-150">
        <img src="https://via.placeholder.com/240x150">
      </div>
      <div class="swiper-slide height-150">
        <img src="https://via.placeholder.com/240x150">
      </div>
      <div class="swiper-slide height-150">
        <img src="https://via.placeholder.com/240x150">
      </div>
    </div>
  </div>
  <div class="square-menu">
<#assign countEntry = 0>
<#list model.objects as obj>
  <#assign attrWhen = modelbase.get_object_when(obj)!''>
  <#assign attrWhom = modelbase.get_object_whom(obj)!''>
  <#if attrWhom == '' || attrWhen == ''><#continue></#if>
  <#assign countEntry = countEntry + 1>
    <a widget-id="button${js.nameType(obj.name)}Edit"
       widget-model-url=":EDIT.${parentApplication?upper_case}.${modelbase.get_object_module(obj)?upper_case}.${obj.name?upper_case}@MOBILE"
       widget-model-view="view"
       widget-model-container="main"
       class="entry btn">
      <div class="d-flex flex-column">
        <i class="fas fa-monument font-4xl color-primary"></i>
        <span class="font-14 color-primary mt-2">${modelbase.get_object_label(obj)!'功能入口'}</span>
      </div>
    </a>     
</#list>   
<#if countEntry % 3 != 0>
	<#list 1..(3 - countEntry % 3) as i> 
    <div class="entry btn"></div>
  </#list>    
</#if>
  </div>
  <div class="spacer" style="height: 12px; background: transparent;"></div>
  <ul class="list-group border-less">
    <li class="list-group-item">
      <div class="d-flex align-items-center">
        <div class="bg-gradient-primary mr-2">
          <img src="https://via.placeholder.com/64" style="width:56px; height: 56px">
        </div>
        <div>
          <div class="text-value text-primary font-16">标题</div>
          <div class="text-muted font-weight-bold small">这里是简介</div>
        </div>
      </div>
    </li>
    <li class="list-group-item">
      <div class="d-flex align-items-center mr-2">
        <div>
          <div class="text-value text-primary font-16">标题</div>
          <div class="text-muted font-weight-bold small">这里是简介</div>
        </div>
        <div class="bg-gradient-primary ml-auto">
          <img src="https://via.placeholder.com/64" style="width:56px; height: 56px">
        </div>
      </div>
    </li>
  </ul>
  <div class="square-menu">
<#assign countEntry = 0>
<#list model.objects as obj>
  <#assign attrStatus = modelbase.get_object_status(obj)!''>
  <#if attrStatus == '' || attrStatus.constraint.domainType.name?index_of('enum') != 0 || !model.findObjectByName(obj.name + '_journal')??><#continue></#if>
  <#assign countEntry = countEntry + 1>
    <a widget-id="button${js.nameType(obj.name)}Group"
       widget-model-url=":GROUP.${parentApplication?upper_case}.${modelbase.get_object_module(obj)?upper_case}.${obj.name?upper_case}@MOBILE"
       widget-model-view="view"
       widget-model-container="main"
       class="entry btn">
      <div class="d-flex flex-column">
        <i class="fas fa-monument font-4xl color-primary"></i>
        <span class="font-14 color-primary mt-2">${modelbase.get_object_label(obj)!'功能入口'}</span>
      </div>
    </a>
</#list>             
<#if countEntry % 3 != 0> 
  <#list 1..(3 - countEntry % 3) as i>  
    <div class="entry btn"></div>
  </#list>    
</#if>
  </div>
  <div class="spacer" style="height: 12px; background: transparent;"></div>
  <!-- 向导组件测试 -->
  <div id="wizard"></div>
  <div class="square-menu">
<#assign countEntry = 0>
<#list model.objects as obj>
  <#assign attrWheres = []>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('where')>
      <#assign attrWheres = attrWheres + [attr]>
    </#if>
  </#list>
  <#assign attrWho = modelbase.get_object_who(obj)!''>
  <#assign attrWhen = modelbase.get_object_when(obj)!''>
  <#assign attrWhom = modelbase.get_object_whom(obj)!''>
  <#if attrWheres?size == 0 || attrWho == '' || attrWhen == '' || attrWhom == ''><#continue></#if>
  <#assign countEntry = countEntry + 1>
    <a widget-id="button${js.nameType(obj.name)}Wizard"
       widget-model-url=":WIZARD.${parentApplication?upper_case}.${modelbase.get_object_module(obj)?upper_case}.${obj.name?upper_case}@MOBILE"
       widget-model-view="view"
       widget-model-container="main"
       class="entry btn">
      <div class="d-flex flex-column">
        <i class="fas fa-monument color-primary font-4xl"></i>
        <span class="font-14 color-primary mt-2">${modelbase.get_object_label(obj)!'功能入口'}</span>
      </div>
    </a>
</#list>
<#if countEntry % 3 != 0>
	<#list 1..(3 - countEntry % 3) as i>
    <div class="entry btn"></div>
  </#list> 
</#if>
  </div>
  <div class="spacer" style="height: 12px; background: transparent;"></div>
</div>
<script>
function PageHomeToC() {
  this.page = dom.find(''#pageHomeToC'');
}

PageHomeToC.prototype.show = function(params) {
  this.initialize(params);
};

PageHomeToC.prototype.initialize = async function(params) {
  let self = this;
  await stdbiz.init(this, params);

  new Swiper(this.widgetAdvertisement, {
    direction: ''horizontal'',
    loop: true,
    pagination: {
      el: ''.swiper-pagination'',
    },                                            
  });
  new Swiper(this.widgetPropaganda, {
    slidesPerView: ''auto'',
    spaceBetween: 30,
    loop: true,
  });
  
  kuim.wizard({
    container: dom.find(''#wizard''),
    steps: [{},{},{},{}],
  });
};

delete PageHomeToC;
pageHomeToC = new PageHomeToC();
pageHomeToC.show();
</script>
');

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
  <#assign avatar = modelbase.get_object_avatar(obj)!''>
  <#assign image = modelbase.get_object_image(obj)!''>
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
values ('LIST.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', '【${labelObj}】集合展示', 'LIST', 'mobile/stdbiz/${app.name}/${obj.name}/list.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}List" class="page mobile">
  <div>
    <input widget-id="textSearch" placeholder="搜索..." class="form-control">
  </div>
  <div widget-id="widget${js.nameType(obj.name)}"
       class="full-width full-height">
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

  this.list${js.nameType(obj.name)} = new ListView({
    url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(obj)}/${obj.name}/paginate'',
    params: {
      start: 0,
      limit: 20,
      state: ''E'',           
    },
    create: function (idx, row) {
<@appbase.print_object_attribute_transform_in_sql obj=obj indent=6 holder='row' />      
      let ret = dom.templatize(`
<@appbase.print_html_tile_in_sql obj=obj indent=8 />  
      `, row);
      return ret;
    },
    onClick: function(ev) {
      let li = dom.ancestor(ev.target, ''li'');
      let model = dom.model(li);
      ajax.view({
        url: '':PROFILE.${parentApplication?upper_case}.${modelbase.get_object_module(obj)?upper_case}.${obj.name?upper_case}@MOBILE'',
        containerId: ''#main'',
        success: function() {
          page${js.nameType(obj.name)}Profile.show({
    <#list attrIds as attrId>
            ${modelbase.get_attribute_sql_name(attrId)}: model.${modelbase.get_attribute_sql_name(attrId)},
    </#list>        
          });
        },
      });
    },
  });
  this.list${js.nameType(obj.name)}.render(this.widget${js.nameType(obj.name)});
};

delete page${js.nameType(obj.name)}List;
page${js.nameType(obj.name)}List = new Page${js.nameType(obj.name)}List();
</script>
');
  
<#-------------------------------->
<#-- 【分组列表】页面
<#-------------------------------->
  <#assign status = modelbase.get_object_status(obj)!''>
  <#if status != '' && status.constraint.domainType.name?index_of('enum') == 0 && model.findObjectByName(obj.name + '_journal')??>
    <#assign pairs = typebase.enumtype(status.constraint.domainType.name)>
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('GROUP.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', '【${labelObj}】分组列表', 'LIST', 'mobile/stdbiz/${app.name}/${obj.name}/list.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Group" class="page mobile">
  <div widget-id="widget${js.nameType(obj.name)}"
       class="full-width full-height">
  </div>
</div>
<script>
function Page${js.nameType(obj.name)}Group() {
  this.page = dom.find(''#page${js.nameType(obj.name)}Group'');
}

Page${js.nameType(obj.name)}Group.prototype.show = function(params) {
  this.initialize(params);
};

Page${js.nameType(obj.name)}Group.prototype.initialize = async function(params) {
  let self = this;
  await stdbiz.init(this, params);
  
  let listOptions = {
    url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(obj)}/${obj.name}/paginate'',
    params: {
      start: 0,
      limit: 20,
      state: ''E'',
    },
    create: function (idx, row) {
<@appbase.print_object_attribute_transform_in_sql obj=obj indent=6 holder='row' />      
      let ret = dom.templatize(`
<@appbase.print_html_tile_in_sql obj=obj indent=8 />  
      `, row);
      return ret;
    },
    onClick: function(ev) {
      let li = dom.ancestor(ev.target, ''li'');
      let model = dom.model(li);
      ajax.view({
        url: '':SECTION.${parentApplication?upper_case}.${modelbase.get_object_module(obj)?upper_case}.${obj.name?upper_case}_JOURNAL@MOBILE'',
        containerId: ''#main'',
        success: function() {
          page${js.nameType(obj.name)}JournalSection.show({
    <#list attrIds as attrId>
            ${modelbase.get_attribute_sql_name(attrId)}: model.${modelbase.get_attribute_sql_name(attrId)},
    </#list>        
          });
        },
      });
    },
  };
  
  kuim.tabs({
    container: this.widget${js.nameType(obj.name)},
    tabs:[{
    <#list pairs as pair>
      <#if pair?index != 0>
    },{
      </#if>
      title: ''${pair.value}'',
      params: {status: ''${pair.key}''},
      render: (container, params) => {
        let list = new ListView(listOptions);
        list.render(container, params);
      },
    </#list>
    }],
  });
};

delete page${js.nameType(obj.name)}Group;
page${js.nameType(obj.name)}Group = new Page${js.nameType(obj.name)}Group();
</script>
');
  </#if>
  
<#-------------------------------->
<#-- 【向导组合】页面
<#-------------------------------->
  <#assign attrWheres = []>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('where')>
      <#assign attrWheres = attrWheres + [attr]>
    </#if>
  </#list>
  <#assign attrWho = modelbase.get_object_who(obj)!''>
  <#assign attrWhen = modelbase.get_object_when(obj)!''>
  <#assign attrWhom = modelbase.get_object_whom(obj)!''>
  <#if attrWheres?size != 0 && attrWho != '' && attrWhen != '' && attrWhom != ''>
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('WIZARD.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', '【${labelObj}】向导组合', 'WIZARD', 'mobile/stdbiz/${app.name}/${obj.name}/wizard.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Wizard" class="page mobile overflow-hidden">
  <div widget-id="widget${js.nameType(obj.name)}" class="full-width full-height">
  </div>
</div>
<script>
function Page${js.nameType(obj.name)}Wizard() {
  this.page = dom.find(''#page${js.nameType(obj.name)}Wizard'');
}

Page${js.nameType(obj.name)}Wizard.prototype.show = function(params) {
  this.initialize(params);
};

Page${js.nameType(obj.name)}Wizard.prototype.initialize = async function(params) {
  let self = this;
  await stdbiz.init(this, params);
  
  let wizard = kuim.wizard({
    container: this.widget${js.nameType(obj.name)},
    steps:[{
    <#list attrWheres as attrWhere>
      <#assign objWhere = model.findObjectByName(attrWhere.type.name)>
      <#if attrWhere?index != 0>
    },{
      </#if>
      params: {},
      render: (container, params) => {
        let list = new ListView({
          url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(objWhere)}/${objWhere.name}/find'',
          params: {
            state: ''E'',
          },
          create: function (idx, row) {
<@appbase.print_object_attribute_transform_in_sql obj=objWhere indent=12 holder='row' />      
            let ret = dom.templatize(`
<@appbase.print_html_tile_in_sql obj=objWhere indent=12 />                 
            `, row);
            return ret;
          },
          onClick: function(ev) {
            wizard.slideTo(${attrWhere?index + 1}, 400, true);
          },
        });
        list.render(container, params);
        list.setHeight(window.innerHeight - 48);
      },
    </#list>
    <#assign objWho = model.findObjectByName(attrWho.type.name)>
    },{
      params: {},
      render: (container, params) => {
        let list = new ListView({
          url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(objWho)}/${objWho.name}/find'',
          params: {
            state: ''E'',
          },
          create: function (idx, row) {
<@appbase.print_object_attribute_transform_in_sql obj=objWho indent=12 holder='row' />      
            let ret = dom.templatize(`
<@appbase.print_html_tile_in_sql obj=objWho indent=14 />   
            `, row);
            return ret;
          },
          onClick: function(ev) {
            wizard.slideTo(${attrWheres?size + 1}, 400, true);
          },
        });
        list.render(container, params);
        list.setHeight(window.innerHeight - 48);
      },
    },{
      params: {},
      render: (container, params) => {
        let el = dom.create(''div'', ''full-width'');
        el.style.height = (window.innerHeight - 48) + ''px'';
        let dates = dom.element(`
          <div class="swiper">
            <div class="swiper-wrapper">
              <div class="swiper-slide" style="height: 36px;">
                12月01日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月02日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月03日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月04日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月05日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月06日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月07日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月08日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月09日
              </div>
              <div class="swiper-slide" style="height: 36px;">
                12月10日
              </div>
            </div>
          </div>  
        `);
        el.appendChild(dates);
        container.appendChild(el);
        
        new Swiper(dates, {
          slidesPerView: 7,
          direction: ''horizontal'',
        });
      },
    }],
  });
};

delete page${js.nameType(obj.name)}Wizard;
page${js.nameType(obj.name)}Wizard = new Page${js.nameType(obj.name)}Wizard();
</script>
');
  </#if>

<#-------------------------------->
<#-- 【信息编辑】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', '【${labelObj}】信息编辑', 'EDIT', 'mobile/stdbiz/${app.name}/${obj.name}/edit.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Edit" class="page mobile">
  <div class="card ml-2 mr-2">
    <div widget-id="widget${js.nameType(obj.name)}Edit"
         class="card-body">
      <div class="form-horizontal">
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable || modelbase.is_attribute_system(attr)><#continue></#if>
    <#if attr.isLabelled('whom')><#continue></#if>
        <div class="row">
          <label class="col-4 col-form-label">${modelbase.get_attribute_label(attr)}</label>
          <div class="col-8 input-group">
    <#if attr.type.name == 'date' || attr.type.name == 'datetime'>
            <input name="${modelbase.get_attribute_sql_name(attr)}" format="yyyy-mm-dd" class="calendars form-control" placeholder="请选择...">
            <span><i class="fas fa-angle-down"></i></span>
    <#elseif attr.type.custom>
            <input name="${modelbase.get_attribute_sql_name(attr)}" class="form-control" placeholder="请选择..." readonly>
            <span><i class="fas fa-angle-down"></i></span>
    <#elseif attr.type.name?index_of('enum') == 0>
            <input name="${modelbase.get_attribute_sql_name(attr)}" class="form-control" placeholder="请选择..." readonly>
            <span><i class="fas fa-angle-down"></i></span>
    <#elseif attr.type.name == 'bool'>
            <div class="col-md-4 col-form-label">
              <div class="form-check form-check-inline">
                <input id="radio_${modelbase.get_attribute_sql_name(attr)}_T" name="${modelbase.get_attribute_sql_name(attr)}" value="T" type="radio" class="form-check-input radio color-primary is-outline" checked>
                <label class="form-check-label" for="radio_${modelbase.get_attribute_sql_name(attr)}_T">是</label>
              </div>
              <div class="form-check form-check-inline">
                <input id="radio_${modelbase.get_attribute_sql_name(attr)}_F" name="${modelbase.get_attribute_sql_name(attr)}" value="F" type="radio" class="form-check-input radio color-primary is-outline">
                <label class="form-check-label" for="radio_${modelbase.get_attribute_sql_name(attr)}_F">否</label>
              </div>
            </div>
    <#else>
            <input name="${modelbase.get_attribute_sql_name(attr)}" class="form-control" placeholder="请输入...">
      <#if attr.getLabelledOptions('name')['unit']??>
            <span>${attr.getLabelledOptions('name')['unit']}</span>
      </#if>
    </#if>
          </div>
        </div>
  </#list>
      </div>
      <button class="btn btn-primary full-width" style="height: 40px; font-size: 16px; font-weight: bold;">提  交</button>
    </div>
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
  
  // 初始化日期控件
  new Calendar();
  // 初始化下拉选择
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable || modelbase.is_attribute_system(attr)><#continue></#if>
    <#if attr.isLabelled('whom')><#continue></#if>
    <#if !attr.type.custom><#continue></#if>
    <#assign refObj = model.findObjectByName(attr.type.name)>
  kuim.select({
    url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(refObj)}/${refObj.name}/<#if refObj.isLabelled('value')>get<#else>find</#if>'',
    fieldId: ''${modelbase.get_attribute_sql_name(modelbase.get_id_attributes(refObj)[0])}'',
    fieldName: ''${modelbase.get_attribute_sql_name(modelbase.get_id_attributes(refObj)[0])?replace('Id','Name')?replace('Code','Name')}'',
    title: ''${modelbase.get_object_label(refObj)}'',
    trigger: ''input[name=${modelbase.get_attribute_sql_name(attr)}]'',
    onSelected: data => {
      this.${modelbase.get_attribute_sql_name(attr)}.value = data.value;
    },
  });
  </#list>
};

delete page${js.nameType(obj.name)}Edit;
page${js.nameType(obj.name)}Edit = new Page${js.nameType(obj.name)}Edit();
</script>
');

insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('EDIT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', 
        'FORM_LAYOUT.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', null, null, null, null);

<#-------------------------------->
<#-- 【只读展示】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('READ.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', '【${labelObj}】只读展示', 'READ', 'mobile/stdbiz/${app.name}/${obj.name}/view.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Read" class="page mobile">
  <div class="card b-a-0">
    <div widget-id="widget${js.nameType(obj.name)}Read" class="card-body">
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable || modelbase.is_attribute_system(attr)><#continue></#if>
      <div class="row ml-0 mr-0">
        <label class="col-form-label col-4">${modelbase.get_attribute_label(attr)}：</label>
    <#if attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#if refObj.isLabelled('constant')>
        <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(attr))?replace('Code','Name')}" class="col-form-label col-8"></label>
      <#else>
        <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(attr))?replace('Id','Name')}" class="col-form-label col-8"></label>
      </#if>
    <#else>
        <label widget-id="text${js.nameType(modelbase.get_attribute_sql_name(attr))}" class="col-form-label col-8"></label>
    </#if>
      </div>
  </#list>
    </div>
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
  // 读取数据
  ${parentApplication}.${app.name}.find${js.nameType(modelbase.get_object_plural(obj))}(params).then(data => {
    if (data.length == 0) return;
    let row = data[0];
<@appbase.print_object_attribute_transform_in_sql obj=obj indent=4 holder='row' />  
    <#list obj.attributes as attr>
      <#if attr.constraint.identifiable || modelbase.is_attribute_system(attr)><#continue></#if>
      <#if attr.type.custom>
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))?replace('Id','Name')}.innerText = row.${modelbase.get_attribute_sql_name(attr)?replace('Id','Name')};
      <#else>
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerText = row.${modelbase.get_attribute_sql_name(attr)}<#if attr.getLabelledOptions('name')['unit']??> + ''${attr.getLabelledOptions('name')['unit']}''</#if>;
      </#if>
    </#list>  
  });
};

delete page${js.nameType(obj.name)}Read;
page${js.nameType(obj.name)}Read = new Page${js.nameType(obj.name)}Read();
</script>
');

<#-------------------------------->
<#-- 【档案章节】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('SECTION.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', '【${labelObj}】档案章节', 'SECTION', 'mobile/stdbiz/${app.name}/${obj.name}/section.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${js.nameType(obj.name)}Section" class="row mr-0 ml-0">
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <div widget-id="widget${js.nameType(obj.name)}" class="col-md-12">
  </div>
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
  
  <#if when != ''><#-- 时间线风格展示 -->
  this.timeline${js.nameType(obj.name)} = new Timeline({
    url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled('value')>get<#else>find</#if>'',
    params: params,
    title: function(row) {
    <#if when != ''>
<@appbase.print_attribute_html_return_value_in_sql attr=when holder='row' indent=6 />
    <#elseif primary != ''>    
<@appbase.print_attribute_html_return_value_in_sql attr=primary holder='row' indent=6 />
    <#else>
      return '''';
    </#if>                           
    },                      
    subtitle: function(row) {
    <#if secondary != ''>    
<@appbase.print_attribute_html_return_value_in_sql attr=secondary holder='row' indent=6 />
    <#else>
      return '''';
    </#if>
    },             
    content: function(row) {
<@appbase.print_object_attribute_transform_in_sql obj=obj indent=6 holder='row' /> 
      let ret = dom.templatize(`
        <div class="form-horizontal row">
    <#list obj.attributes as attr>
      <#if attr.constraint.identifiable><#continue></#if>
      <#if modelbase.is_attribute_system(attr)><#continue></#if>
          <label class="col-4 col-form-label">${modelbase.get_attribute_label(attr)}</label>
          <label class="col-8 col-form-label">{{${modelbase.get_attribute_sql_name(attr)?replace('Id','Name')?replace('Code','Name')}}}<#if attr.getLabelledOptions('name')['unit']??>${attr.getLabelledOptions('name')['unit']}</#if></label>
    </#list>
        </div>
      `, row);
      return ret;
    },                               
  });
  this.timeline${js.nameType(obj.name)}.render(this.widget${js.nameType(obj.name)}, params);
  <#else><#-- 列表卡片风格展示 -->
  this.list${js.nameType(obj.name)} = new ListView({
    url: ''/api/v3/common/script/${parentApplication}/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled('value')>get<#else>find</#if>'',
    params: params,
    create: (idx, row) => {
<@appbase.print_object_attribute_transform_in_sql obj=obj indent=6 holder='row' /> 
      let ret = dom.templatize(`
        <div class="card mb-0">
          <div class="card-body">
            <h5 class="card-title"><#if primary != ''>{{${modelbase.get_attribute_sql_name(primary)?replace('Id','Name')?replace('Code','Name')}}}<#else></#if></h5>
            <h6 class="card-subtitle mb-2"><#if secondary != ''>{{${modelbase.get_attribute_sql_name(secondary)?replace('Id','Name')?replace('Code','Name')}}}<#else></#if></h6>
            <div class="form-horizontal row">
    <#list obj.attributes as attr>
      <#if attr.constraint.identifiable><#continue></#if>
      <#if modelbase.is_attribute_system(attr)><#continue></#if>
              <label class="col-4 col-form-label">${modelbase.get_attribute_label(attr)}</label>
              <label class="col-8 col-form-label">{{${modelbase.get_attribute_sql_name(attr)?replace('Id','Name')?replace('Code','Name')}}}<#if attr.getLabelledOptions('name')['unit']??>${attr.getLabelledOptions('name')['unit']}</#if></label>
    </#list>
            </div>
          </div>
        </div>
      `, row);
      return ret;
    },
  });
  this.list${js.nameType(obj.name)}.render(this.widget${js.nameType(obj.name)}, params);
  </#if>
};

delete page${js.nameType(obj.name)}Section;
page${js.nameType(obj.name)}Section = new Page${js.nameType(obj.name)}Section();
</script>
');
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
<#-- 【档案全貌】页面
<#-------------------------------->
delete from tn_uxd_bltwin where bltwinid = 'PROFILE.${parentApplication?upper_case}.${modelbase.get_object_module(rootObj)?upper_case}.${aggregate.name?replace('_aggregate','')?upper_case}@MOBILE';
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('PROFILE.${parentApplication?upper_case}.${modelbase.get_object_module(rootObj)?upper_case}.${aggregate.name?replace('_aggregate','')?upper_case}@MOBILE', '【${modelbase.get_object_label(aggregate)}】档案展示', 'PROFILE', 'mobile/stdbiz/${app.name}/${aggregate.name}/profile.html', 'MOBILE', '${app.name?upper_case}', 'E', '
<div id="page${java.nameType(rootAttr.name)}Profile" class="page mobile">
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
  <nav id="nav${java.nameType(rootAttr.name)}Profile" class="profile-nav" role="navigation">
    <a widget-id="buttonToggle" href="#nav${java.nameType(rootAttr.name)}Profile" class="profile-nav-toggle bg-success text-white" role="button"
       aria-expanded="false" aria-controls="menu${java.nameType(rootAttr.name)}Profile">
      <svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50">
        <g>
          <line class="menu-icon-bar" x1="13" y1="16.5" x2="37" y2="16.5"/>
          <line class="menu-icon-bar" x1="13" y1="24.5" x2="37" y2="24.5"/>
          <line class="menu-icon-bar" x1="13" y1="24.5" x2="37" y2="24.5"/>
          <line class="menu-icon-bar" x1="13" y1="32.5" x2="37" y2="32.5"/>
          <circle class="menu-icon-circle" r="23" cx="25" cy="25" />
        </g>
      </svg>
    </a>
    <div id="menu${java.nameType(rootAttr.name)}Profile" class="profile-nav-menu square-menu mt-3" aria-label="content navigation" hidden>
    <#assign countEntry = 0>
    <#list aggregate.attributes as attr>
      <#assign appname = attr.getLabelledOptions('app')['name']>
      <#if attr.type.collection>
        <#assign refObj = model.findObjectByName(attr.type.componentType.name)!''>
      <#else>
        <#assign refObj = model.findObjectByName(attr.type.name)!''>
      </#if>
      <#if refObj == ''><#continue></#if>
      <a widget-id="button${js.nameType(refObj.name)}" class="profile-nav-item entry btn"
      <#if !attr.type.collection>
         widget-model-url=":READ.${parentApplication?upper_case}.${modelbase.get_object_module(refObj)?upper_case}.${refObj.name?upper_case}@MOBILE"
      <#else>
         widget-model-url=":SECTION.${parentApplication?upper_case}.${modelbase.get_object_module(refObj)?upper_case}.${refObj.name?upper_case}@MOBILE"
      </#if>
         widget-model-view="view"
         widget-model-container="[widget-id=widgetContent]"
         widget-model-callback="page${js.nameType(rootAttr.name)}Profile.onLoadedPage(''${modelbase.get_object_label(refObj)}'')">
        <div class="d-flex flex-column">
          <i class="fas fa-monument text-white font-24"></i>
          <span class="font-14 text-white mt-2">${modelbase.get_object_label(refObj)}</span>
        </div>
      </a>
      <#assign countEntry = countEntry + 1>
    </#list>
    <#list 0..(countEntry % 3) as i>
      <div class="profile-nav-item entry btn"></div>
    </#list>
    </div>
    <div class="splash"></div>
  </nav>
  <div widget-id="widgetSection" class="card" role="content">
    <div class="card-header pr-3 pl-3">
      <strong widget-id="widgetTitle"></strong>
    </div>
    <div widget-id="widgetContent" class="card-body"></div>
  </div>
</div>
<script>
function Page${js.nameType(rootAttr.name)}Profile () {
  this.page = dom.find(''#page${java.nameType(rootAttr.name)}Profile'');
}

Page${js.nameType(rootAttr.name)}Profile.prototype.initialize = async function (params) {
  params.patientId = params.pregnantId;
  await stdbiz.init(this, params);

  ajax.view({
    url: '':READ.${parentApplication?upper_case}.${modelbase.get_object_module(rootObj)?upper_case}.${rootObj.name?upper_case}@MOBILE'',
    containerId: this.widgetContent,
    success: function() {
      page${js.nameType(rootAttr.name)}Read.show(params);
    }
  });
  this.widgetTitle.innerText = ''基本信息'';

  const nav = document.querySelector(''.profile-nav'');
  const menu = document.querySelector(''.profile-nav-menu'');

  let isMenuOpen = false;
  this.buttonToggle.addEventListener(''click'', ev => {
    ev.preventDefault();
    ev.stopPropagation();
    isMenuOpen = !isMenuOpen;

    // toggle a11y attributes and active class
    this.buttonToggle.setAttribute(''aria-expanded'', String(isMenuOpen));
    menu.hidden = !isMenuOpen;
    this.widgetSection.hidden = isMenuOpen;
    nav.classList.toggle(''profile-nav--open'');
  });
};

Page${js.nameType(rootAttr.name)}Profile.prototype.onLoadedPage = function(title) {
  page${js.nameType(rootAttr.name)}Profile.buttonToggle.click();
  page${js.nameType(rootAttr.name)}Profile.widgetTitle.innerText = title;
};

Page${js.nameType(rootAttr.name)}Profile.prototype.show = function (params) {
  this.initialize(params);
};

page${js.nameType(rootAttr.name)}Profile = new Page${js.nameType(rootAttr.name)}Profile();
</script>
');

    <#if rootObj??>
insert into tv_uxd_bltwinelem (bltwinid, bltelemid, pos, sz, val, ordpos)
values ('PROFILE.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', 
        'READONLY_FORM.${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}@MOBILE', null, null, null, null);
    
    </#if>

<#-------------------------------->
<#-- 【概览展示】页面
<#-------------------------------->
insert into tn_uxd_bltwin (bltwinid, bltwinnm, bltwintyp, pth, dev, cat, sta, srp)
values ('OUTLINE.${parentApplication?upper_case}.${app.name?upper_case}.${aggregate.name?replace('_aggregate','')?upper_case}@MOBILE', '【${modelbase.get_object_label(aggregate)}】概览展示', 'OUTLINE', 'mobile/stdbiz/${app.name}/${aggregate.name?replace('_aggregate','')}/outline.html', 'MOBILE', '${app.name?upper_case}', 'E', '
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
              widget-model-id="LIST_VIEW.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@MOBILE"
              widget-model-name="list${js.nameType(attr.name)}">
          </div>
        </div>
      <#list refObj.attributes as refObjAttr>
        <#if refObjAttr.isLabelled('which') || refObjAttr.isLabelled('where') || refObjAttr.isLabelled('when')>
        <div class="mt-3">  
          <div class="title-bordered mb-2"><strong>${modelbase.get_object_label(refObj)}统计</strong></div>
          <div class="col-md-12 height-200"
              widget-id="widgetChart${js.nameType(attr.name)}By${js.nameType(refObjAttr.name)}"
              widget-model-id="CHART_WRAPPER_BY_${refObjAttr.name?upper_case}.${parentApplication?upper_case}.${app.name?upper_case}.${refObj.name?upper_case}@MOBILE"
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

  </#if><#-- if obj.isLabelled('entity') || obj.isLabelled('value') -->

</#list>