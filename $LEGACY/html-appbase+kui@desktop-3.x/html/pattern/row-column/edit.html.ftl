<#import '/$/modelbase.ftl' as modelbase>
<#assign masterId = modelbase.get_id_attributes(master)[0]>
<div id="page${js.nameType(master.name)}Edit" class="page side">
  <div class="card">
    <div widget-id="widget${js.nameType(master.name)}" class="card-body mb-3">
    </div>
  </div>
</div>
<script>
function Page${js.nameType(master.name)}Edit() {
  this.page = dom.find('#page${java.nameType(master.name)}Edit');
}

Page${js.nameType(master.name)}Edit.prototype.show = function (params) {
  this.initialize(params);
};

Page${js.nameType(master.name)}Edit.prototype.initialize = async function (params) {
	await stdbiz.init(this, params);
	
	this.form${js.nameType(master.name)} = new FormLayout({
    columnCount: 1,
    save: {
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(master)}/${master.name}/merge',
      params: {
        modifierId: window.user.userId,
        modifierType: 'STDBIZ.SAM.USER',
      },
      callback: function(data) {
        // 回写标识值
        dom.find('input[name=${modelbase.get_attribute_sql_name(masterId)}]', self.widget${js.nameType(master.name)}).value = data.${modelbase.get_attribute_sql_name(masterId)};
        // 发布保存事件
        PubSub.publish('stdbiz/${modelbase.get_object_module(master)}/${master.name}/saved', data);
      },
      convert: function(data) {
      	let rows = [];
<#list rows as row>
				row.push({
					${modelbase.get_attribute_sql_name(row.attrName)}: '${row.modelizedElementCode}',
					${modelbase.get_attribute_sql_name(row.attrValue)}: data[${modelbase.get_attribute_sql_name(row.attrName)}],	
  <#list row.attrConstants as attrConstant>
  				${modelbase.get_attribute_sql_name(attrConstant)}: '${row.model.constants[attrConstant.name]}',
  </#list>
				});
</#list>
      	data['||stdbiz/${modelbase.get_object_module(slave)}/${slave.name}/merge'] = {
      		${js.nameVariable(modelbase.get_object_plural(slave))}: rows,
      	};
        // 保存前转换
        return data;
      }
    },
    read: {
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(master)}/${master.name}/read',
      params: {
        _read_children: 'true'
      },
      convert: function(data) {
<#list master.attributes as attr>
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
<#list master.attributes as attr>
  <#if attr.name == 'state' || 
       attr.name == 'last_modified_time' || 
       attr.name == 'modifier_id' || 
       attr.name == 'modifier_type' || 
       attr.name == 'ordinal_position'><#continue></#if>
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
        url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(master)}/${refObj.name}/find',
        placeholder: '请选择...',
        fields: {value: '${java.nameVariable(refObj.name)}Id', text: '${java.nameVariable(refObj.name)}Name'}
      }
  <#else>
      input: 'text'
  </#if>
</#list>
    }]
  });
  this.form${js.nameType(master.name)}.render(this.widget${js.nameType(master.name)}, params);
};

page${js.nameType(master.name)}Edit = new Page${js.nameType(master.name)}Edit();

</script>