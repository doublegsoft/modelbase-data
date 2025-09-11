<#import '/$/modelbase.ftl' as modelbase>
<#assign valueId = modelbase.get_id_attributes(value)[0]>
<#assign primary = modelbase.get_object_primary(value)!''>
<#assign secondary = modelbase.get_object_secondary(value)!''>
<#assign tertiary = modelbase.get_object_tertiary(value)!''>
<#list value.attributes as attr>
</#list>
<div id="page${js.nameType(value.name)}Read" class="mobile page">
</div>
<script>

function Page${js.nameType(value.name)}Read() {
  this.page = dom.find('#page${js.nameType(value.name)}Read');
}

Page${js.nameType(value.name)}Read.prototype.initialize = async function(params) {
  await stdbiz.init(this);
  ${parentApplication}.${app.name}.find${js.nameType(modelbase.get_object_plural(value))}({
    ${modelbase.get_attribute_sql_name(valueId)}: params.${modelbase.get_attribute_sql_name(valueId)},
  }).then((data) => {
    if (data.length == 0) return;
    let ul = dom.element('<ul class="timeline"></ul>');
    for (let i = 0; i < data.length; i++) {
      let li = dom.templatize(`
        <li class="timeline-item">
          <div class="time">{{${primary}}}</div>
          <div class="small text-muted">{{${secondary}}}</div>
          <p>{{${tertiary}}}</p>
        </li>
      `, data[i]);
      ul.appendChild(li);
    }
    this.page.appendChild(ul);
  });
};

Page${js.nameType(value.name)}Read.prototype.show = function(params) {
  this.initialize(params);
};

page${js.nameType(value.name)}Read = new Page${js.nameType(value.name)}Read();

</script>