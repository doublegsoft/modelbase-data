<#function get_page_widgets children>
  <#local ret = []>
  <#list children as child>
    <#local ret = ret + [child]>
    <#local ret = ret + get_page_widgets(child.type.children)>
  </#list>
  <#return ret>
</#function>  

<#function should_page_get name>
  <#list model.objects as obj>
    <#if !obj.isLabelled('desktop')><#continue></#if>
    <#list obj.attributes as attr>
      <#if (obj.name + '.' + attr.name) == name || attr.name == name>
        <#return attr>
      </#if>
    </#list>
  </#list>
</#function>

<#macro js_page_open indent alias page>
  <#assign customObject = should_page_get(page)!''>
  <#if customObject != ''>
    <#assign customObjectType = typebase.customObjectType(customObject.constraint.domainType.toString())>
    <#assign customObjectStyle = customObjectType.getAttributeValue('style')!''>
    <#assign customObjectPage = customObjectType.getAttributeValue('page')!''>
    <#if customObjectStyle == 'full'>
${''?left_pad(indent)}ajax.shade({
${''?left_pad(indent)}  url: 'html/${app.name}/${alias}/${customObject.name}.html',
${''?left_pad(indent)}  success: function() {
${''?left_pad(indent)}    // TODO
${''?left_pad(indent)}  }
${''?left_pad(indent)}});
    <#elseif customObjectStyle == 'side'>
${''?left_pad(indent)}ajax.sidebar({
${''?left_pad(indent)}  url: 'html/${app.name}/${alias}/${customObject.name}.html',
${''?left_pad(indent)}  title: 'TODO',
${''?left_pad(indent)}  containerId: '#container',
${''?left_pad(indent)}  success: function() {
${''?left_pad(indent)}    // TODO
${''?left_pad(indent)}  }
${''?left_pad(indent)}});
    <#elseif customObjectStyle == 'bottom'>
${''?left_pad(indent)}ajax.bottombar({
${''?left_pad(indent)}  url: 'html/${app.name}/${alias}/${customObject.name}.html',
${''?left_pad(indent)}  title: 'TODO',
${''?left_pad(indent)}  containerId: '#container',
${''?left_pad(indent)}  success: function() {
${''?left_pad(indent)}    // TODO
${''?left_pad(indent)}  }
${''?left_pad(indent)}});
    <#elseif customObjectStyle == 'view'>
${''?left_pad(indent)}ajax.view({
${''?left_pad(indent)}  url: 'html/${app.name}/${alias}/${customObject.name}.html',
${''?left_pad(indent)}  containerId: '#container',
${''?left_pad(indent)}  success: function() {
${''?left_pad(indent)}    // TODO
${''?left_pad(indent)}  }
${''?left_pad(indent)}});
    <#elseif customObjectStyle == 'dialog'>
${''?left_pad(indent)}ajax.dialog({
${''?left_pad(indent)}  url: 'html/${app.name}/${alias}/${customObject.name}.html',
${''?left_pad(indent)}  containerId: '#container',
${''?left_pad(indent)}  success: function() {
${''?left_pad(indent)}    // TODO
${''?left_pad(indent)}  }
${''?left_pad(indent)}});
    </#if>
  </#if>
</#macro>

<#macro js_widget_assemble indent customObject>
  <#list customObject.type.getAttributeNames()![] as name>
    <#if name == 'title'><#continue></#if>
    <#assign constantValue = customObject.type.getAttributeValue(name)>
    <#if constantValue?index_of('&') == 0 && constantValue?index_of('.') != -1>
${''?left_pad(indent)}row.${constantValue?substring(1, constantValue?index_of('.'))} = row.${constantValue?substring(1, constantValue?index_of('.'))} || {};
    </#if>
  </#list>
  <#list customObject.type.getAttributeNames()![] as name>
    <#if name == 'title'><#continue></#if>
    <#assign constantValue = customObject.type.getAttributeValue(name)>
    <#if constantValue?index_of('&') == 0>
${''?left_pad(indent)}data.${js.nameVariable(name)} = row.${constantValue?substring(1)};
    <#else>
${''?left_pad(indent)}data.${js.nameVariable(name)} = '${constantValue}';
    </#if>
  </#list>
</#macro>

<#macro js_widget_declare indent customObject>
  <#assign typename = customObject.type.name!''>
  <#if typename == 'listview'>
  <#-- 生成测试数据 -->
