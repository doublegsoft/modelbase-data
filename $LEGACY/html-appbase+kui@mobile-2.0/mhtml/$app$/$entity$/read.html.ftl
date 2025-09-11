<#import '/$/modelbase.ftl' as modelbase>
<#assign entityId = modelbase.get_id_attributes(entity)[0]>
<div id="page${js.nameType(entity.name)}Read" class="mobile page">
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr) || attr.constraint.identifiable><#continue></#if>
  <div class="row ml-0 mr-0">
    <label class="col-xs-3 col-form-label">${modelbase.get_attribute_label(attr)}：</label>
    <label name="text${js.nameType(modelbase.get_attribute_sql_name(attr))}" class="col-xs-9 col-form-label">-</label>
  </div>
</#list>
</div>
<script>

function Page${js.nameType(entity.name)}Read() {
  this.page = dom.find('#page${js.nameType(entity.name)}Read');
}

Page${js.nameType(entity.name)}Read.prototype.initialize = async function(params) {
  await stdbiz.init(this);
  ${parentApplication}.${app.name}.find${js.nameType(modelbase.get_object_plural(entity))}({
    ${modelbase.get_attribute_sql_name(entityId)}: params.${modelbase.get_attribute_sql_name(entityId)},
  }).then((data) => {
    if (data.length == 0) return;
    data = data[0];
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr) || attr.constraint.identifiable><#continue></#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#if refObj.isLabelled('entity')>
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = data.${modelbase.get_attribute_sql_name(attr)?replace('Id', 'Name')} || '-';
    <#else>
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = data.${modelbase.get_attribute_sql_name(attr)?replace('Code', 'Name')} || '-';
    </#if>
  <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
    if (data.${modelbase.get_attribute_sql_name(attr)}) {
      this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = moment(data.${modelbase.get_attribute_sql_name(attr)}).format('YYYY-MM-DD');
    }
  <#elseif attr.constraint.domainType.toString()?index_of('enum') == 0>
    if (data.${modelbase.get_attribute_sql_name(attr)}) {
      this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}[data.${modelbase.get_attribute_sql_name(attr)}];
    }
  <#else>
    this.text${js.nameType(modelbase.get_attribute_sql_name(attr))}.innerHTML = data.${modelbase.get_attribute_sql_name(attr)} || '-';
  </#if>
</#list>
  });
};

Page${js.nameType(entity.name)}Read.prototype.show = function(params) {
  this.initialize(params);
};

page${js.nameType(entity.name)}Read = new Page${js.nameType(entity.name)}Read();

</script>