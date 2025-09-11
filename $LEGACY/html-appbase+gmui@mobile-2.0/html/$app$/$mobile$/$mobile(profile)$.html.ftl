<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#assign querybase = statics['io.doublegsoft.querybase.Querybase']>
<#assign alias = mobile.getLabelledOptions('mobile')['alias']!mobile.name>
<div id="page${js.nameType(alias)}Profile" class="page">

<script>

function Page${js.nameType(alias)}Profile() {
  this.page = dom.find('#page${js.nameType(alias)}Profile');
}

Page${js.nameType(alias)}Profile.prototype.setup = function(params) {
  let self = this;
  self.complete();
};

Page${js.nameType(alias)}Profile.prototype.complete = function(params) {
  $('#page${js.nameType(alias)}Profile').transition('slide up');
};

Page${js.nameType(alias)}Profile.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}Profile = new Page${js.nameType(alias)}Profile();
</script>
</div>