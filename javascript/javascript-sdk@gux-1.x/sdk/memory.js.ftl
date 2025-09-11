<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#if license??>
${dart.license(license)}
</#if>
import sdk from './options';

const delayed = 1200;

function delay(time) {
  time = time || delayed;
  return new Promise(resolve => setTimeout(resolve, time));
}

/*!
** 
*/
sdk.fetchWelcomeImages = async function (params) {
  let ret = [{
    imagePath: '${modelbase.test_image_path()}',
  },{
    imagePath: '${modelbase.test_image_path()}',
  },{
    imagePath: '${modelbase.test_image_path()}',
  }];
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(ret);
    }, 500);
  });
};

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

/**
 * 保存【${modelbase.get_object_label(obj)}】数据。
 */
sdk.save${dart.nameType(obj.name)} = async function (${dart.nameVariable(obj.name)}) {
  await delay();
  <#list idAttrs as idAttr>
  ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase4js.test_unit_value(idAttr)};
  </#list>   
  return ${dart.nameVariable(obj.name)};
}

/**
 * 读取【${modelbase.get_object_label(obj)}】数据。
 */
sdk.read${dart.nameType(obj.name)} = async function (
  <#list idAttrs as idAttr>
  ${modelbase.get_attribute_sql_name(idAttr)}<#if idAttr?index != idAttrs?size - 1>,</#if>
  </#list>
) {
  await delay();
  let ret = {};
  <#list obj.attributes as attr>
    <#if attr.type.collection><#continue></#if>
    <#if attr.type.name == 'json'><#continue></#if>
  ret.${modelbase.get_attribute_sql_name(attr)} = ${modelbase4js.test_unit_value(attr)};
  </#list>
  return ret;
}

/**
 * 加载【${modelbase.get_object_label(obj)}】数据。
 */
sdk.find${dart.nameType(inflector.pluralize(obj.name))} = async function (query) {
  await delay();
  let items = [];
  let limit = query.limit || 10;
  let item;
  <#list 0..9 as i>
  item = {};
    <#list obj.attributes as attr>
      <#if attr.type.collection><#continue></#if>
      <#if attr.type.name == 'json'><#continue></#if>
  item.${modelbase.get_attribute_sql_name(attr)} = ${modelbase4js.test_unit_value(attr)};
    </#list>
  items.push(item);
  if (items.length >= limit) {
    return {total: 100, data: items};
  }
  </#list>
  return {total: 100, data: items};
}

/**
 * 删除【${modelbase.get_object_label(obj)}】数据。
 */
sdk.remove${dart.nameType(obj.name)} = async function (query) {
  await delay();
  return true;
}
</#list>

export default sdk;

