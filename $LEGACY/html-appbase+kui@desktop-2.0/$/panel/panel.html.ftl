<#if !role??>
  <#assign role = 'list'>
</#if>
<div id="${js.nameVariable(id)}" class="row ${style!''}">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
<#if role == 'list' || role == 'edit' || role == 'view'>
        <i class="fa fa-${role}"></i>
<#else>
        <i class="far fa-clipboard"></i>
</#if>
        <strong>${title}</strong>
      </div>
      <div class="card-body row">
<#list children as child>
  <#if child.title??>
        <div class="card-title col-md-12 title-bordered">
          <h6>${child.title}</h6>
        </div>
  </#if>
${plugin.render(child, 8, 'html')}
</#list>
      </div>
    </div>
  </div>
</div>