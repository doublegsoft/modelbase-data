<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
<#assign obj = listable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');
const { util } = require("@/vendor/gux/common/util");
const { sdk } = require("@/sdk/" + app.sdk);

Page({

  data: {

    ${js.nameVariable(inflector.pluralize(obj.name))}: [],

    start: 0,
    
    limit: 10,
  },

  onLoad(options) {
    
  },

  onShow() { 
    app.onShowPage(this);
    this.fetch${js.nameType(inflector.pluralize(obj.name))}();
  },

  onPullDownRefresh() {
    this.data.items = [];
    this.data.start = 0;
    this.fetch${js.nameType(inflector.pluralize(obj.name))}();
  },

  fetch${js.nameType(inflector.pluralize(obj.name))}(ev) {
    let list = this.selectComponent('#list${js.nameType(obj.name)}');
    list.showLoading();
    let items = this.data.${js.nameVariable(inflector.pluralize(obj.name))};
    sdk.find${js.nameType(inflector.pluralize(obj.name))}({
      start: this.data.start,
      limit: this.data.limit,
    }).then(resp => {
      items = items.concat(resp.data);
      this.setData({${js.nameVariable(inflector.pluralize(obj.name))}: items});
      list.hideLoading();
      this.data.start += 15;  
    }).catch(err => {
      wx.showToast({
        icon: 'error',
        title: '程序出错了！',
      });
      list.hideLoading();
    });
  },

  gotoSearch() {
    gux.navigateTo({
      url: '/page/${app.name}/${modelbase4js.get_object_page_path(obj)}-search/index',
    });
  },
})