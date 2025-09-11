<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${js.license(license)}
</#if>
const app = getApp();
const { gux } = require('@/vendor/gux/common/gux');
const { sdk } = require('@/sdk/' + app.sdk);

Component({
  
  data: {
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable")>
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
    
    /*!
    ** TOP ${count} 【${modelbase.get_object_label(obj)}】
    */
    top${count}${js.nameType(inflector.pluralize(obj.name))}: [],
  </#if>  
  <#if obj.isLabelled("browsable")>
    
    /*!
    ** TOP 4 【${modelbase.get_object_label(obj)}】
    */
    top4${js.nameType(inflector.pluralize(obj.name))}: [],
  </#if>
</#list>    
  },
    
  pageLifetimes: {

    show() {
      app.onShowPage(this);
    }
  },
  
  lifetimes: {
  
    ready() {
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable")>
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
      this.fetchTop${count}${js.nameType(inflector.pluralize(obj.name))}();
  </#if>    
  <#if obj.isLabelled("browsable")>
      this.fetchTop4${js.nameType(inflector.pluralize(obj.name))}();
  </#if>
</#list>
    },
  },
  
  methods: {
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable")>
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
    
    async fetchTop${count}${js.nameType(inflector.pluralize(obj.name))}() {
      let page = await sdk.find${js.nameType(inflector.pluralize(obj.name))}({});
      let top${count} = [];
      for (let i = 0; i < page.data.length; i++) {
        if (top${count}.length >= ${count}) break;
        top${count}.push(page.data[i]);
      }
      this.setData({
        top${count}${js.nameType(inflector.pluralize(obj.name))}: top${count},
      });
    },
  </#if>
  <#if obj.isLabelled("browsable")>
    
    async fetchTop4${js.nameType(inflector.pluralize(obj.name))}() {
      let page = await sdk.find${js.nameType(inflector.pluralize(obj.name))}({});
      let top4 = [];
      for (let i = 0; i < page.data.length; i++) {
        if (top4.length >= 4) break;
        top4.push(page.data[i]);
      }
      this.setData({
        top4${js.nameType(inflector.pluralize(obj.name))}: top4,
      });
    },
  </#if>  
</#list>   
<#list model.objects as obj>
  <#assign idAttr = modelbase.get_id_attributes(obj)[0]>
  <#if obj.isLabelled("browsable")>
    
    goto${js.nameType(obj.name)}Detail(ev) {
      let item = ev.currentTarget.dataset.${java.nameVariable(obj.name)};
      gux.navigateTo({
        url: '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-detail/index?${modelbase.get_attribute_sql_name(idAttr)}=' + item.${modelbase.get_attribute_sql_name(idAttr)},
      });
    },
    
    goto${js.nameType(obj.name)}Coll(ev) {
      gux.navigateTo({
        url: '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-coll/index',
      });
    },
  <#elseif obj.isLabelled("listable")>
    
    goto${js.nameType(obj.name)}Detail(ev) {
      let item = ev.currentTarget.dataset.${java.nameVariable(obj.name)};
      gux.navigateTo({
        url: '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-detail/index?${modelbase.get_attribute_sql_name(idAttr)}=' + item.${modelbase.get_attribute_sql_name(idAttr)},
      });
    },
    
    goto${js.nameType(obj.name)}List(ev) {
      gux.navigateTo({
        url: '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-list/index',
      });
    },
  <#elseif obj.isLabelled("advertisable")>
    
    goto${js.nameType(obj.name)}Detail(ev) {
      let item = ev.currentTarget.dataset.item;
      gux.navigateTo({
        url: '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}-detail/index?${modelbase.get_attribute_sql_name(idAttr)}=' + item.${modelbase.get_attribute_sql_name(idAttr)},
      });
    },  
  </#if>  
</#list>   
  },
})