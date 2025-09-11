<#import "/$/modelbase.ftl" as modelbase>
const sdk = {
  options: {},
};
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#if modelbase.is_root_object(obj) != true><#continue></#if>
  <#assign plural = modelbase.get_object_plural(obj)>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#if obj.isLabelled("pivot")>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
    <#assign detailKeyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["key"])>
    <#assign detailValueAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["value"])>
    <#assign detailPlural = modelbase.get_object_plural(detailObj)>
    <#assign idAttrs = modelbase.get_id_attributes(masterObj)>
  </#if>

/*!
** 获取【${modelbase.get_object_label(obj)}】单条数据。
*/
sdk.fetch${js.nameType(obj.name)} = async function(params) {
  let ret = await xhr.post({
  <#if obj.isLabelled("pivot")>
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(masterObj)}/${masterObj.name}/<#if masterObj.isLabelled("entity")>find<#else>get</#if>',
  <#else>
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>find<#else>get</#if>',
  </#if>  
    params: {
  <#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
  <#if obj.isLabelled("meta")>
      '${r"<<"}stdbiz/${modelbase.get_object_module(obj)}/${obj.name}_meta/get': {
        _source_field: '${modelbase.get_attribute_sql_name(idAttrs[0])}',
        _target_field: '${modelbase.get_attribute_sql_name(idAttrs[0])}',
        _result_name: 'metas',
      <#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
      </#list>
      }
  </#if>
  <#if obj.isLabelled("pivot")>
      '${r"<<"}stdbiz/${modelbase.get_object_module(detailObj)}/${detailObj.name}/get': {
        _source_field: '${modelbase.get_attribute_sql_name(idAttrs[0])}',
        _target_field: '${modelbase.get_attribute_sql_name(idAttrs[0])}',
        _result_name: 'details',
      <#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},
      </#list>
      }
  </#if>
  <#list obj.attributes as attr>
    <#if attr.type.componentType??>
      <#assign compOrigObj = modelbase.get_original_object_from_object_name(attr.type.componentType.name)>
      '${r"<<"}stdbiz/${modelbase.get_object_module(compOrigObj)}/${compOrigObj.name}/find': {
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
  <#if obj.isLabelled('meta')>
  for (let meta of ret.metas) {
    ret[meta.metaCode] = meta.metaValue;
  }
  </#if>
  <#if obj.isLabelled('pivot')>
  for (let detail of ret.details) {
    ret[detail.${modelbase.get_attribute_sql_name(detailKeyAttr)}] = detail.${modelbase.get_attribute_sql_name(detailValueAttr)};
  }
  </#if>
  return ret;
};

/*!
** 获取【${modelbase.get_object_label(obj)}】集合数据。
*/
sdk.fetch${js.nameType(plural)} = function(params, start, limit) {
  if (!start) {
    return xhr.post({
  <#if obj.isLabelled("pivot")>
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(masterObj)}/${masterObj.name}/<#if masterObj.isLabelled("entity")>find<#else>get</#if>',
  <#else>
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>find<#else>get</#if>',
  </#if> 
      params: {
        ...params,
      },
    });
  }
  return xhr.post({
  <#if obj.isLabelled("pivot")>
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(masterObj)}/${masterObj.name}/<#if masterObj.isLabelled("entity")>paginate<#else>get</#if>',
  <#else>
      url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>paginate<#else>get</#if>',
  </#if> 
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
  <#if obj.isLabelled("meta")>
  let metas = [];
    <#list obj.attributes as attr>
  metas.push({
      <#list idAttrs as idAttr>
    ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},    
      </#list>
    metaCode: '${js.nameVariable(attr.name)}',
    metaValue: params.${js.nameVariable(attr.name)} || '',
  });  
    </#list>
  </#if>
  <#if obj.isLabelled("pivot")>
  let details = [];
    <#list obj.attributes as attr>
  details.push({
      <#list idAttrs as idAttr>
    ${modelbase.get_attribute_sql_name(idAttr)}: params.${modelbase.get_attribute_sql_name(idAttr)},    
      </#list>
    ${modelbase.get_attribute_sql_name(detailKeyAttr)}: '${js.nameVariable(attr.name)}', 
    ${modelbase.get_attribute_sql_name(detailValueAttr)}: params.${js.nameVariable(attr.name)} || 0, 
  });    
    </#list>
  </#if>
  return xhr.post({
  <#if obj.isLabelled("pivot")>
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(masterObj)}/${masterObj.name}/merge',
  <#else>
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/merge',
  </#if> 
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
  <#if obj.isLabelled("meta")>
      '||stdbiz/${modelbase.get_object_module(obj)}/${obj.name}_meta/merge': {
        ${js.nameVariable(obj.name)}Metas: metas,
      }
  </#if>
  <#if obj.isLabelled("pivot")>
      '||stdbiz/${modelbase.get_object_module(detailObj)}/${detailObj.name}/merge': {
        ${js.nameVariable(detailPlural)}: details,
      }
  </#if>
    },
  });
};

/*!
** 保存【${modelbase.get_object_label(obj)}】数据。
*/
sdk.remove${js.nameType(obj.name)} = async function(params) {
  <#list idAttrs as idAttr>
  if (!params.${modelbase.get_attribute_sql_name(idAttr)}) {
    return new Promise((resolve, reject) => {
      resolve({error: {
        code: 404,
        message: '没有设置对象标识值',
      });
    });
  }
  </#list>
  return xhr.post({
  <#if obj.isLabelled("pivot")>
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(masterObj)}/${masterObj.name}/<#if masterObj.isLabelled("entity")>delete<#else>remove</#if>',
  <#else>
    url: '/api/v3/common/script/stdbiz/${modelbase.get_object_module(obj)}/${obj.name}/<#if obj.isLabelled("entity")>delete<#else>remove</#if>',
  </#if> 
    params: {
      ...params,   
    },
  });
};
</#list>

if (typeof module !== 'undefined') {
  module.exports = { sdk };
}