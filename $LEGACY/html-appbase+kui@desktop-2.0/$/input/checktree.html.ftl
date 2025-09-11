<#import '/$/guidbase.ftl' as guidbase>
<div class="col-md-${guidbase.get_widget_width(position)}">
  <div class="card">
    <div class="card-body">
      <div class="card-title title-bordered">
        <label>${title}</label>
      </div>
      <div id="checktree${js.nameType(id)}" class="ztree height200"></div>
    </div>
  </div>
</div>