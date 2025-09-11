<#import '/$/modelbase.ftl' as modelbase>
<#assign entityId = modelbase.get_id_attributes(entity)[0]>
<div id="page${java.nameType(entity.name)}Detail" class="page">
  <input type="hidden" name="${modelbase.get_attribute_sql_name(entityId)}">
  <div class="card">
    <div class="card-header">
      <i class="fa fa-list"></i>
      <strong>${modelbase.get_object_label(entity)}详情</strong>
      <div class="card-header-actions">
        <a class="card-header-action" data-toggle="dropdown" href="#" role="button">
          <i class="fas fa-ellipsis-v"></i>
        </a>
      </div>
    </div>
    <div widget-id="widget${js.nameType(entity.name)}" class="card-body">
      <div class="card">
        <div class="card-header">
          <strong>基本信息</strong>
          <div class="card-header-actions">
            <a class="card-header-btn" widget-id="button${js.nameType(entity.name)}BaseEdit">编辑基本信息</a>
          </div>
        </div>
        <div widget-id="widget${js.nameType(entity.name)}Base" class="card-body">
          <div class="row ml-0 mr-0">
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if attr.type.custom>
            <div class="col-lg-4 col-sm-12 row-flex">
              <span>${modelbase.get_attribute_label(attr)}：</span>
              <div widget-id="text${js.nameType(modelbase.get_attribute_sql_name(attr))?replace('Id', 'Name')}"></div>
            </div>
  <#else>
            <div class="col-lg-4 col-sm-12 row-flex">
              <span>${modelbase.get_attribute_label(attr)}：</span>
              <div widget-id="text${js.nameType(modelbase.get_attribute_sql_name(attr))}"></div>
            </div>
  </#if>
</#list>
          </div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <strong>其他信息</strong>
          <div class="card-header-actions">
            <a class="card-header-btn" widget-id="button${js.nameType(entity.name)}OtherEdit">编辑其他信息</a>
          </div>
        </div>
        <div widget-id="widget${js.nameType(entity.name)}Other" class="card-body"></div>
      </div>
<#list entity.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign componentType = attr.type.componentType>
  <#assign singular = modelbase.get_attribute_singular(attr)>
      <div class="card">
        <div class="card-header">
          <strong>${modelbase.get_attribute_label(attr)}</strong>
          <div class="card-header-actions">
            <a class="card-header-btn" widget-id="button${js.nameType(entity.name)}${js.nameType(singular)}Edit">添加${modelbase.get_attribute_label(attr)}信息</a>
          </div>
        </div>
        <div widget-id="widget${js.nameType(entity.name)}${js.nameType(attr.name)}" class="card-body"></div>
      </div>
</#list>
<#-- 反向关联 -->
<#list model.objects as obj>
  <#if obj.isLabelled('aggregate')><#continue></#if>
  <#list obj.attributes as attr>
  <#if attr.type.name != entity.name><#continue></#if>
      <div class="card">
        <div class="card-header">
          <strong>${modelbase.get_object_label(obj)}</strong>
          <div class="card-header-actions">
            <a class="card-header-btn" widget-id="button${js.nameType(entity.name)}${js.nameType(obj.name)}Edit">添加${modelbase.get_object_label(obj)}信息</a>
          </div>
        </div>
        <div widget-id="widget${js.nameType(entity.name)}${js.nameType(obj.name)}" class="card-body"></div>
      </div>
  </#list>
</#list>
    </div>
  </div>
</div>
<script>
/**
 * 构造函数，定位元素到类变量。
 */
