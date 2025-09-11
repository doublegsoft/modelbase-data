<#assign defaultOption = '请选择...'>
<#if container.type == 'query'>
  <#assign defaultOption = '不限'>
</#if>
<div class="input-group-prepend input-group">
  <select name="${js.nameVariable(id)}"<#if required??> data-required="${title}"</#if> class="form-control">
    <#--<option value="-1">${defaultOption}</option>-->
<#list options![] as opt>
    <option value="${opt.value}">${opt.text}</option>
</#list>
  </select>
<#if required??>
  <div class="input-group-append">
    <span class="input-group-text">
      <i class="fas fa-asterisk icon-required"></i>
    </span>
  </div>
</#if>
</div>