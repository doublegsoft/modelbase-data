<#import "/$/modelbase.ftl" as modelbase>
<#list model.objects as obj>

/*!
** 【${modelbase.get_object_label(obj)}】
*/
class ${ts.nameType(obj.name)} {
  <#list obj.attributes as attr>

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${modelbase.get_attribute_sql_name(attr)}: string;
  </#list>
  
  <#assign size = obj.attributes?size>
  constructor({<#list obj.attributes as attr>${modelbase.get_attribute_sql_name(attr)}<#if attr?index != (size - 1)>, </#if></#list>}: {<#list obj.attributes as attr>${modelbase.get_attribute_sql_name(attr)}?: string<#if attr?index != (size - 1)>, </#if></#list>} = {}) {
    <#list obj.attributes as attr>
    this.${modelbase.get_attribute_sql_name(attr)} = ${modelbase.get_attribute_sql_name(attr)};
    </#list>
  }
}
</#list>