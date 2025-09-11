<#import "/$/modelbase.ftl" as modelbase>
const sdk = {
  options: {},
};
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#if modelbase.is_root_object(obj) != true><#continue></#if>
  <#assign plural = modelbase.get_object_plural(obj)>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

/*!
** 获取【${modelbase.get_object_label(obj)}】单条数据。
*/
sdk.fetch${js.nameType(obj.name)} = async function(params) {
  return xhr.post({
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>find<#else>get</#if>',
    params: {
  <#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
  <#list obj.attributes as attr>
    <#if attr.type.componentType??>
      <#assign compOrigObj = modelbase.get_original_object_from_object_name(attr.type.componentType.name)>
      '<<stdbiz/${modelbase.get_object_module(compOrigObj)}/${compOrigObj.name}/find': {
        _source_field: '${modelbase.get_attribute_sql_name(idAttrs[0])}',
        _target_field: '${modelbase.get_attribute_sql_name(idAttrs[0])}',
        _result_name: '${js.nameVariable(attr.name)}',
      <#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
      </#list>
      },
    </#if>
  </#list>    
    },
  });
};

/*!
** 获取【${modelbase.get_object_label(obj)}】集合数据。
*/
sdk.fetch${js.nameType(plural)} = function(params, start, limit) {
  if (!start) {
    return xhr.post({
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>find<#else>get</#if>',
      params: {
        ...params,
      },
    });
  }
  return xhr.post({
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>paginate<#else>get</#if>',
    params: {
      ...params,
      start: start,
      limit: limit,
    },
  });
};

/*!
** 保存【${modelbase.get_object_label(obj)}】数据。
*/
sdk.save${js.nameType(obj.name)} = async function(params) {
  return xhr.post({
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/merge',
    params: {
      ...params,
  <#list obj.attributes as attr>
    <#if attr.type.componentType??>
      <#assign compOrigObj = modelbase.get_original_object_from_object_name(attr.type.componentType.name)>
      <#assign pluralCompOrigObj = modelbase.get_object_plural(compOrigObj)>
      '||stdbiz/${modelbase.get_object_module(compOrigObj)}/${compOrigObj.name}/merge': {
        ${js.nameVariable(pluralCompOrigObj)}: params.${js.nameVariable(attr.name)},
      },
    </#if>
  </#list>    
    },
  });
};

/*!
** 删除【${modelbase.get_object_label(obj)}】数据。
*/
sdk.remove${js.nameType(obj.name)} = async function(params) {
  return xhr.post({
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>delete<#else>remove</#if>',
    params: {
  <#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
    },
  });
};
</#list>

if (typeof module !== 'undefined') {
  module.exports = { sdk };
}