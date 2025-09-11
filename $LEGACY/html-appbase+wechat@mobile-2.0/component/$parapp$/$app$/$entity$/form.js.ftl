<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
const moment = require('../../../../vendor/moment/moment.min.js');
const { stdbiz } = require('../../../../common/${parentApplication}/remote-${app.name}.es6');

Component({

  properties: {
    
    formId: {
      type: 'string'
    },

    ${modelbase.get_attribute_sql_name(attrId)}: {
      type: 'string'
    },
  },

  data: {
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.constraint.domainType.name?index_of('enum') == 0>
    ${attr.name?upper_case}_VALUES: ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}_VALUES,

  </#if>
</#list>    
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
    /*
    ** ${modelbase.get_attribute_label(attr)}
    */
  <#if attr.type.collection>
    ${modelbase.get_attribute_sql_name(attr)}: [],
  <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
    ${modelbase.get_attribute_sql_name(attr)}: '2000-01-01',
  <#elseif attr.constraint.domainType.name?index_of('enum') == 0>
    ${modelbase.get_attribute_sql_name(attr)}: '',
    ${modelbase.get_attribute_sql_name(attr)}Text: '未知',
  <#else>
    ${modelbase.get_attribute_sql_name(attr)}: '',
  </#if>
</#list>    
  },

  methods: {
    /*
    ** 显示编辑表单。
    */
    show: async function(params) {
      params = params || {};
      if (!params.${modelbase.get_attribute_sql_name(attrId)}) return;

      let resp = await ${parentApplication}.${app.name}.read${js.nameType(entity.name)}(params);
      let data = resp.data;
      if (!data) return;

      this.setData({
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if attr.type.name == 'date' || attr.type.name == 'datetime'>
        ${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)} ? moment(data.${modelbase.get_attribute_sql_name(attr)}).format('YYYY-MM-DD') : '2000-01-01',
  <#elseif attr.constraint.domainType.name?index_of('enum') == 0>
        ${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
        ${modelbase.get_attribute_sql_name(attr)}Text: data.${modelbase.get_attribute_sql_name(attr)} ? ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}[data.${modelbase.get_attribute_sql_name(attr)}].text : '未知',
  <#else>
        ${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
  </#if>
</#list>
      });        
    },

    /*
    ** 保存.
    */
    save: async function() {
      let params = {
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.type.collection><#continue></#if>
        ${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
</#list>        
      };
      let persisted = await ${parentApplication}.${app.name}.save${js.nameType(entity.name)}(params);
      this.triggerEvent('save${js.nameType(entity.name)}', persisted.data, { bubbles: true, composed: true });
    },
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.constraint.domainType.name?index_of('enum') == 0>

    onChange${js.nameType(modelbase.get_attribute_sql_name(attr))}(ev) {
      this.setData({
        ${modelbase.get_attribute_sql_name(attr)}: ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}_VALUES[ev.detail.value].value,
        ${modelbase.get_attribute_sql_name(attr)}Text: ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}_VALUES[ev.detail.value].text,
      });
    },
  <#elseif attr.type.name == 'datetime' || attr.type.name == 'date'>

    onChange${js.nameType(modelbase.get_attribute_sql_name(attr))}(ev) {
      this.setData({
        ${modelbase.get_attribute_sql_name(attr)}: ev.detail.value,
      });
    },
  </#if>
</#list>

  },
})