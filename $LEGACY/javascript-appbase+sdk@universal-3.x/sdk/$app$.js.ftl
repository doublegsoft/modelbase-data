<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
const { xhr } = require("../common/xhr");
const ${app.name} = {};
<#assign methodAndWidgets = {}>
<#list pages![] as page>
  <#assign pageName = modelbase.url_to_page_name(page.uri)>
  <#list page.widgets as widget>
    <#assign variable = widget.variable!'todo'>
    <#if widget.widgetType == '传统列表' || widget.widgetType == 'ListView'>
      <#assign methodAndWidgets = methodAndWidgets + {('load' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '编辑表单' || widget.widgetType == 'FormLayout'>
      <#assign methodAndWidgets = methodAndWidgets + {('save' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
      <#assign methodAndWidgets = methodAndWidgets + {('read' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '只读表单' || widget.widgetType == 'ReadonlyForm'>
      <#assign methodAndWidgets = methodAndWidgets + {('read' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    </#if>
  </#list>
</#list>
<#assign methods = methodAndWidgets?keys?sort>
<#list methods as method>

  <#assign widget = methodAndWidgets[method]>
  <#if method?starts_with('load')>
/**
 * 加载【${widget.variable?upper_case}】数据。
 */
${app.name}.${method} = async (params) => {
  let start = params.start || 0;
  let limit = params.limit || -1;

  let resp = await xhr.promise({
    url: '/api/v3/common/script/stdbiz/module/object/paginate',
    params: {
    },
  });
  if (resp.error) {
    throw resp.error;
  }
  return resp;
};
  <#elseif method?starts_with('save')>
/**
 * 保存【${widget.variable?upper_case}】数据。
 */
${app.name}.${method} = async (${js.nameVariable(widget.variable)}) => {

};
  <#elseif method?starts_with('read')>
/**
 * 读取【${widget.variable?upper_case}】数据。
 */
${app.name}.${method} = async (id) => {

};
  </#if>
</#list>

module.exports = { ${app.name} };