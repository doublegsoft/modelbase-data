<#import '/$/guidbase.ftl' as guidbase>
<div <#if id??>id="${js.nameVariable(id)}"</#if>class="col-md-${guidbase.get_widget_width(position)}">
  <div class="form-buttons float-right">
<#list children as child>
  <#if child.role == 'save'>
    <button data-role="save" class="btn btn-sm btn-save" data-loading-text="<i class='fa fa-spinner fa-spin'></i>数据保存中……">保存</button>
  <#elseif child.role == 'query'>
    <button data-role="query" class="btn btn-sm btn-query">查询</button>
  <#elseif child.role == 'new'>
    <button data-role="new" class="btn btn-sm btn-new">新建</button>
  <#elseif child.role == 'reset'>
    <button data-role="reset" class="btn btn-sm btn-reset" data-loading-text="重置">重置</button>
  <#elseif child.role == 'close'>
    <button onclick="layer.close(layer.index);" data-role="close" class="btn btn-sm btn-reset" data-loading-text="关闭">关闭</button>
  <#elseif child.role == 'back'>
    <button data-role="back" class="btn btn-sm btn-back" data-loading-text="返回">返回</button>
  <#else>
  </#if>
</#list>
  </div>
</div>