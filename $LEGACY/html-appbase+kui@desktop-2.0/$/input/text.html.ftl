<div class="input-group">
  <input name="${js.nameVariable(id)}" data-domain-type="${domain!''}"<#if required??> data-required="${title}"</#if> class="form-control">
<#if unit??>  
  <div class="input-group-append">
    <span class="input-group-text">${unit}</span>
  </div>
</#if>
<#if required??>
  <div class="input-group-append">
    <span class="input-group-text">
      <i class="fas fa-asterisk icon-required"></i>
    </span>
  </div>
<#elseif domain?? && domain != ''>
  <div class="input-group-append">
    <span class="input-group-text">
      <i class="fas fa-question icon-help"></i>
    </span>
  </div>
</#if>
</div>