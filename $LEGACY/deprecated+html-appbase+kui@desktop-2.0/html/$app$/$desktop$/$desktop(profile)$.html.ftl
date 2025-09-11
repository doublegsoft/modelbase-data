<#import '/$/modelbase.ftl' as modelbase>
<#assign alias = desktop.getLabelledOptions('desktop')['alias']!desktop.name>
<#assign customObject = typebase.anonymousObjectType(profile.constraint.domainType.toString())>
<div id="page${js.nameType(alias)}Profile" class="page">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
        <strong>
          <i class="far fa-file-alt pr-2"></i>${profile.getLabelledOptions('profile')['title']}
        </strong>
        <div class="card-header-actions">
          <a widget-id="buttonExportPdf" class="card-header-action text-success" data-toggle="dropdown">
            <i class="far fa-file-pdf text-white ml-0"></i>存为PDF
          </a>
          <a widget-id="buttonExportWord" class="card-header-action text-success" data-toggle="dropdown">
            <i class="far fa-file-word text-white ml-0"></i>存为Word
          </a>
        </div>
      </div>
      <div widget-id="widget${js.nameType(alias)}" class="card-body"></div>
    </div>
  </div>
</div>
<script>
function Page${js.nameType(alias)}Profile() {
  this.page = dom.find('#page${js.nameType(alias)}Profile');
};

Page${js.nameType(alias)}Profile.prototype.setup = function(params) {
  
};

Page${js.nameType(alias)}Profile.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}Profile = new Page${js.nameType(alias)}Profile();
</script>
</script>