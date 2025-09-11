<#if license??>
${js.license(license)}
</#if>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');

Component({
  
  data: {
    
    /*!
    ** 当前登录用户。
    */
    user: app.user,
  },
    
  pageLifetimes: {

    show() {
      app.onShowPage(this);
    }
  },
  
  methods: {
    
    gotoMine() {
      gux.navigateTo({
        url: '/page/${app.name}/pim/mine/index',
      });
    },
    
    gotoAddressList() {
      gux.navigateTo({
        url: '/page/${app.name}/pim/address/list',
      });
    },
    
    gotoFamilyMemberList() {
      gux.navigateTo({
        url: '/page/${app.name}/pim/family_member/list',
      });
    },
    
  },
})