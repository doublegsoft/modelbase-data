<#import '/$/modelbase.ftl' as modelbase>
<#assign entityId = modelbase.get_id_attributes(entity)[0]>
<#assign who = modelbase.get_labelled_attribute(entity, 'who')>
<div id="page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}" class="mobile page">
</div>
<script>

function Page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}() {
  this.page = dom.find('#page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}');
}

Page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}.prototype.initialize = async function(params) {
  await stdbiz.init(this);
  ${parentApplication}.${app.name}.find${js.nameType(modelbase.get_object_plural(entity))}({
    ${modelbase.get_attribute_sql_name(who)}: params.${modelbase.get_attribute_sql_name(who)},
  }).then((data) => {
    if (data.length == 0) return;
    for (let i = 0; i < data.length; i++) {
      let el = this.renderSectionItem(data[i]);
      this.page.appendChild(el);
    }

  });
};

Page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}.prototype.renderSectionItem = function(row) {
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr) || attr.constraint.identifiable><#continue></#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#if refObj.isLabelled('entity')>
  row.${modelbase.get_attribute_sql_name(attr)?replace('Id', 'Name')} = row.${modelbase.get_attribute_sql_name(attr)?replace('Id', 'Name')} || '-';
    <#else>
  row.${modelbase.get_attribute_sql_name(attr)?replace('Code', 'Name')} = row.${modelbase.get_attribute_sql_name(attr)?replace('Code', 'Name')} || '-';
    </#if>
  <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
  if (row.${modelbase.get_attribute_sql_name(attr)}) {
    row.${js.nameVariable(modelbase.get_attribute_sql_name(attr))} = moment(row.${modelbase.get_attribute_sql_name(attr)}).format('YYYY-MM-DD');
  }
  <#elseif attr.constraint.domainType.toString()?index_of('enum') == 0>
  if (row.${modelbase.get_attribute_sql_name(attr)}) {
    row.${js.nameVariable(modelbase.get_attribute_sql_name(attr))} = ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}[row.${modelbase.get_attribute_sql_name(attr)}];
  }
  <#else>
  row.${js.nameVariable(modelbase.get_attribute_sql_name(attr))} = row.${modelbase.get_attribute_sql_name(attr)} || '-';
  </#if>
</#list>
  let ret = dom.templatize(`
    <div>
      <div class="title-gradient mb-2">
        <span>标题</span>
      </div>
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr) || attr.constraint.identifiable><#continue></#if>
      <div class="row ml-0 mr-0">
        <div class="col-3">
          <label>${modelbase.get_attribute_label(attr)}：</label>
        </div>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#if refObj.isLabelled('entity')>
        <div class="col-9">
          <label>{{${modelbase.get_attribute_sql_name(attr)?replace('Id','Name')}}}</label>
        </div>
    <#else>
        <div class="col-9">
          <label>{{${modelbase.get_attribute_sql_name(attr)?replace('Code','Name')}}}</label>
        </div>
    </#if>
  <#else>
        <div class="col-9">
          <label>{{${modelbase.get_attribute_sql_name(attr)}}}</label>
        </div>
  </#if>  
      </div>
</#list>    
    </div>
  `, row);
  return ret;
};

Page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}.prototype.show = function(params) {
  this.initialize(params);
};

page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)} = new Page${js.nameType(entity.name)}SectionBy${js.nameType(who.name)}();

</script>