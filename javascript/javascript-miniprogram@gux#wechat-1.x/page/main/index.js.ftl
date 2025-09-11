<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${js.license(license)}
</#if>
const app = getApp();
const { sdk } = require("@/sdk/" + app.sdk);

Page({

  data: {
    
    activeIndex: 0,
  
    entries: [{
      icon: "gx-i gx-i-home gx-fs-36",
      text: "首页",
    },{
<#list model.objects as obj>
  <#if obj.isLabelled("navigable")>    
      icon: "gx-i gx-i-date gx-fs-36",
      text: "${modelbase.get_object_label(obj)}",
    },{
  </#if>  
</#list>  
      icon: "gx-i gx-i-user gx-fs-36",
      text: "我的",
    }],
  },

  onShow() {

  },

  doTabBarActiveChanged(ev) {
    wx.setNavigationBarTitle({
      title: ev.detail.text,
    });
    this.setData({
      activeIndex: ev.detail.activeIndex,
    });
    let nav = this.selectComponent("#nav-" + ev.detail.activeIndex);
    nav.show();
<#assign index = 1>    
<#list model.objects as obj>    
  <#if !obj.isLabelled("navigable")><#continue></#if>
    if (ev.detail.activeIndex == ${index}) {
      let page = this.selectComponent('#page${js.nameType(obj.name)}');
      // page.show();
    }
  <#assign index += 1>  
</#list>    
  },
  
})
