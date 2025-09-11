<#import '/$/modelbase.ftl' as modelbase>
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
      <#assign domaintype = attr.constraint.domainType.name>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?right_pad(24)} ${r"text"?right_pad(24)} not null,
      <#else>
  ${attr.persistenceName?right_pad(24)} ${r"text"?right_pad(24)} not null,
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domaintype = attr.constraint.domainType.toString()>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?right_pad(24)} text,
      <#else>
  ${attr.persistenceName?right_pad(24)} text,
      </#if>
    </#list>
  primary key (<#list attrIds as attrId>${attrId.persistenceName}<#if attrId?index != attrIds?size - 1>,</#if></#list>)
);
  </#if>
</#list>