${tatabase.touch(outputRoot, customObject.type.getAttributeValue('data'), templateRoot + '/$/data/pagination-table.ftl', customObject.type)}
${''?left_pad(indent)}this.list${js.nameType(customObject.name)} = new ListView({
${''?left_pad(indent)}  url: '${customObject.type.getAttributeValue('data')!'/TODO'}',
${''?left_pad(indent)}  create: function(len, row) {
${''?left_pad(indent)}    let data = {};
    <#list customObject.type.children as child>
<@appbase.js_widget_assemble indent=indent+4 customObject=child />
    </#list>
${''?left_pad(indent)}    let ret = dom.templatize(`
    <#list customObject.type.children as child>
<@appbase.html_item_widget indent=indent+6 customObject=child />
    </#list>
${''?left_pad(indent)}    `, data);
${''?left_pad(indent)}    return ret;
${''?left_pad(indent)}  }
${''?left_pad(indent)}});
${''?left_pad(indent)}this.list${js.nameType(customObject.name)}.render(this.widget${js.nameType(customObject.name)});
  <#elseif typename == 'pagination_table'>
${''?left_pad(indent)}this.table${js.nameType(customObject.name)} = new PaginationTable({
${''?left_pad(indent)}  
${''?left_pad(indent)}});
  <#elseif typename == 'pagination_tree'>
${''?left_pad(indent)}this.tree${js.nameType(customObject.name)} = new PaginationTree({
${''?left_pad(indent)}  
${''?left_pad(indent)}});
  <#elseif typename == 'pagination_grid'>
${''?left_pad(indent)}this.grid${js.nameType(customObject.name)} = new PaginationGrid({
${''?left_pad(indent)}  
${''?left_pad(indent)}});
  <#elseif typename == 'graph'>
${''?left_pad(indent)}this.graph${js.nameType(customObject.name)} = new PaginationGrid({
${''?left_pad(indent)}  
${''?left_pad(indent)}});
  <#elseif typename == 'form'>
${''?left_pad(indent)}this.form${js.nameType(customObject.name)} = new FormLayout({
${''?left_pad(indent)}  columnCount: 1,
${''?left_pad(indent)}  allowClose: true,
${''?left_pad(indent)}  save: {
${''?left_pad(indent)}    url: ''
${''?left_pad(indent)}  },
${''?left_pad(indent)}  read: {
${''?left_pad(indent)}    url: ''
${''?left_pad(indent)}  },
${''?left_pad(indent)}  fields: [{
    <#list customObject.type.children as child>
      <#if child?index != 0>
${''?left_pad(indent)}  },{                        
      </#if>
${''?left_pad(indent)}    name: '${js.nameVariable(child.name)}',
${''?left_pad(indent)}    title: '${child.type.getAttributeValue('label')!'TODO'}',
${''?left_pad(indent)}    input: '${child.type.name}'                          
    </#list>
${''?left_pad(indent)}  }]
${''?left_pad(indent)}});
${''?left_pad(indent)}this.form${js.nameType(customObject.name)}.render(this.widget${js.nameType(customObject.name)});
  <#elseif typename == 'chart'>
${''?left_pad(indent)}this.chart${js.nameType(customObject.name)} = new ChartWrapper({
${''?left_pad(indent)}  url: '${customObject.type.getAttributeValue('data')!'TODO'}',
${''?left_pad(indent)}  chartType: '${customObject.type.getAttributeValue('type')!'bar'}',
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
${''?left_pad(indent)}});
${''?left_pad(indent)}this.chart${js.nameType(customObject.name)}.render(this.widget${js.nameType(customObject.name)});
  </#if>
</#macro>

<#macro js_widget_query indent customObject pageStyle>
  <#assign typename = customObject.type.name!''>
  <#if typename == 'listview'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  <#elseif typename == 'pagination_table'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  <#elseif typename == 'pagination_tree'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  <#elseif typename == 'pagination_grid'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  <#elseif typename == 'graph'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  <#elseif typename == 'chart'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  <#elseif typename == 'form'>
${''?left_pad(indent)}this.widget${js.nameType(customObject.name)} = dom.find('[widget-id=widget${js.nameType(customObject.name)}]', this.page);
  </#if>
  <#if customObject.type.getAttributeValue('height')! == 'auto'>
    <#if pageStyle == 'full'>
${''?left_pad(indent)}dom.height(this.widget${js.nameType(customObject.name)}.parentElement);
    <#else>
${''?left_pad(indent)}dom.height(this.widget${js.nameType(customObject.name)}.parentElement);
    </#if>
  </#if>
</#macro>

<#macro html_widget_layout indent customObject>
  <#assign typename = customObject.type.name!''>
  <#if typename == ''>
${''?left_pad(indent)}<div class="row ml-0 mr-0">
    <#list customObject.type.children as child>
<@html_widget_layout indent=indent+2 customObject=child />
    </#list>
