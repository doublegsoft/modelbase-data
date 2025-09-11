<div class="col-form-label">
<#list opts![] as opt>
  <div class="form-check form-check-inline">
    <input id="${js.nameVariable(id)}_${opt.key}" name="${js.nameVariable(id)}[]" value="${opt.key}" type="checkbox" class="form-check-input" checked<#if required??> data-required="${title}" </#if>>
    <label class="form-check-label" for="${js.nameVariable(id)}_${opt.value}">${opt.text}</label>
  </div>
</#list>
</div>