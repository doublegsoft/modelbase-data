<#import '/$/modelbase.ftl' as modelbase>
<div id="page${js.nameType(entity.name)}View" class="card b-a-0">
  <div widget-id="form{js.nameType(entity.name)}View" class="card-body mb-3">
  </div>

<script>
function Page${js.nameType(entity.name)}View () {
  
}

Page${js.nameType(entity.name)}View.prototype.show = function (params) {
  let self = this;
  stdbiz.${app.name}.optionForm${js.nameType(entity.name)}View({
    customElementId: 'FORM.${entity.name?upper_case}.EDIT' 
  }, function(option) {
    option.readonly = true;
    self.form{js.nameType(entity.name)}View = new FormLayout(option);
    self.setup(params);
  });
};

Page${js.nameType(entity.name)}View.prototype.setup = function (params) {
  this.form{js.nameType(entity.name)}View.render('#page${js.nameType(entity.name)}View div[widget-id=form{js.nameType(entity.name)}View]', params);
};

page${js.nameType(entity.name)}View = new Page${js.nameType(entity.name)}View();

</script>
</div>