${''?left_pad(indent)}</div>
  <#elseif typename == 'column'>
${''?left_pad(indent)}<div class="col-md-${12 * (customObject.type.getAttributeValue('width')!'0.5')?number} col-${customObject.type.getAttributeValue('style')!'middle'}">
    <#list customObject.type.children as child>
<@html_widget_layout indent=indent+2 customObject=child />
    </#list>
${''?left_pad(indent)}</div>
  <#elseif typename == 'listview'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#elseif typename == 'chart'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#elseif typename == 'pagination_table'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#elseif typename == 'pagination_tree'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#elseif typename == 'pagination_grid'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#elseif typename == 'graph'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#elseif typename == 'form'>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  <#else>
${''?left_pad(indent)}<div class="card height-300">
${''?left_pad(indent)}  <div widget-id="widget${js.nameType(customObject.name)}" class="card-body">
    <#list customObject.type.children as child>
<@html_widget_layout indent=indent+2 customObject=child />
    </#list>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
  </#if>
</#macro>

<#------------------------------------------------------------------------------
 ###
 ### HTML
 ###
 ------------------------------------------------------------------------------>

<#macro html_item_widget indent customObject>
  <#assign typename = customObject.type.name>
  <#if typename == 'single_line'>
<@html_item_single_line indent=indent customObject=customObject />
  <#elseif typename == 'two_line'>
<@html_item_two_line indent=indent customObject=customObject />
  <#elseif typename == 'two_line_float'>
<@html_item_two_line_float indent=indent customObject=customObject />
  <#elseif typename == 'image_two_line'>
<@html_item_image_two_line indent=indent customObject=customObject />
  <#elseif typename == 'image_three_line'>
<@html_item_image_three_line indent=indent customObject=customObject />
  <#elseif typename == 'image_two_line_float'>
<@html_item_image_two_line_float indent=indent customObject=customObject />
  <#elseif typename == 'icon_link'>
<@html_item_icon_link indent=indent customObject=customObject />
  <#elseif typename == 'duration_progress'>
<@html_item_duration_progress indent=indent customObject=customObject />
  <#elseif typename == 'comparison_progress'>
<@html_item_comparison_progress indent=indent customObject=customObject />
  <#elseif typename == 'circular_progress'>
<@html_item_circular_progress indent=indent customObject=customObject />
  <#elseif typename == 'tag_head'>
<@html_item_tag_head indent=indent customObject=customObject />
  <#elseif typename == 'tag_tail'>
<@html_item_tag_tail indent=indent customObject=customObject />
  <#elseif typename == 'switch'>
<@html_item_switch indent=indent customObject=customObject />
  <#elseif typename == 'tristate'>
<@html_item_tristate indent=indent customObject=customObject />
  <#elseif typename == 'person'>
<@html_item_person indent=indent customObject=customObject />
  <#else>
<@html_item_single_line indent=indent customObject=customObject />
  </#if>
</#macro>

<#------------------------------------------------------------------------------
 ###
 ### ITEM
 ###
 ------------------------------------------------------------------------------>

<#--
 ### ------------------
 ### | title          |
 ### ------------------
 -->
<#macro html_item_single_line indent customObject>
${''?left_pad(indent)}<strong>{{{primary}}}</strong>
</#macro>

<#--
 ### -------
 ### |  _  |
 ### | |_| |
 ### -------
 -->
<#macro html_item_icon_link indent customObject>
${''?left_pad(indent)}<a class="btn btn-link">
${''?left_pad(indent)}  <i class="far fa-file"></i>
${''?left_pad(indent)}</a>
</#macro>

<#--
 ### ------------------
 ### | primary        |
 ### | secondary      |
 ### ------------------
 -->

<#macro html_item_two_line indent customObject>
${''?left_pad(indent)}<div class="pl-2">
${''?left_pad(indent)}  <div>{{{primary}}}</div>
${''?left_pad(indent)}  <div class="small text-muted">{{{secondary}}}</div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### -------------------------
 ### |  /\  | primary        |
 ### |  \/  | secondary      |
 ### -------------------------
 -->
