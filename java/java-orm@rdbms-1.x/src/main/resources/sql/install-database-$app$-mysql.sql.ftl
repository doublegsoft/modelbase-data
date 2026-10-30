<#import '/$/modelbase.ftl' as modelbase>
<#if globalIdType??>
  <#if globalIdType == "string">
    <#assign sqlIdType = "varchar(32)">
  <#else>
    <#assign sqlIdType = "bigint">
  </#if>
<#else>
  <#assign sqlIdType = "bigint">
</#if>
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
      <#assign domainType = attr.constraint.domainType.name>
      <#if domainType?index_of('&') == 0>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${sqlIdType?right_pad(24)} not null<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>
      <#elseif domainType == "id">
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${sqlIdType?right_pad(24)} not null<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>    
      <#else>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${(typebase.typename(domainType, "sql")!sqlIdType)?right_pad(24)} not null<#if attr?index != attrIds?size - 1 || attrNids?size != 0>,</#if>
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domainType = attr.constraint.domainType.name>
      <#if domainType?index_of('&') == 0>
        <#assign privTypeName = modelbase.type_attribute_primitive(attr)>
        <#if privTypeName == "string">
  ${("`" + attr.persistenceName + "`")?right_pad(24)} varchar(64)<#if attr?index != attrNids?size - 1>,</#if>
        <#else>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} bigint<#if attr?index != attrNids?size - 1>,</#if>      
        </#if>
      <#elseif domainType == 'datetime' || domainType == 'now'>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} datetime(3)<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType == 'text'>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} longtext<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType?starts_with('strings')>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} varchar(${attr.type.length!"200"})<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType == 'json' || domainType?starts_with('{')>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} longtext<#if attr?index != attrNids?size - 1>,</#if>
      <#else>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${(typebase.typename(domainType, "sql")!domainType)}<#if attr?index != attrNids?size - 1>,</#if>
      </#if>
    </#list>
);

    <#list obj.attributes as attr>
      <#if !attr.persistenceName??><#continue></#if>
      <#assign domainType = attr.constraint.domainType.toString()>
      <#assign privTypeName = modelbase.type_attribute_primitive(attr)>
      <#if domainType?index_of('&') == 0 || attr.identifiable>
        <#if privTypeName == "string">
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` varchar(128)
        <#else>   
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` bigint        
        </#if>
      <#elseif domainType?starts_with('strings')>
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` varchar(${attr.type.length!"200"})
      <#elseif domainType == 'json' || domainType?starts_with('{')>
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` longtext   
      <#else>  
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` <#if domainType == 'datetime' || domainType == 'now'>datetime(3)<#elseif domainType == 'text' || domainType == 'json'>longtext<#else>${(typebase.typename(domainType, "sql")!domainType)}</#if>
      </#if>
comment '${modelbase.get_attribute_label(attr)}';
    </#list>

alter table ${obj.persistenceName} add constraint pk_${obj.persistenceName} primary key (<#list attrIds as attrId>${attrId.persistenceName}<#if attrId?index != attrIds?size - 1>,</#if></#list>);

    <#if obj.getLabelledOptions('persistence')['revision']??>
-- ${modelbase.get_object_persistence_text(obj)}
drop table if exists ${obj.getLabelledOptions('persistence')['revision']};
create table ${obj.getLabelledOptions('persistence')['revision']} (
    <#list attrIds as attr>
      <#assign domainType = attr.constraint.domainType.name>
      <#if domainType?index_of('&') == 0>
        <#assign privTypeName = modelbase.type_attribute_primitive(attr)>
        <#if privTypeName == "string">
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${r"varchar(64)"?right_pad(24)} not null,
        <#else>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${r"bigint"?right_pad(24)} not null,      
        </#if>
      <#else>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${(typebase.typename(domainType, "sql")!'bigint')?right_pad(24)} not null,
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domainType = attr.constraint.domainType.toString()>
      <#if attr.name == 'last_modified_time'>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${(typebase.typename(domainType, "sql")!domainType)} not null<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType?index_of('&') == 0>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} varchar(128)<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType == 'text'>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} longtext<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType == 'json'>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} longtext<#if attr?index != attrNids?size - 1>,</#if>
      <#elseif domainType == 'datetime' || domainType == 'now'>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} datetime(3)<#if attr?index != attrNids?size - 1>,</#if>
      <#else>
  ${("`" + attr.persistenceName + "`")?right_pad(24)} ${(typebase.typename(domainType, "sql")!domainType)}<#if attr?index != attrNids?size - 1>,</#if>
      </#if>
    </#list>
);

    <#list obj.attributes as attr>
      <#if !attr.persistenceName??><#continue></#if>
      <#assign domainType = attr.constraint.domainType.toString()>
      <#assign privTypeName = modelbase.type_attribute_primitive(attr)>
      <#if domainType?index_of('&') == 0 || attr.identifiable>
        <#if privTypeName == "string">
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` varchar(128)
        <#else>   
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` bigint        
        </#if>
      <#else>  
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` <#if domainType == 'datetime' || domainType == 'now'>datetime(3)<#elseif domainType == 'text' || domainType == 'json'>longtext<#else>${(typebase.typename(domainType, "sql")!domainType)}</#if>
      </#if>
comment '${modelbase.get_attribute_label(attr)}';
    </#list>

alter table ${obj.getLabelledOptions('persistence')['revision']} add constraint pk_${obj.getLabelledOptions('persistence')['revision']} primary key (<#list attrIds as attrId>${attrId.persistenceName},</#list>lmt);

    </#if>
  </#if>
</#list>
