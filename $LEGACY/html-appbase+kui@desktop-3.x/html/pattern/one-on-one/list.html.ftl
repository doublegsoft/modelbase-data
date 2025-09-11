<#import '/$/modelbase.ftl' as modelbase>
<#assign masterId = modelbase.get_id_attributes(master)[0]>
<div id="page${java.nameType(master.name)}List" class="page">
  <div class="card">
    <div class="card-header">
      <i class="fa fa-list"></i>
      <strong>${modelbase.get_object_label(master)}列表</strong>
      <div class="card-header-actions">
        <a class="card-header-action" data-toggle="dropdown" href="#" role="button">
          <i class="fas fa-ellipsis-v"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-right" style="min-width: 80px;">
          <a widget-id="buttonNew" class="dropdown-item text-light pointer font-15 bg-success p-1">
            <i class="fas fa-plus-square text-white ml-0"></i>新  建
          </a>
        </div>
      </div>
    </div>
    <div widget-id="widget${js.nameType(master.name)}" class="card-body"></div>
  </div>
</div>
<script>
function Page${java.nameType(master.name)}List() {
  this.page = dom.find('#page${java.nameType(master.name)}List');
}

Page${java.nameType(master.name)}List.prototype.initialize = async function (params) {
	await stdbiz.init(this, params);
  let self = this;
  this.table${java.nameType(master.name)} = new PaginationTable({
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(master)}/${master.name}/paginate',
    params: {
    	state: 'E',
<#list slaves![] as slave>
			'//stdbiz/${modelbase.get_object_module(slave)}/${slave.name}/find': {
				_hierarchy_name: '${java.nameVariable(slave.plural)}',
				_source_name: '${modelbase.get_attribute_sql_name(masterId)}',
				_target_name: '${modelbase.get_attribute_sql_name(masterId)}',
			},
</#list>
    },
    columns: [{
      title: '名称',
      style: 'text-align: left',
      display: function(row, td, colIndex, rowIndex) {
        let el = dom.templatize(`
          <strong>{{${java.nameVariable(master.name)}Name}}</strong>
        `, row);
        td.appendChild(el);
      }
    },{
      title: '其他1',
      style: 'text-align: left',
      display: function(row, td, colIndex, rowIndex) {
        let el = dom.templatize(`
          <div class="pl-2">
            <div>{{{TODO}}}</div>
            <div class="small text-muted">{{{TODO}}}</div>
          </div>
        `, row);
        td.appendChild(el);
      }
    },{
      title: '其他2',
      style: 'text-align: left',
      display: function(row, td, colIndex, rowIndex) {
        let el = dom.templatize(`
          <div class="pl-2">
            <div>{{{brandName}}}</div>
            <div class="small text-muted">{{{modelNumber}}}</div>
          </div>
        `, row);
        td.appendChild(el);
      }
    },{
      title: '操作',
      display: function(row, td, colIndex, rowIndex) {
        let buttonEdit = dom.element(`
          <a class="btn btn-link"><i class="fas fa-edit"></i></a>
        `);
        dom.model(buttonEdit, row);
        dom.bind(buttonEdit, 'click', function() {
          let model = dom.model(this);
          self.edit${java.nameType(master.name)}(model);
        });
        td.appendChild(buttonEdit);

        if (row.state == 'E') {
          let buttonDisable = dom.element(`
            <a class="btn btn-link"><i class="fas fa-trash-alt text-danger"></i></a>
          `);
          dom.model(buttonDisable, row);
          dom.bind(buttonDisable, 'click', function() {
            let model = dom.model(this);
            self.disable${java.nameType(master.name)}(model);
          });
          td.appendChild(buttonDisable);
        } else if (row.state == 'D') {
          let buttonEnable = dom.element(`
            <a class="btn btn-link"><i class="fas fa-recycle text-success"></i></a>
          `);
          dom.model(buttonEnable, row);
          dom.bind(buttonEnable, 'click', function() {
            let model = dom.model(this);
            self.enable${java.nameType(master.name)}(model);
          });
          td.appendChild(buttonEnable);
        }

        let buttonMore = dom.templatize(`
          <span class="">
            <a class="btn btn-link" data-toggle="dropdown" href="#" role="button">
              <i class="fas fa-ellipsis-v"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right" style="min-width: 80px;">
              <a widget-id="buttonOther" data-model-${master.name?replace('_', '-')}-id="{{${java.nameVariable(master.name)}Id}}" 
                 class="dropdown-item text-light pointer font-15 bg-success p-1">
                <i class="fas fa-plus-square text-white ml-0"></i>其  他
              </a>
            </div>
          </span>
        `, row);
        td.appendChild(buttonMore);
      }
    }]
  });
  this.table${java.nameType(master.name)}.render(this.widget${js.nameType(master.name)}, params);

  dom.bind(this.buttonNew, 'click', function() {
    self.edit${java.nameType(master.name)}({});
  });

  PubSub('stdbiz/${modelbase.get_object_module(master)}/${master.name}/saved').subscribe(function(data) {
    page${java.nameType(master.name)}List.table${java.nameType(master.name)}.request();
  });
};

