<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
{
  "pages": [
    "page/welcome/index",
    "page/common/article/index",
    "page/common/search/index",
    "page/common/success/index",
    "page/common/failure/index",
    "page/common/under-construction/index",
    "page/${app.name}/settings/address/list",
    "page/${app.name}/settings/address/edit",
    "page/${app.name}/settings/family_member/list",
    "page/${app.name}/settings/family_member/edit",
    "page/${app.name}/settings/mine/index",
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>
    "page/${app.name}/${modelbase4js.get_object_page_path(obj)}-coll/index",
    "page/${app.name}/${modelbase4js.get_object_page_path(obj)}-search/index",
  </#if>
  <#if obj.isLabelled("listable")>
    "page/${app.name}/${modelbase4js.get_object_page_path(obj)}-list/index",
    <#if !obj.isLabelled("browsable")>
    "page/${app.name}/${modelbase4js.get_object_page_path(obj)}-search/index",
    </#if>
  </#if>
  <#if obj.isLabelled("schedulable")>
    "page/${app.name}/${modelbase4js.get_object_page_path(obj)}-daily/index",
  </#if>  
  <#if obj.isLabelled("detailable")>
    "page/${app.name}/${modelbase4js.get_object_page_path(obj)}-detail/index",
  </#if>
</#list>
    "page/main/index"
  ],
  "window": {
    "backgroundTextStyle": "light",
    "navigationBarBackgroundColor": "#fff",
    "navigationBarTitleText": "",
    "navigationBarTextStyle": "black"
  },
  "style": "v2",
  "rendererOptions": {
    "skyline": {
      "defaultDisplayBlock": true,
      "disableABTest": true,
      "sdkVersionBegin": "3.0.0",
      "sdkVersionEnd": "15.255.255"
    }
  },
  "componentFramework": "glass-easel",
  "sitemapLocation": "sitemap.json",
  "lazyCodeLoading": "requiredComponents",
  "resolveAlias": {
    "@/*": "/*"
  }
}