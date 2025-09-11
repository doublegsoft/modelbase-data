<#import '/$/modelbase.ftl' as modelbase>
<#assign alias = desktop.getLabelledOptions('desktop')['alias']!desktop.name>
<#assign customObject = typebase.anonymousObjectType(outline.constraint.domainType.toString())>
<div id="page${js.nameType(alias)}Outline" class="page side">
  <div widget-id="widget${js.nameType(alias)}" class="card-body mb-3"></div>
<script>
function Page${js.nameType(alias)}Outline() {
  this.page = dom.find('#page${js.nameType(alias)}Outline');
}

Page${js.nameType(alias)}Outline.prototype.setup = function(params) {
  
};

Page${js.nameType(alias)}Outline.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}Outline = new Page${js.nameType(alias)}Outline();
</script>
</div>