<#macro html_item_image_two_line indent customObject>
${''?left_pad(indent)}<div class="d-flex align-items-center">
${''?left_pad(indent)}  <div class="bg-gradient-primary">
${''?left_pad(indent)}    <img src="${r'${row.'}${customObject.image!'image'}${r'}'}" style="width:56px; height: 56px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">${r'${row.'}${customObject.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">${r'${row.'}${customObject.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#-- Tertiary. Then quaternary (4), quinary (5), senary (6), septenary (7), octonary (8), nonary (9), and denary (10) -->
<#--
 ### -------------------------
 ### |  /\  | primary        |
 ### |  []  | secondary      |
 ### |  \/  | tertiary       |
 ### -------------------------
 -->
<#macro html_item_image_three_line indent customObject>
${''?left_pad(indent)}<div class="d-flex align-items-center">
${''?left_pad(indent)}  <div class="bg-gradient-primary">
${''?left_pad(indent)}    <img src="${r'${row.'}${customObject.image!'image'}${r'}'}" style="width:96px; height: 96px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">${r'${row.'}${customObject.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">${r'${row.'}${customObject.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted">${r'${row.'}${customObject.tertiary!'tertiary'}${r'}'}</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------------------------
 ### |  /\  | primary      | /\ |
 ### |  \/  | secondary    | \/ |
 ### ----------------------------
 -->
<#macro html_item_image_two_line_float indent customObject>
${''?left_pad(indent)}<div class="d-flex align-items-center">
${''?left_pad(indent)}  <div class="bg-gradient-primary">
${''?left_pad(indent)}    <img src="${r'${row.'}${customObject.image!'image'}${r'}'}" style="width:56px; height: 56px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">${r'${row.'}${customObject.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">${r'${row.'}${customObject.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="float-right position-relative" style="top: 8px; height: 26px;">
${''?left_pad(indent)}    <i class="far fa-check-circle"></i>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ---------------------
 ### | primary      | /\ |
 ### | secondary    | \/ |
 ### ---------------------
 -->
<#macro html_item_two_line_float indent customObject>
${''?left_pad(indent)}<div class="d-flex justify-content-between pl-2 full-width">
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div>{{{primary}}}</div>
${''?left_pad(indent)}    <div class="small text-muted">
${''?left_pad(indent)}      <span class="text-success">{{{secondary}}}</span>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="float-right position-relative" style="top: 8px; height: 26px;">
${''?left_pad(indent)}    <i class="far fa-check-circle"></i>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | /\ | /\ | /\ | /\ | /\ |
 ### | \/ | \/ | \/ | \/ | \/ |
 ### --------------------------
 -->
<#macro html_item_images indent customObject>
${''?left_pad(indent)}<div class="row m-auto" style="justify-content: center;">
${''?left_pad(indent)}</div>
</#macro>

<#macro html_item_image indent customObject>
${''?left_pad(indent)}<div class="avatar avatar-36 tooltip-avatar">
${''?left_pad(indent)}  <img src="${r'${row.'}${customObject.image!'image'}${r'}'}">
${''?left_pad(indent)}  <span class="tooltip-text">${r'${row.'}${customObject.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | 80%        start - end |
 ### | ==================     |
 ### --------------------------
 -->
<#macro html_item_duration_progress indent customObject>
${''?left_pad(indent)}<div>
${''?left_pad(indent)}  <div class="clearfix">
${''?left_pad(indent)}    <div class="float-left">
${''?left_pad(indent)}      <strong>${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%</strong>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}    <div class="float-right">
${''?left_pad(indent)}      <small class="text-muted">${r'${row.'}${customObject.startTime!'startTime'}${r'}'} - ${r'${row.'}${customObject.endTime!'endTime'}${r'}'}</small>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="progress progress-xs">
${''?left_pad(indent)}    <div class="progress-bar bg-${r'${row.'}${customObject.status!'status'}${r'}'}" role="progressbar" style="width: ${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${customObject.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div> 
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | primary            80% |
 ### | ==================     |
 ### --------------------------
 -->
<#macro html_item_theme_progress indent customObject>
${''?left_pad(indent)}<div class="progress-group">
${''?left_pad(indent)}  <div class="progress-group-header">
${''?left_pad(indent)}    <svg class="c-icon progress-group-icon">
${''?left_pad(indent)}      <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
${''?left_pad(indent)}    </svg>
${''?left_pad(indent)}    <div>${r'${row.'}${customObject.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="mfs-auto font-weight-bold">${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="progress-group-bars">
${''?left_pad(indent)}    <div class="progress progress-xs">
${''?left_pad(indent)}      <div class="progress-bar bg-warning" role="progressbar" style="width: ${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${customObject.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | primary ============== |
 ### |         =========      |
 ### --------------------------
 -->
<#macro html_item_comparison_progress indent customObject>
${''?left_pad(indent)}<div class="progress-group mb-4">
${''?left_pad(indent)}  <div class="progress-group-prepend">
${''?left_pad(indent)}    <span class="progress-group-text">${r'${row.'}${customObject.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="progress-group-bars">
${''?left_pad(indent)}    <div class="progress progress-xs">
${''?left_pad(indent)}      <div class="progress-bar bg-info" role="progressbar" style="width: ${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${customObject.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}    <div class="progress progress-xs">
${''?left_pad(indent)}      <div class="progress-bar bg-danger" role="progressbar" style="width: ${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${customObject.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#macro html_item_circular_progress>
${''?left_pad(indent)}<div class="progress-circle over50 p${r'${row.'}${customObject.percentage!'percentage'}${r'}'}">
${''?left_pad(indent)}  <span>${r'${row.'}${customObject.percentage!'percentage'}${r'}'}%</span>
${''?left_pad(indent)}  <div class="left-half-clipper">
${''?left_pad(indent)}    <div class="first50-bar"></div>
${''?left_pad(indent)}    <div class="value-bar"></div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------------------------
 ### | [] | primary | secondary |
 ### ----------------------------
 -->
<#macro html_item_person indent customObject>
${''?left_pad(indent)}<div class="ui yellow image label bg-info text-white">
${''?left_pad(indent)}  <img src="${r'${row.'}${customObject.image!'image'}${r'}'}" height="32">
${''?left_pad(indent)}  <span>${r'${row.'}${customObject.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}  <p class="detail">${r'${row.'}${customObject.secondary!'secondary'}${r'}'}</p>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------
 ### | |----\ |
 ### | |----/ |
 ### ----------
 -->
<#macro html_item_tag_tail indent customObject>
${''?left_pad(indent)}<div class="font-13 m-auto tag-success pt-02">
${''?left_pad(indent)}  <strong>{{{primary}}}</strong>
${''?left_pad(indent)}  <div class="tag-success-after"></div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------
 ### | /----| |
 ### | \----| |
 ### ----------
 -->
 <#macro html_item_tag_head indent customObject>
${''?left_pad(indent)}<div class="ui tag label bg-danger text-white ml-5 font-bold">{{{primary}}}</div>
</#macro>

<#------------------------------------------------------------------------------
 ###
 ### FIELD
 ###
 ------------------------------------------------------------------------------>

<#--
 ### ---------------------------
 ### |  primary  |  secondary  |
 ### ---------------------------
 -->
<#macro html_item_switch indent customObject>
${''?left_pad(indent)}<div class="text-switch">
${''?left_pad(indent)}  <label class="mb-0" data-switch=".checked">
${''?left_pad(indent)}    <input name="text-switch" type="radio" style="display: none">{{{primary}}}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}  <label class="mb-0 checked" data-switch=".checked">
${''?left_pad(indent)}    <input name="text-switch" type="radio" style="display: none">{{{secondary}}}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------------------------------------
 ### |  primary  |  secondary  |  tertiary  |
 ### ----------------------------------------
 -->
<#macro html_item_tristate indent customObject>
${''?left_pad(indent)}<div class="text-multi-switch">
${''?left_pad(indent)}  <label class="mb-0 checked" style="width: 33.3%" data-switch=".checked">
${''?left_pad(indent)}    <input type="radio" style="display: none;">{{{primary}}}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}  <label class="mb-0" style="width: 33.3%" data-switch=".checked">
${''?left_pad(indent)}    <input type="radio" style="display: none;">{{{secondary}}}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}  <label class="mb-0" style="width: 33.4%" data-switch=".checked">
${''?left_pad(indent)}    <input type="radio" style="display: none;">{{{tertiary}}}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}</div>
</#macro>

<#------------------------------------------------------------------------------
 ###
 ### BLOCK
 ###
 ------------------------------------------------------------------------------>

<#macro html_block_properties indent customObject>
${''?left_pad(indent)}<div>
${''?left_pad(indent)}  <div class="title-bordered mb-2">
${''?left_pad(indent)}    <strong>{{{title}}}</strong>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  {{#each properties}}
${''?left_pad(indent)}  <div class="form form-horizontal">
${''?left_pad(indent)}    <div class="form-group row m-auto">
${''?left_pad(indent)}      <label class="col-md-2 col-form-label">
${''?left_pad(indent)}        <i class="fas fa-phone"></i>
${''?left_pad(indent)}      </label>
${''?left_pad(indent)}      <label class="col-md-10">
${''?left_pad(indent)}        {{#if scheme}}
${''?left_pad(indent)}        <a class="btn btn-link" href="tel:18987654321">{{{value}}}</a>
${''?left_pad(indent)}        {{else}}
${''?left_pad(indent)}        <strong>{{{value}}}</strong>
${''?left_pad(indent)}        {{/if}}
${''?left_pad(indent)}      </label>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  {{/each}}
${''?left_pad(indent)}</div>
</#macro>