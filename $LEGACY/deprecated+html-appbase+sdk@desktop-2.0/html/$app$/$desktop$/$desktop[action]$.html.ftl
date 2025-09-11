<#import '/$/modelbase.ftl' as modelbase>
<#assign action = desktop.getLabelledOptions('desktop')['action']!'home'>
<div id="page${js.nameType(desktop.name)}${js.nameType(action)}" class="row page" widget-type="Page">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
        <strong><i class="fas fa-bell pr-2"></i>TODO: 标题</strong>
        <div class="card-header-actions">
          <a class="card-header-action text-success" data-toggle="dropdown"></a>
        </div>
      </div>
      <div widget-id="widget${js.nameType(desktop.name)}" class="card-body"></div>
    </div>
  </div>
<script>

function Page${js.nameType(desktop.name)}${js.nameType(action)}() {
  this.page = dom.find('#page${js.nameType(desktop.name)}${js.nameType(action)}');
  this.widget${js.nameType(desktop.name)} = dom.find('div[widget-id=widget${js.nameType(desktop.name)}]', this.page);
<#list desktop.attributes as attr>
  <#if !attr.isLabelled('desktop')><#continue></#if>
  <#assign widgetType = attr.getLabelledOptions('desktop')['widget']>
  <#if widgetType?index_of('hscroll') == 0>
  this.hscroll${js.nameType(attr.name)} = dom.find('div[widget-id=hscroll${js.nameType(attr.name)}]', this.page);
  <#elseif widgetType?index_of('tabs') == 0>
  this.tabs${js.nameType(attr.name)} = dom.find('div[widget-id=tabs${js.nameType(attr.name)}]', this.page);
  <#elseif widgetType?index_of('listview') == 0>
  this.list${js.nameType(attr.name)} = dom.find('div[widget-id=list${js.nameType(attr.name)}]', this.page);
  </#if>
</#list>
}
<#list desktop.attributes as attr>
  <#if !attr.isLabelled('desktop')><#continue></#if>
  <#assign widgetType = attr.getLabelledOptions('desktop')['widget']>
  <#if widgetType?index_of('listview') == 0>
    <#-- FIXME  -->
    <#assign itemType = widgetType?substring(widgetType?index_of('<') + 1, widgetType?index_of('>'))>
    <#assign sourceModel = attr.getLabelledOptions('source')['model']>
    <#assign querybaseInstance = querybase.parse(sourceModel)>

/**
 * 从后台获取【${modelbase.get_attribute_label(attr)!'TODO'}】数据渲染【${modelbase.get_attribute_label(attr)!'TODO'}】列表.
 */
Page${js.nameType(desktop.name)}${js.nameType(action)}.prototype.render${js.nameType(attr.name)} = function(params) {
  let self = this;
  ${app.name}.${js.nameVariable(querybaseInstance.name)}(params, function(data) {
    for (let i = 0; i < data.length; i++) {
      self.renderItem${js.nameType(attr.name)}(data[i]);
    }
  });
};

/**
 * 渲染在列表中的【${modelbase.get_attribute_label(attr)!'TODO'}】的单项。
 */
Page${js.nameType(desktop.name)}${js.nameType(action)}.prototype.renderItem${js.nameType(attr.name)} = function(single) {
  let row = {};
  <#list querybaseInstance.select.attributes as attrSelect>
      <#if attrSelect?index == 0>
  row.primary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 1>
  row.secondary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 2>
  row.tertiary = single.${js.nameVariable(attrSelect.name)};      
      <#elseif attrSelect?index == 3>
  row.quaternary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 4>
  row.quinary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 5>
  row.senary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 6>
  row.septenary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 7>
  row.octonary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 8>
  row.novenary = single.${js.nameVariable(attrSelect.name)};
      <#elseif attrSelect?index == 9>
  row.decenary = single.${js.nameVariable(attrSelect.name)};
      </#if>
    </#list>

  let item = dom.element(`
<@appbase.html_item_widget indent=4 type=itemType model={} />
  `);
  dom.model(item, single);

  /*!
  ** 绑定单项的点击事件。
  */
  dom.bind(item, 'click', function() {
    // TODO: 此处加入事件逻辑
  });
  this.list${js.nameType(attr.name)}.appendChild(item);
};
  </#if>
</#list>

Page${js.nameType(desktop.name)}${js.nameType(action)}.prototype.setup = function(params) {
  
};

Page${js.nameType(desktop.name)}${js.nameType(action)}.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(desktop.name)}${js.nameType(action)} = new Page${js.nameType(desktop.name)}${js.nameType(action)}();
</script>
</div>