<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');
const { sdk } = require('@/sdk/' + app.sdk);

Page({

  data: {
    user: app.user,
  },

  onLoad: async function (options) {
    this.setData({
      user: app.user,
    });
  },
});
