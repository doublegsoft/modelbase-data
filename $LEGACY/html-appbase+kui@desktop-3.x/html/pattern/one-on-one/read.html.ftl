<#import '/$/modelbase.ftl' as modelbase>
<#assign displayAttrs = []>
<#list master.attributes as attr>
	<#if attr.type.collection><#continue></#if>
	<#if modelbase.is_attribute_system(attr)><#continue></#if>
	<#if attr.constraint.identifiable && attr.type.custom>
		<#assign refObj = model.findObjectByName(attr.type.name)>
		<#list refObj.attributes as refObjAttr>
			<#if refObjAttr.constraint.identifiable><#continue></#if>
			<#if refObjAttr.type.collection><#continue></#if>
			<#if refObjAttr.type.custom><#continue></#if>
			<#if refObjAttr.name == 'state'><#continue></#if>
			<#if refObjAttr.name == 'last_modified_time'><#continue></#if>
			<#assign displayAttrs = displayAttrs + [refObjAttr]>
		</#list>
		<#continue>
	</#if>
	<#assign displayAttrs = displayAttrs + [attr]>
</#list>
<#assign readonlyAttrs = []>
<#list displayAttrs as attr>
	<#if attr.constraint.identifiable><#continue></#if>
	<#assign readonlyAttrs = readonlyAttrs + [attr]>
</#list>
<div id="page${js.nameType(master.name)}Read" class="card ml-2 mr-2">
  <div widget-id="widget${js.nameType(master.name)}Read"
       class="card-body mb-3">
  </div>
</div>

<script>
function Page${js.nameType(master.name)}Read () {
  this.page = dom.find('#page${js.nameType(master.name)}Read');
}

Page${js.nameType(master.name)}Read.prototype.show = function (params) {
  this.initialize(params);
};

Page${js.nameType(master.name)}Read.prototype.initialize = async function (params) {
  await stdbiz.init(this, params);
  
  this.form${js.nameType(master.name)}Read = new ReadonlyForm({
		url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(master)}/${master.name}/find',
		columnCount: 1,
		convert: function(data) {
			if (Array.isArray(data)) {
				data = data[0];
			}
  <#list master.attributes as attr>
    <#if attr.constraint.domainType.name?index_of('enum') == 0>
			if (data.${modelbase.get_attribute_sql_name(attr)}) {
				data.${modelbase.get_attribute_sql_name(attr)} = ${parentApplication}.${app.name}.${master.name?upper_case}_${attr.name?upper_case}[data.${modelbase.get_attribute_sql_name(attr)}];
			}
    <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
			if (data.${modelbase.get_attribute_sql_name(attr)}) {
				data.${modelbase.get_attribute_sql_name(attr)} = moment(data.${modelbase.get_attribute_sql_name(attr)}).format('YYYY-MM-DD');
			}
    </#if>
  </#list>
			return data;
		},
		fields: [{
	<#list readonlyAttrs as attr>
		<#if attr?index != 0>
  	}, {
		</#if>
			name: '${modelbase.get_attribute_sql_name(attr)}',
			title: '${modelbase.get_attribute_label(attr)}',
	</#list>    
  	}]
  });
  this.form${js.nameType(master.name)}Read.render(widget${js.nameType(master.name)}Read, params);
};

delete page${js.nameType(master.name)}Read;
page${js.nameType(master.name)}Read = new Page${js.nameType(master.name)}Read();
</script>