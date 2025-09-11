<#list model.objects as obj>
  <#if !obj.persistenceName??><#continue></#if>
DROP TABLE IF EXISTS ${obj.persistenceName?upper_case};
</#list>

<#list model.objects as obj>
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
-- ${obj.text!''}
CREATE TABLE ${obj.persistenceName?upper_case} (
    <#list attrIds as attr>
      <#assign domaintype = attr.constraint.domainType.name>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?upper_case?right_pad(16)}${r"VARCHAR(64)"?right_pad(16)}NOT NULL<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>
      <#elseif domaintype == 'datetime' || domaintype == 'now' || domaintype == 'lmt'>
  ${attr.persistenceName?upper_case?right_pad(16)}TIMESTAMP<#if attr?index != attrNids?size - 1>,</#if>
      <#else>
  ${attr.persistenceName?upper_case?right_pad(16)}${(typebase.typename(domaintype, "sql")?upper_case)?right_pad(16)}NOT NULL<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domaintype = attr.constraint.domainType.toString()>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?upper_case?right_pad(16)}VARCHAR(64)<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domaintype == 'datetime' || domaintype == 'now' || domaintype == 'lmt'>
  ${attr.persistenceName?upper_case?right_pad(16)}TIMESTAMP<#if attr?index != attrNids?size - 1>,</#if>
      <#else>
  ${attr.persistenceName?upper_case?right_pad(16)}${(typebase.typename(domaintype, "sql")!domaintype)?upper_case}<#if attr?index != attrNids?size - 1>,</#if>
      </#if>
    </#list>
);

ALTER TABLE ${obj.persistenceName?upper_case} ADD CONSTRAINT PK_${obj.persistenceName?upper_case} PRIMARY KEY (<#list attrIds as attrId>${attrId.persistenceName?upper_case}<#if attrId?index != attrIds?size - 1>,</#if></#list>);

  </#if>
</#list>
