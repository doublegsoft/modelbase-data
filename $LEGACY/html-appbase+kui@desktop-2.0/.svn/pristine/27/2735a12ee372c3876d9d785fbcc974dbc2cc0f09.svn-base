<#import '/$/guidbase.ftl' as guidbase>
<#assign grid = Grid.layout(children)>
<div id="${js.nameVariable(id)}" class="col-md-${guidbase.get_widget_width(position)} form-horizontal">
<#list grid.rows as row>
  <div class="form-group row">
  <#list row.cells as cell>
    <#assign widgets = cell.values>
    <#assign width = guidbase.get_widget_width(widgets[0].position)>
    <label class="col-md-${(width / 3)?floor} col-form-label">${widgets[0].title!'未指定'}：</label>
    <div class="col-md-${(width / 3 * 2)?floor}">
${plugin.render(widgets[0], 6, 'html')}
    </div>
  </#list>
  </div>
</#list>
</div>