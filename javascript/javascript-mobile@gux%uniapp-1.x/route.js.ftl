<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
/*!
** 跳转到【入口】页面
*/
function gotoMain() {

}
<#list model.objects as obj>
  <#assign module = modelbase.get_object_module(obj)!"">
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#if obj.isLabelled("browsable")>
  
/*!
** 跳转到【${modelbase.get_object_label(obj)}】栅格集合页面
*/
export function goto${js.nameType(obj.name)}Coll(params) {
  uni.navigateTo({
    url: '/page/${app.name}/${module}/${obj.name?replace("_","-")}/coll',
  });
}
  </#if>
  <#if obj.isLabelled("listable")>
  
/*!
** 跳转到【${modelbase.get_object_label(obj)}】列表集合页面
*/
export function goto${js.nameType(obj.name)}List() {
  uni.navigateTo({
    url: '/page/${app.name}/${module}/${obj.name?replace("_","-")}/list',
  });
}
  </#if>
  <#if obj.isLabelled("searchable")>
  
/*!
** 弹出显示【${modelbase.get_object_label(obj)}】列表查询页面
*/
export function goto${js.nameType(obj.name)}Search(search) {
  uni.navigateTo({
    url: '/page/${app.name}/${module}/${obj.name?replace("_","-")}/search',
    events: {
      doSearch: function (data) {
        if (search) {
          search(data);
        }
      },
    },
  });
}  
  </#if>
  <#if obj.isLabelled("detailable")>
  
/*!
** 跳转到【${modelbase.get_object_label(obj)}】详情页面
*/
export function goto${js.nameType(obj.name)}Detail(params) {
  uni.navigateTo({
    url: `/page/${app.name}/${module}/${obj.name?replace("_","-")}/detail?<#list idAttrs as idAttr><#if idAttr?index != 0>&</#if>${modelbase.get_attribute_sql_name(idAttr)}=${r"${"}params.${modelbase.get_attribute_sql_name(idAttr)}}</#list>`,
  });
}  
  </#if>
  <#if obj.isLabelled("purchasable")>
  
/*!
** 跳转到【${modelbase.get_object_label(obj)}】支付页面
*/
export function goto${js.nameType(obj.name)}Pay(params) {
  uni.navigateTo({
    url: '/page/${app.name}/${module}/${obj.name?replace("_","-")}/pay',
  });
}  
  </#if>
</#list>

/*!
** 跳转到【个人信息】设置页面
*/
export function gotoProfileSettings() {
  uni.navigateTo({
    url: '/page/${app.name}/profile/settings',
  });
}

/*!
** 跳转到【个人信息】设置页面
*/
export function gotoProfileEdit() {
  uni.navigateTo({
    url: '/page/${app.name}/profile/edit',
  });
}

/*!
** 跳转到【购物车】页面
*/
export function gotoPersonalCart() {
  
} 