<#import '/$/modelbase.ftl' as modelbase>
<div id="page${js.nameType(entity.name)}Edit" class="page side">
  <div class="card">
    <div widget-id="widget${js.nameType(entity.name)}" class="card-body mb-3">
    </div>
  </div>
</div>
<#assign entityId = modelbase.get_id_attributes(entity)[0]>
<script>
function Page${js.nameType(entity.name)}Edit() {
  let self = this;
  this.page = dom.find('#page${java.nameType(entity.name)}Edit');
  this.widget${js.nameType(entity.name)} = dom.find('[widget-id=widget${js.nameType(entity.name)}]', this.page);
  this.form${js.nameType(entity.name)} = new FormLayout({
    columnCount: 1,
    save: {
      url: '/api/v3/common/script/stdbiz/${app.name}/${entity.name}/save',
      params: {
        modifierId: window.user.userId,
        modifierType: 'STDBIZ.SAM.USER'
      },
      callback: function(data) {
        // 回写标识值
        dom.find('input[name=${modelbase.get_attribute_sql_name(entityId)}]', self.widget${js.nameType(entity.name)}).value = data.${modelbase.get_attribute_sql_name(entityId)};
        // 发布保存事件
        PubSub.publish('${app.name}/${entity.name}/saved', data);
      },
      convert: function(data) {
        // 保存前转换
        return data;
      }
    },
    read: {
      url: '/api/v3/common/script/stdbiz/${app.name}/${entity.name}/read',
      params: {
        _read_children: 'true'
      },
      convert: function(data) {
<#list entity.attributes as attr>
  <#if !attr.type.custom><#continue></#if>
        if (data.${js.nameVariable(attr.name)}) {
          data.${modelbase.get_attribute_sql_name(attr)} = data.${js.nameVariable(attr.name)}.${modelbase.get_attribute_sql_name(attr)};
        }
</#list>
        return data;
      }
    },
    fields: [{
<#assign formAttrs = []>
<#list entity.attributes as attr>
  <#if attr.name == 'state' 
    || attr.name == 'last_modified_time' 
    || attr.name == 'modifier_id' 
    || attr.name == 'modifier_type'
    || attr.name == 'ordinal_position'><#continue></#if>
  <#assign formAttrs = formAttrs + [attr]>
</#list>
<#list formAttrs as attr>
  <#if attr?index != 0>
    },{
  </#if>
      name: '${modelbase.get_attribute_sql_name(attr)}',
      title: '${modelbase.get_attribute_label(attr)}',
  <#if attr.constraint.identifiable>
      input: 'hidden'
  <#elseif attr.type.name == 'string'>
    <#if attr.constraint.maxSize gt 200>
      input: 'longtext'
    <#else>
      input: 'text'
    </#if>
  <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
      input: 'date'
  <#elseif attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
      input: 'select',
      options: {
        url: '/api/v3/common/script/stdbiz/${app.name}/${refObj.name}/find',
        placeholder: '请选择...',
        fields: {value: '${java.nameVariable(refObj.name)}Id', text: '${java.nameVariable(refObj.name)}Name'}
      }
  <#else>
      input: 'text'
  </#if>
</#list>
    }]
  });
}

Page${js.nameType(entity.name)}Edit.prototype.show = function (params) {
  this.setup(params);
};

Page${js.nameType(entity.name)}Edit.prototype.setup = function (params) {
  this.form${js.nameType(entity.name)}.render(this.widget${js.nameType(entity.name)}, params);
};

page${js.nameType(entity.name)}Edit = new Page${js.nameType(entity.name)}Edit();

</script>