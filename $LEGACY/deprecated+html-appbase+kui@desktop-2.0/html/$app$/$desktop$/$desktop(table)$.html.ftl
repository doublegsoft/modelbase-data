<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#assign alias = desktop.getLabelledOptions('desktop')['alias']!desktop.name>
<#assign domainType = table.constraint.domainType.toString()>
<#assign pageType = typebase.customObjectType(domainType)>
<#assign pageDetail = pageType.getAttributeValue('detail')!''>
<#assign widgetChildren = appbase.get_page_widgets(pageType.children)>
<#list pageType.children as child>
  <#if child.type.name == 'pagination_table'>
    <#assign paginationTable = child.type>
    <#break>
  </#if>
</#list>
<div id="page${js.nameType(alias)}${js.nameType(table.name)}" class="page">
  <div class="card">
    <div class="card-header">
      <strong>
        <i class="fas fa-list pr-2"></i>${table.getLabelledOptions('table')['title']}
      </strong>
      <div class="card-header-actions">
        <a class="card-header-action" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-ellipsis-v"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-right" style="min-width: 80px;">
          <a widget-id="buttonNew" class="dropdown-item text-light pointer font-15 bg-success p-1" data-toggle="dropdown">
            <i class="fas fa-plus-square text-white ml-0"></i>新  建
          </a>
        </div>
      </div>
    </div>
    <div widget-id="widget${js.nameType(table.name)}" class="card-body"></div>
  </div>
</div>
<script>
function Page${js.nameType(alias)}${js.nameType(table.name)}() {
  let self = this;
  // 页面
  this.page = dom.find('#page${js.nameType(alias)}${js.nameType(table.name)}');
<#list widgetChildren as child>
<@appbase.js_widget_query indent=2 customObject=child pageStyle=pageType.getAttributeValue('style') />
</#list>
  this.buttonNew = dom.find('a[widget-id=buttonNew]', this.page);
  // 集合显示的表格
  <#assign url = paginationTable.getAttributeValue('data')!'/TODO'>
  <#-- 生成分页表的测试数据 -->
  ${tatabase.touch(outputRoot, url, templateRoot + '/$/data/pagination-table.ftl', paginationTable)}
  this.table${js.nameType(alias)}${js.nameType(table.name)} = new PaginationTable({
    url: '${url}',
    columns: [<#if paginationTable??>{</#if>
<#if paginationTable??>
  <#list paginationTable.children as childColumn>
    <#if childColumn?index != 0>
    },{
    </#if>
      title: '${childColumn.type.getAttributeValue('title')!'TODO'}',
      style: 'text-align: ${childColumn.type.getAttributeValue('align')!'center'};',
      display: function(row, td) {
        td.innerHTML = '';
    <#if childColumn.type.name == 'actions'>
      <#-- 特殊处理行操作按钮 -->
      <#list childColumn.type.children as childOfChildColumn>
        let ${js.nameVariable('link_' + childOfChildColumn.name)} = dom.element(`
          <a class="btn btn-link">${childOfChildColumn.type.getAttributeValue('label')!'TODO'}</a>
        `);
        dom.model(${js.nameVariable('link_' + childOfChildColumn.name)}, row);
        dom.bind(${js.nameVariable('link_' + childOfChildColumn.name)}, 'click', function() {
          let model = dom.model(this);
<@appbase.js_page_open indent=10 alias=alias page=childOfChildColumn.type.getAttributeValue('page')!'' />
        });
        td.appendChild(${js.nameVariable('link_' + childOfChildColumn.name)});
      </#list>
    <#else>
        let data = {};
<@appbase.js_widget_assemble indent=8 customObject=childColumn />
        let el = dom.templatize(`
<@appbase.html_item_widget indent=10 customObject=childColumn />
        `, data);
    <#if childColumn.type.getAttributeValue('page')??>
        dom.bind(el, 'click', function() {
<@appbase.js_page_open indent=10 alias=alias page=childColumn.type.getAttributeValue('page')!'' />
        });
    </#if>
        td.appendChild(el);
    </#if>
      }
  </#list>
</#if>   
    <#if paginationTable??>}</#if>]
  });
};

Page${js.nameType(alias)}${js.nameType(table.name)}.prototype.setup = function(params) {
  this.table${js.nameType(alias)}${js.nameType(table.name)}.render(this.widget${js.nameType(table.name)});
  // 点击【新建】
  dom.bind(this.buttonNew, 'click', function(event) {
<@appbase.js_page_open indent=4 alias=alias page=pageDetail />
    event.preventDefault();
    event.stopPropagation();
  });
};

Page${js.nameType(alias)}${js.nameType(table.name)}.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}${js.nameType(table.name)} = new Page${js.nameType(alias)}${js.nameType(table.name)}();
page${js.nameType(alias)}${js.nameType(table.name)}.show();
</script>