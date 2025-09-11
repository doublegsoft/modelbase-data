<div class="input-prepend input-group">
  <input name="${js.nameVariable(id)}" class="form-control"<#if required??> data-required="${title}"</#if> data-domain-type="date">
<#if required??>
  <div class="input-group-append">
    <span class="input-group-text">
      <i class="fas fa-asterisk icon-required"></i>
    </span>
  </div>
</#if>
</div>