function Page${js.nameType(entity.name)}Detail () {
  this.page = dom.find('#page${java.nameType(entity.name)}Detail');
  // 标识元素
  this.text${js.nameType(modelbase.get_attribute_sql_name(entityId))} = dom.find('input[name=${modelbase.get_attribute_sql_name(entityId)}]', this.page);
  this.widget${js.nameType(entity.name)}Base =  dom.find('[widget-id=widget${js.nameType(entity.name)}Base]', this.page);
  this.widget${js.nameType(entity.name)}Other =  dom.find('[widget-id=widget${js.nameType(entity.name)}Other]', this.page);
  // 基本信息编辑按钮
  this.button${js.nameType(entity.name)}BaseEdit =  dom.find('[widget-id=button${js.nameType(entity.name)}BaseEdit]', this.page);
  this.button${js.nameType(entity.name)}OtherEdit =  dom.find('[widget-id=button${js.nameType(entity.name)}OtherEdit]', this.page);
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if attr.type.custom>
  this.text${js.nameType(modelbase.get_attribute_sql_name(attr))?replace('Id', 'Name')}.innerHTML = dom.find('input[name=${modelbase.get_attribute_sql_name(attr)?replace('Id', 'Name')}]', this.page);
  <#else>
  this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = dom.find('input[name=${modelbase.get_attribute_sql_name(attr)}]', this.page);
  </#if>
</#list>
}

Page${js.nameType(entity.name)}Detail.prototype.initialize = function (params) {
  // 基本信息按钮绑定
  dom.bind(this.button${js.nameType(entity.name)}BaseEdit, 'click', () => {
    this.edit${js.nameType(entity.name)}Base(params);
  });
  // 其他信息按钮绑定
  dom.bind(this.button${js.nameType(entity.name)}OtherEdit, 'click', () => {
    this.edit${js.nameType(entity.name)}Other(params);
  });
};

Page${js.nameType(entity.name)}Detail.prototype.show = function (params) {
  this.initialize(params);
};

/**
 * 加载基本信息。
 */
Page${js.nameType(entity.name)}Detail.prototype.reload${js.nameType(entity.name)}Base = async function (params) {
  if (!params || !params.${js.nameVariable(entityId)}) return;
  let ${js.nameVariable(entity.name)} = await ${parentApplication}.${app.name}.read${js.nameType(entity.name)}({
    ${js.nameVariable(entityId)}: ${js.nameVariable(entityId)}
  }); 
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if attr.type.custom>
  this.text${js.nameType(modelbase.get_attribute_sql_name(attr))?replace('Id', 'Name')}.innerHTML = ${js.nameVariable(entity.name)}.${modelbase.get_attribute_sql_name(attr)?replace('Id', 'Name')} || '-';
  <#elseif attr.type.name == 'datetime'>
  if (${js.nameVariable(entity.name)}.${modelbase.get_attribute_sql_name(attr)}) {
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = moment(${js.nameVariable(entity.name)}.${modelbase.get_attribute_sql_name(attr)}).format('YYYY-MM-DD HH:mm:ss');
  } else {
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = '-';
  }
  <#else>
  this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = ${js.nameVariable(entity.name)}.${modelbase.get_attribute_sql_name(attr)} || '-';
  </#if>
</#list>
};

/**
 * 响应“编辑基本信息”按钮事件。
 */
Page${js.nameType(entity.name)}Detail.prototype.edit${js.nameType(entity.name)}Base = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(entity.name)}Detail',
    url: 'html/${parentApplication}/${app.name}/${entity.name}/edit.html',
    title: '基本信息',
    allowClose: true,
    success: function() {
      page${js.nameType(entity.name)}Edit.show(params);
    }
  });
};

/**
 * 响应“编辑其他信息”按钮事件。
 */
Page${js.nameType(entity.name)}Detail.prototype.edit${js.nameType(entity.name)}Other = function (params) {
  ajax.sidebar({
    containerId: '#page${java.nameType(entity.name)}Detail',
    url: 'html/${parentApplication}/${app.name}/${entity.name}/other.html',
    title: '其他信息',
    allowClose: true,
    success: function() {
      page${js.nameType(entity.name)}Other.show(params);
    }
  });
};

page${js.nameType(entity.name)}Detail = new Page${js.nameType(entity.name)}Detail();
</script>