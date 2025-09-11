<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
const { stdbiz } = require('../../../../common/${parentApplication}/remote-${app.name}.es6');

Component({
  
  data: {
<#list entity.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
    /*
    ** ${modelbase.get_attribute_label(attr)}
    */
  <#if attr.type.collection>
    ${modelbase.get_attribute_sql_name(attr)}: [],
  <#else>
    ${modelbase.get_attribute_sql_name(attr)}: '',
  </#if>
</#list>    
  },

  methods: {

    /*
    ** 显示只读表单。
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
        ${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
</#list>
      });      
    }

  }

})