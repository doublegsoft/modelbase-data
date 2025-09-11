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
drop table if exists ${obj.persistenceName};
create table ${obj.persistenceName} (
    <#list attrIds as attr>
      <#assign domaintype = attr.constraint.domainType.name>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?right_pad(24)} ${r"varchar(64)"?right_pad(24)} not null<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>
      <#else>
  ${attr.persistenceName?right_pad(24)} ${(typebase.typename(domaintype, "sql")!'varchar(64)')?right_pad(24)} not null<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domaintype = attr.constraint.domainType.toString()>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?right_pad(24)} varchar(64)<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif (typebase.typename(domaintype, "sql")!domaintype) == 'text'>
  ${attr.persistenceName?right_pad(24)} longtext<#if attr?index != attrNids?size - 1>,</#if>
      <#else>
  ${attr.persistenceName?right_pad(24)} ${(typebase.typename(domaintype, "sql")!domaintype)}<#if attr?index != attrNids?size - 1>,</#if>
      </#if>
    </#list>
);

    <#list obj.attributes as attr>
      <#if attr.persistenceName??>
        <#assign domaintype = attr.constraint.domainType.toString()>
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` ${typebase.typename(domaintype, "sql")!'varchar(64)'} comment '${modelbase.get_attribute_label(attr)}';
      </#if>
    </#list>

alter table ${obj.persistenceName} add constraint pk_${obj.persistenceName} primary key (<#list attrIds as attrId>${attrId.persistenceName}<#if attrId?index != attrIds?size - 1>,</#if></#list>);

    <#if obj.getLabelledOptions('persistence')['revision']??>
-- ${modelbase.get_object_persistence_text(obj)}
drop table if exists ${obj.getLabelledOptions('persistence')['revision']};
create table ${obj.getLabelledOptions('persistence')['revision']} (
    <#list attrIds as attr>
      <#assign domaintype = attr.constraint.domainType.name>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?right_pad(24)} ${r"varchar(64)"?right_pad(24)} not null,
      <#else>
  ${attr.persistenceName?right_pad(24)} ${(typebase.typename(domaintype, "sql")!'varchar(64)')?right_pad(24)} not null,
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domaintype = attr.constraint.domainType.toString()>
      <#if domaintype?index_of('&') == 0>
  ${attr.persistenceName?right_pad(24)} varchar(64)<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif (typebase.typename(domaintype, "sql")!domaintype) == 'text'>
  ${attr.persistenceName?right_pad(24)} longtext<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif  attr.name == 'last_modified_time'>
  ${attr.persistenceName?right_pad(24)} ${(typebase.typename(domaintype, "sql")!domaintype)} not null<#if attr?index != attrNids?size - 1>,</#if>
      <#else>
  ${attr.persistenceName?right_pad(24)} ${(typebase.typename(domaintype, "sql")!domaintype)}<#if attr?index != attrNids?size - 1>,</#if>
      </#if>
    </#list>
);

    <#list obj.attributes as attr>
      <#if attr.persistenceName??>
        <#assign domaintype = attr.constraint.domainType.toString()>
alter table `${obj.getLabelledOptions('persistence')['revision']}` change `${attr.persistenceName}` `${attr.persistenceName}` ${typebase.typename(domaintype, "sql")!'varchar(64)'} comment '${modelbase.get_attribute_label(attr)}';
      </#if>
    </#list>

alter table ${obj.getLabelledOptions('persistence')['revision']} add constraint pk_${obj.getLabelledOptions('persistence')['revision']} primary key (<#list attrIds as attrId>${attrId.persistenceName},</#list>lmt);

    </#if>
  </#if>
</#list>
