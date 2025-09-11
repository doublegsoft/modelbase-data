<#if license??>
${js.license(license)}
</#if>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');

Component({
  
  data: {
  },
    
  pageLifetimes: {

    show() {
      app.onShowPage(this);
    }
  },

  methods: {
<#list app.pages as page>
  <#assign pagetype = projbase.get_page_type_name(page)>
  
    /*!
    ** 【${page.title}】
    */
    goto${js.nameType(pagetype)}() {
      gux.navigateTo({
        url: '/page/${app.name}<#if page.module?? && page.module != "unknown">/${page.module}</#if>/${page.id}/index',
      });
    },
</#list>
  },
})