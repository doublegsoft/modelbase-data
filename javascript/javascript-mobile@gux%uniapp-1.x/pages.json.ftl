<#import "/$/modelbase.ftl" as modelbase>
{
  "pages": [{
    "path": "page/home",
    "style": {
      "navigationStyle": "custom",
      "navigationBarTitleText": "首页"
    }
  },{
    "path": "page/main",
    "style": {
      "navigationStyle": "custom",
      "navigationBarTitleText": "应用"
    }
  },{
    "path": "page/profile",
    "style": {
      "navigationStyle": "custom",
      "navigationBarTitleText": "我的"
    }
  },{
    "path": "page/${app.name}/profile/settings",
    "style": {
      "navigationBarTitleText": "设置"
    }
  },{
    "path": "page/${app.name}/profile/edit",
    "style": {
      "navigationBarTitleText": "基本资料"
    }  
<#list model.objects as obj>    
  <#assign module = modelbase.get_object_module(obj)>
  <#if obj.isLabelled("browsable")>
  },{
    "path": "page/${app.name}/${module}/${obj.name?replace("_","-")}/coll",
    "style": {
      "navigationBarTitleText": "${modelbase.get_object_label(obj)}列表",
      "enablePullDownRefresh": true,
      "onReachBottomDistance": 50
    }
  </#if>
  <#if obj.isLabelled("listable")> 
  },{
    "path": "page/${app.name}/${module}/${obj.name?replace("_","-")}/list",
    "style": {
      "navigationBarTitleText": "${modelbase.get_object_label(obj)}列表",
      "enablePullDownRefresh": true,
      "onReachBottomDistance": 50
    }
  </#if>
  <#if obj.isLabelled("searchable")> 
  },{
    "path": "page/${app.name}/${module}/${obj.name?replace("_","-")}/search",
    "style": {
      "navigationBarTitleText": "${modelbase.get_object_label(obj)}搜索"
    }
  </#if>
  <#if obj.isLabelled("detailable")> 
    <#assign levelledAttrs = modelbase.level_object_attributes(obj)>
  },{
    "path": "page/${app.name}/${module}/${obj.name?replace("_","-")}/detail",
    "style": {
    <#if (levelledAttrs["image"]?size > 0)>
      "navigationStyle": "custom",
    </#if>  
      "navigationBarTitleText": "${modelbase.get_object_label(obj)}详情"
    }
  </#if>
  <#if obj.isLabelled("purchasable")> 
    <#assign levelledAttrs = modelbase.level_object_attributes(obj)>
  },{
    "path": "page/${app.name}/${module}/${obj.name?replace("_","-")}/pay",
    "style": {
      "navigationBarTitleText": "${modelbase.get_object_label(obj)}支付"
    }
  </#if>
</#list>  
  }],
  "globalStyle": {
    "navigationBarTextStyle": "black",
    "navigationBarTitleText": "${app.name}",
    "navigationBarBackgroundColor": "#F8F8F8",
    "backgroundColor": "#F8F8F8"
  },
  "tabBar": {
    "color": "#7A7E83",
    "selectedColor": "#5C98F1",
    "iconfontSrc": "vendor/gux/font/gx-iconfont.ttf",
    "backgroundColor": "#ffffff",
    "borderStyle": "black",
    "list": [{
      "pagePath": "page/home",
      "iconfont": {
        "text": "\u004d",
        "selectedColor": "#5C98F1"
      },
      "text": "首页"
    },{
      "pagePath": "page/main",
      "iconfont": {
        "text": "\u0050",
        "selectedColor": "#5C98F1"
      },
      "text": "应用"
    },{
      "pagePath": "page/profile",
      "iconfont": {
        "text": "\u0049",
        "selectedColor": "#5C98F1"
      },
      "text": "我的"
    }]
  },
  "uniIdRouter": {}
}
