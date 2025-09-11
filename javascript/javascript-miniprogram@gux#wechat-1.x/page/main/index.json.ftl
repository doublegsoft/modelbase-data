{
  "navigationStyle": "custom",
  "usingComponents": {
    "page-home": "/page/navigable/home/index",
<#list model.objects as obj>
  <#if obj.isLabelled("navigable")>
    "page-${obj.name?replace('_','-')}": "/page/navigable/${obj.name}/index",
  </#if>  
</#list>
    "page-user": "/page/navigable/user/index",
    "gx-navigable-page": "/vendor/gux/widget/gx-navigable-page/index",
    "gx-tab-bar": "/vendor/gux/widget/gx-tab-bar/index"
  }
}
