<#import '/$/modelbase.ftl' as modelbase>
<#assign masterId = modelbase.get_id_attributes(master)[0]>
<div id="page${java.nameType(master.name)}Profile" class="row ml-0 mr-0">
  <input type="hidden" name="${modelbase.get_attribute_sql_name(masterId)}">
  <div widget-id="widgetPortrait" class="card mr-2" style="width: 300px;">
    <div class="card-body" style="text-align: center;">
    </div>
  </div>
  <div widget-id="widgetSection" class="card" style="width: calc(100% - 308px);">
    <div class="card-header">
      <div widget-id="navigator${js.nameType(master.name)}" class="nav nav-tabs mt-0"></div> 
    </div>
    <div class="card-body" widget-id="content${js.nameType(master.name)}">
    </div>
  </div>
</div>
<script>
function Page${js.nameType(master.name)}Profile () {
  this.page = dom.find('#page${java.nameType(master.name)}Profile');
}

Page${js.nameType(master.name)}Profile.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
  // 加载基本数据
  stdbiz.${modelbase.get_object_module(master)}.find${js.nameType(modelbase.get_object_plural(master))}({
    ${modelbase.get_attribute_sql_name(masterId)}: params.${modelbase.get_attribute_sql_name(masterId)},
  }).then(data => {
    let row = data[0];
  });
  this.tabs${js.nameType(master.name)} = new Tabs({
    lazy: true,
    tabActiveClass: 'active-bg-info',
    navigatorId: this.navigator${js.nameType(master.name)},
    contentId: this.content${js.nameType(master.name)},
    tabs: [{
    <#assign index = 0>
    <#list slaves![] as slave>
      <#assign appname = modelbase.get_object_module(slave)>
      <#if (index > 0)>
    },{
      </#if>
      id: 'tab${js.nameType(slave.name)}',
      text: '${modelbase.get_object_label(slave)}',
      url: ':SECTION.STDBIZ.${appname?upper_case}.${slave.name?upper_case}@DESKTOP',
      success: function() {
        page${js.nameType(slave.name)}Section.show(params);
      },
      <#assign index = index + 1>
    </#list>
    }]
  });
  this.tabs${js.nameType(master.name)}.render();

  dom.height(this.widgetPortrait, 8, document.body);
  dom.height(this.widgetSection, 8, document.body);
};

Page${js.nameType(master.name)}Profile.prototype.show = function (params) {
  this.initialize(params);
};

page${js.nameType(master.name)}Profile = new Page${js.nameType(master.name)}Profile();
</script>