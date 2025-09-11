const app = getApp();
const { sdk } = require('@/sdk/' + app.sdk);

Page({

  data: {
    marginTop: 0,

    title: '搜索',
    tooltip: '输入搜索条件',
  },

  onLoad(opts) {
    let changed = {};
    if (opts.title) {
      changed.title = opts.title;
    }
    if (opts.tooltip) {
      changed.tooltip = opts.tooltip;
    }
    this.setData(changed);
  },

  onShow() {
    app.onShowPage(this);
    this.doFetchCriteria();
  },

  gotoBackWithCriteria(ev) {
    const pages = getCurrentPages();
    const prevPage = pages[pages.length - 2]; 
    if (prevPage.doSearch) {
      prevPage.doSearch(ev.currentTarget.dataset.text);
    }

    wx.navigateBack();
  },

  doFetchCriteria() {
    
  },
})