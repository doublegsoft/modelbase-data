<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
<#assign obj = editable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');
const { util } = require("@/vendor/gux/common/util");
const { sdk } = require("@/sdk/" + app.sdk);

Page({

  data: {
    
    /*
    ** 正在编辑的【${modelbase.get_object_label(obj)}】对象
    */
    ${js.nameVariable(obj.name)}: {},
<#list idAttrs as idAttr>

    /*
    ** 【${modelbase.get_attribute_label(idAttr)}】的查询标识
    */
    ${modelbase.get_attribute_sql_name(idAttr)}: null,
</#list>    
  },

  onLoad(options) {
    <#list idAttrs as idAttr>
    this.data.${modelbase.get_attribute_sql_name(idAttr)} = options.${modelbase.get_attribute_sql_name(idAttr)};
    </#list>
  },

  onShow() { 
    app.onShowPage(this);
    this.fetch${js.nameType(obj.name)}();
  },

  fetch${js.nameType(obj.name)}(ev) {
    sdk.read${js.nameType(obj.name)}({
<#list idAttrs as idAttr>   
      ${modelbase.get_attribute_sql_name(idAttr)}: this.data.${modelbase.get_attribute_sql_name(idAttr)},
</#list>      
    }).then(resp => {
      this.setData({
        ${js.nameVariable(obj.name)}: resp.data,
      });
    }).catch(err => {
      wx.showToast({
        icon: 'error',
        title: '程序出错了！',
      });
      list.hideLoading();
    });
  },
  
  doSave() {
  },
})