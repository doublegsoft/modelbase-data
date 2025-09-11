<#import '/$/modelbase.ftl' as modelbase>
<#assign entityId = modelbase.get_id_attributes(entity)[0]>
<div id="page${java.nameType(entity.name)}List" class="page">
  <div class="card">
    <div class="card-header">
      <i class="fa fa-list"></i>
      <strong>${modelbase.get_object_label(entity)}列表</strong>
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
    <div widget-id="widget${js.nameType(entity.name)}" class="card-body"></div>
  </div>
</div>
<script>
function Page${java.nameType(entity.name)}List() {
  this.page = dom.find('#page${java.nameType(entity.name)}List');
  this.widget${js.nameType(entity.name)} = dom.find('[widget-id=widget${js.nameType(entity.name)}]', this.page);
  this.buttonNew = dom.find('[widget-id=buttonNew]', this.page);
}

Page${java.nameType(entity.name)}List.prototype.initialize = function (params) {
  let self = this;
  this.table${java.nameType(entity.name)} = new PaginationTable({
    url: '/api/v3/common/script/stdbiz/${app.name}/${entity.name}/paginate',
    columns: [{
      title: '名称',
      style: 'text-align: left',
      display: function(row, td, colIndex, rowIndex) {
        let el = dom.templatize(`
          <strong>{{${java.nameVariable(entity.name)}Name}}</strong>
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
          self.edit${java.nameType(entity.name)}(model);
        });
        td.appendChild(buttonEdit);

        if (row.state == 'E') {
          let buttonDisable = dom.element(`
            <a class="btn btn-link"><i class="fas fa-trash-alt text-danger"></i></a>
          `);
          dom.model(buttonDisable, row);
          dom.bind(buttonDisable, 'click', function() {
            let model = dom.model(this);
            self.disable${java.nameType(entity.name)}(model);
          });
          td.appendChild(buttonDisable);
        } else if (row.state == 'D') {
          let buttonEnable = dom.element(`
            <a class="btn btn-link"><i class="fas fa-recycle text-success"></i></a>
          `);
          dom.model(buttonEnable, row);
          dom.bind(buttonEnable, 'click', function() {
            let model = dom.model(this);
            self.enable${java.nameType(entity.name)}(model);
          });
          td.appendChild(buttonEnable);
        }

        let buttonMore = dom.templatize(`
          <span class="">
            <a class="btn btn-link" data-toggle="dropdown" href="#" role="button">
              <i class="fas fa-ellipsis-v"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right" style="min-width: 80px;">
              <a widget-id="buttonOther" data-model-${entity.name?replace('_', '-')}-id="{{${java.nameVariable(entity.name)}Id}}" 
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
  this.table${java.nameType(entity.name)}.render(this.widget${js.nameType(entity.name)}, params);

  dom.bind(this.buttonNew, 'click', function() {
    self.edit${java.nameType(entity.name)}({});
  });

  PubSub('${app.name}/${entity.name}/saved').subscribe(function(data) {
    page${java.nameType(entity.name)}List.table${java.nameType(entity.name)}.request();
  });
};

/**
 * 显示页面。
 */
Page${java.nameType(entity.name)}List.prototype.show = function (params) {
  this.initialize(params);
};

/**
 * 编辑${modelbase.get_object_label(entity)}信息。
 */
Page${java.nameType(entity.name)}List.prototype.edit${java.nameType(entity.name)} = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(entity.name)}List',
    url: 'html/stdbiz/${app.name}/${entity.name}/edit.html',
    title: params.${js.nameVariable(entity.name)}Id ? params.${js.nameVariable(entity.name)}Name : '新建',
    allowClose: true,
    success: function() {
      page${js.nameType(entity.name)}Edit.show(params);
    }
  });
};

/**
 * 禁用${modelbase.get_object_label(entity)}信息。
 */
Page${java.nameType(entity.name)}List.prototype.disable${java.nameType(entity.name)} = function (params) {
  let self = this;
  dialog.confirm('确定要删除【' + params.${java.nameVariable(entity.name)}Name + '】?', function(data) {
    await ${parentApplication}.${app.name}.enable${java.nameType(entity.name)}({
      ${modelbase.get_attribute_sql_name(entityId)}: params.${modelbase.get_attribute_sql_name(entityId)}
    });
    self.table${java.nameType(entity.name)}.request();
  });
};

/**
 * 恢复${modelbase.get_object_label(entity)}信息。
 */
Page${java.nameType(entity.name)}List.prototype.enable${java.nameType(entity.name)} = async function (params) {
  let self = this;
  dialog.confirm('确定要恢复【' + params.${java.nameVariable(entity.name)}Name + '】?', function(data) {
    await ${parentApplication}.${app.name}.disable${java.nameType(entity.name)}({
      ${modelbase.get_attribute_sql_name(entityId)}: params.${modelbase.get_attribute_sql_name(entityId)}
    });
    self.table${java.nameType(entity.name)}.request();
  });
};

<#list entity.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign attrObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign attrObjAttrIds = modelbase.get_id_attributes(attrObj)>
/**
 * 新增${modelbase.get_attribute_label(attr)}信息关联到${modelbase.get_object_label(entity)}。
 */  
Page${java.nameType(entity.name)}List.prototype.add${java.nameType(modelbase.get_attribute_singular(attr))} = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(entity.name)}List',
    url: 'html/stdbiz-ex/${app.name}/${attrObj.name}/edit.html',
    title: '${modelbase.get_attribute_label(attr)}',
    allowClose: true,
    success: function() {
      page${java.nameType(attrObj.name)}Edit.show({
        ${java.nameVariable(entity.name)}Id: params.${java.nameVariable(entity.name)}Id
      });
    }
  });
};

/**
 * 从${modelbase.get_object_label(entity)}中去掉${modelbase.get_attribute_label(attr)}信息。
 */  
Page${java.nameType(entity.name)}List.prototype.remove${java.nameType(modelbase.get_attribute_singular(attr))} = async function (params) {
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
 * 浏览${modelbase.get_object_label(entity)}中的${modelbase.get_attribute_label(attr)}信息。
 */
Page${java.nameType(entity.name)}List.prototype.view${java.nameType(attr.name)} = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(entity.name)}List',
    url: 'html/stdbiz-ex/${app.name}/${entity.name}/${attr.name}.html',
    title: '${modelbase.get_attribute_label(attr)}',
    allowClose: true,
    success: function() {
      page${java.nameType(attrObj.name)}${java.nameType(attr.name)}.show({
        ${java.nameVariable(entity.name)}Id: params.${java.nameVariable(entity.name)}Id
      });
    }
  });
};

</#list>
page${java.nameType(entity.name)}List = new Page${java.nameType(entity.name)}List();
</script>