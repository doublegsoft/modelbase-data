<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4sql.ftl' as modelbase4sql>
<#list model.objects as obj>
  <#if !obj.isLabelled('persistence') || obj.isLabelled('generated')><#continue></#if>
  <#if obj.persistenceName??>
    <#assign attrIds = []>
    <#assign attrNids = []>
    <#list obj.attributes as attr>
      <#if attr.persistenceName??>
        <#if attr.identifiable>
          <#assign attrIds = attrIds + [attr]>
        <#else>
          <#assign attrNids = attrNids + [attr]>
        </#if>
      </#if>
    </#list>
-- ${modelbase.get_object_persistence_text(obj)}
create table ${obj.persistenceName} (
    <#list attrIds as attr>
      <#assign sqlType = modelbase4sql.type_attribute_sqlite(attr)>
  ${attr.persistenceName?right_pad(24)} ${sqlType?right_pad(24)} not null,
    </#list>
    <#list attrNids as attr>
      <#assign sqlType = modelbase4sql.type_attribute_sqlite(attr)>
  ${attr.persistenceName?right_pad(24)} ${sqlType},
    </#list>
  primary key (<#list attrIds as attrId>${attrId.persistenceName}<#if attrId?index != attrIds?size - 1>,</#if></#list>)
);
  </#if>
</#list>