/**
 * 显示页面。
 */
Page${java.nameType(master.name)}List.prototype.show = function (params) {
  this.initialize(params);
};

/**
 * 编辑${modelbase.get_object_label(master)}信息。
 */
Page${java.nameType(master.name)}List.prototype.edit${java.nameType(master.name)} = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(master.name)}List',
    url: 'html/stdbiz/${modelbase.get_object_module(master)}/${master.name}/edit.html',
    title: params.${js.nameVariable(master.name)}Id ? params.${js.nameVariable(master.name)}Name : '新建',
    allowClose: true,
    success: function() {
      page${js.nameType(master.name)}Edit.show(params);
    }
  });
};

/**
 * 禁用${modelbase.get_object_label(master)}信息。
 */
Page${java.nameType(master.name)}List.prototype.disable${java.nameType(master.name)} = function (params) {
  let self = this;
  dialog.confirm('确定要删除【' + params.${java.nameVariable(master.name)}Name + '】?', async data => {
    await stdbiz.${modelbase.get_object_module(master)}.enable${java.nameType(master.name)}({
      ${modelbase.get_attribute_sql_name(masterId)}: params.${modelbase.get_attribute_sql_name(masterId)}
    });
    self.table${java.nameType(master.name)}.request();
  });
};

/**
 * 恢复${modelbase.get_object_label(master)}信息。
 */
Page${java.nameType(master.name)}List.prototype.enable${java.nameType(master.name)} = async function (params) {
  let self = this;
  dialog.confirm('确定要恢复【' + params.${java.nameVariable(master.name)}Name + '】?', async data => {
    await stdbiz.${modelbase.get_object_module(master)}.disable${java.nameType(master.name)}({
      ${modelbase.get_attribute_sql_name(masterId)}: params.${modelbase.get_attribute_sql_name(masterId)}
    });
    self.table${java.nameType(master.name)}.request();
  });
};

<#list master.attributes as attr>
  <#if !attr.type?? || !attr.type.collection><#continue></#if>
  <#assign attrObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign attrObjAttrIds = modelbase.get_id_attributes(attrObj)>
/**
 * 新增${modelbase.get_attribute_label(attr)}信息关联到${modelbase.get_object_label(master)}。
 */  
Page${java.nameType(master.name)}List.prototype.add${java.nameType(modelbase.get_attribute_singular(attr))} = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(master.name)}List',
    url: 'html/stdbiz-ex/${modelbase.get_object_module(master)}/${attrObj.name}/edit.html',
    title: '${modelbase.get_attribute_label(attr)}',
    allowClose: true,
    success: function() {
      page${java.nameType(attrObj.name)}Edit.show({
        ${java.nameVariable(master.name)}Id: params.${java.nameVariable(master.name)}Id
      });
    }
  });
};

/**
 * 从${modelbase.get_object_label(master)}中去掉${modelbase.get_attribute_label(attr)}信息。
 */  
Page${java.nameType(master.name)}List.prototype.remove${java.nameType(modelbase.get_attribute_singular(attr))} = function (params) {
  let self = this;
  dialog.confirm('确定要删除该条信息?', async function(data) {
    await ${parentApplication}.${app.name}.remove${java.nameType(attrObj)}({
  <#list attrObjAttrIds as attrObjAttrId>
      ${modelbase.get_attribute_sql_name(attrObjAttrId)}: params.${modelbase.get_attribute_sql_name(attrObjAttrId)},
  </#list>
    });
  });
};

/**
 * 浏览${modelbase.get_object_label(master)}中的${modelbase.get_attribute_label(attr)}信息。
 */
Page${java.nameType(master.name)}List.prototype.view${java.nameType(attr.name)} = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(master.name)}List',
    url: 'html/stdbiz/${modelbase.get_object_module(master)}/${master.name}/${attr.name}.html',
    title: '${modelbase.get_attribute_label(attr)}',
    allowClose: true,
    success: function() {
      page${java.nameType(attrObj.name)}${java.nameType(attr.name)}.show({
        ${java.nameVariable(master.name)}Id: params.${java.nameVariable(master.name)}Id
      });
    }
  });
};

</#list>
page${java.nameType(master.name)}List = new Page${java.nameType(master.name)}List();
</script>