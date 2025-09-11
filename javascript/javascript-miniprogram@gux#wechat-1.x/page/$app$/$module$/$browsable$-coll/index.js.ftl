<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
<#assign obj = browsable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');
const { util } = require("@/vendor/gux/common/util");
const { sdk } = require("@/sdk/" + app.sdk);

Page({

  data: {

    odd${js.nameType(inflector.pluralize(obj.name))}: [],
    
    even${js.nameType(inflector.pluralize(obj.name))}: [],

    start: 0,
    
    limit: 10,
  },

  onLoad(options) {
    
  },

  onShow() { 
    this.fetch${js.nameType(inflector.pluralize(obj.name))}();
  },

  onPullDownRefresh() {
    this.data.odd${js.nameVariable(inflector.pluralize(obj.name))} = [];
    this.data.even${js.nameVariable(inflector.pluralize(obj.name))} = [];
    this.data.start = 0;
    this.fetch${js.nameType(inflector.pluralize(obj.name))}();
  },

  async fetch${js.nameType(inflector.pluralize(obj.name))}() {
    let grid = this.selectComponent('#grid${js.nameType(obj.name)}');
    grid.showLoading();
    let oddItems = this.data.odd${js.nameType(inflector.pluralize(obj.name))};
    let evenItems = this.data.even${js.nameType(inflector.pluralize(obj.name))};
    sdk.find${js.nameType(inflector.pluralize(obj.name))}({
      start: this.data.start,
      limit: this.data.limit,
    }).then(resp => {
      let items = resp.data;
      for (let i = 0; i < items.length; i++) {
        if (i % 2 == 0) {
          oddItems.push(items[i]);
        } else {
          evenItems.push(items[i]);
        }
      }
      this.setData({
        odd${js.nameType(inflector.pluralize(obj.name))}: oddItems,
        even${js.nameType(inflector.pluralize(obj.name))}: evenItems,
      })
      grid.hideLoading();
      this.data.start += this.data.limit;  
    }).catch(err => {
      wx.showToast({
        icon: 'error',
        title: '程序出错了！',
      })
      grid.hideLoading();
    });
  },
  
  goto${js.nameType(obj.name)}Detail(ev) {
    let item = ev.currentTarget.dataset.${java.nameVariable(obj.name)};
    gux.navigateTo({
      url: '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-detail/index?${modelbase.get_attribute_sql_name(idAttr)}=' + item.${modelbase.get_attribute_sql_name(idAttr)},
    });
  },
  
  gotoSearch() {
    gux.navigateTo({
      url: '/page/${app.name}/${modelbase4js.get_object_page_path(obj)}-search/index',
    });
  },
})