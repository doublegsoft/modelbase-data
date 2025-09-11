<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
<#assign obj = detailable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');
const { sdk } = require('@/sdk/' + app.sdk);

Page({

  data: {
    
    /*!
    ** 详细展示的【${modelbase.get_object_label(obj)}】对象
    */
    ${js.nameVariable(obj.name)}: {},
  },
  
  onShow() {
    // 界面元素布局参数
    let info = wx.getSystemInfoSync();
    let rect = wx.getMenuButtonBoundingClientRect();
   
    this.setData({
      topOfBack: rect.top,
      heightOfBack: rect.height,
      bottomOfOrder: info.screenHeight - info.safeArea.height - info.safeArea.top,
    });
  },
  
  onLoad(option) {
    this.fetch${js.nameType(obj.name)}(option.${modelbase.get_attribute_sql_name(idAttr)});
  },
  
  doNavigateBack() {
    gux.navigateBack();
  },
  
  async fetch${js.nameType(obj.name)}(${modelbase.get_attribute_sql_name(idAttr)}) {
    let item = await sdk.read${js.nameType(obj.name)}(${modelbase.get_attribute_sql_name(idAttr)});
    this.setData({
      ${js.nameVariable(obj.name)}: item,
    });
  },

  selectDelivery(e) {
    this.setData({
      selectedDelivery: e.currentTarget.dataset.type
    });
  },

  addToCart() {
    wx.showToast({
      title: '已添加到购物车',
      icon: 'success'
    });
  },

  buyNow() {
    wx.navigateTo({
      url: '/pages/order/checkout'
    });
  }
});