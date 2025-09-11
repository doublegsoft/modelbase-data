
### 引用组件

```
{
  "usingComponents": {
<#list model.objects as obj>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value')><#continue></#if>
    "${parentApplication}-${app.name}-${obj.name?replace('_', '-')}-form": "/component/${parentApplication}/${app.name}/${obj.name}/form",
    "${parentApplication}-${app.name}-${obj.name?replace('_', '-')}-grid": "/component/${parentApplication}/${app.name}/${obj.name}/grid",
    "${parentApplication}-${app.name}-${obj.name?replace('_', '-')}-list": "/component/${parentApplication}/${app.name}/${obj.name}/list",
    "${parentApplication}-${app.name}-${obj.name?replace('_', '-')}-view": "/component/${parentApplication}/${app.name}/${obj.name}/view",
    "${parentApplication}-${app.name}-${obj.name?replace('_', '-')}-cascade": "/component/${parentApplication}/${app.name}/${obj.name}/cascade",
</#list>
  }
}
```