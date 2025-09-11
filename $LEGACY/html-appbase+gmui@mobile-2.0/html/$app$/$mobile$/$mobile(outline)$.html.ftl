<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#assign querybase = statics['io.doublegsoft.querybase.Querybase']>
<#assign alias = mobile.getLabelledOptions('mobile')['alias']!mobile.name>
<div id="page${js.nameType(alias)}Outline" class="page">

<script>

function Page${js.nameType(alias)}Outline() {
  this.page = dom.find('#page${js.nameType(alias)}Outline');
}

Page${js.nameType(alias)}Outline.prototype.setup = function(params) {
  let self = this;
  self.complete();
};

Page${js.nameType(alias)}Outline.prototype.complete = function(params) {
  $('#page${js.nameType(alias)}Outline').transition('slide up');
};

Page${js.nameType(alias)}Outline.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}Outline = new Page${js.nameType(alias)}Outline();
</script>
</div>