<#import '/$/guidbase.ftl' as guidbase>
<div id="${js.nameVariable(id)}" class="col-md-12 form-horizontal">
<#list 1..children?size as index>
  <#if index % 2 == 1>
  <div class="form-group row">
  </#if>
  <#assign child = children[index - 1]>
    <label class="col-md-2 col-form-label">${child.title}：</label>
    <div class="col-md-4">
${plugin.render(child, 6, 'html')}
    </div>
  <#if index % 2 == 1>
  </div>
  </#if>
</#list>
  <div class="form-buttons float-right">
    <button name="buttonNew" type="button" class="btn btn-sm btn-close">关闭</button>
  </div>
</div>