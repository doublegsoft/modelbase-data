<#import '/$/modelbase.ftl' as modelbase>


## 表设计

<#list model.objects as obj>
  <#if obj.isLabelled('generated') || !obj.isLabelled('persistence')><#continue></#if>
  <#assign idAttrs = []>
  <#assign nonIdAttrs = []>
  <#list obj.attributes as attr>
    <#if attr.persistenceName??>
      <#if attr.identifiable>
        <#assign idAttrs = idAttrs + [attr]>
      <#else>
        <#assign nonIdAttrs = nonIdAttrs + [attr]>
      </#if>
    </#if>
  </#list>
### ${modelbase.get_object_persistence_text(obj)}表

表名：${obj.persistenceName}

| 列名                    | 数据类型                | 约束                    | 说明                   |
|------------------------|------------------------|------------------------|------------------------|
  <#list idAttrs as idAttr>
    <#assign domaintype = idAttr.constraint.domainType.name>
    <#if domaintype?index_of('&') == 0>
|${idAttr.persistenceName?right_pad(24)}|${r"varchar(64)"?right_pad(24)}|${r"PK"?right_pad(24)}|${modelbase.get_attribute_label(idAttr)?right_pad(24)}|
    <#else>
|${idAttr.persistenceName?right_pad(24)}|${(typebase.typename(domaintype, "sql")!'varchar(64)')?right_pad(24)}|${r"PK"?right_pad(24)}|${modelbase.get_attribute_label(idAttr)?right_pad(24)}|
    </#if>
  </#list>
  <#list nonIdAttrs as nonIdAttr>
    <#assign domaintype = nonIdAttr.constraint.domainType.toString()>
    <#if domaintype?index_of('&') == 0>
|${nonIdAttr.persistenceName?right_pad(24)}|${r"varchar(64)"?right_pad(24)}|${r""?right_pad(24)}|${modelbase.get_attribute_label(nonIdAttr)?right_pad(24)}|
    <#else>
|${nonIdAttr.persistenceName?right_pad(24)}|${(typebase.typename(domaintype, "sql")!domaintype)?right_pad(24)}|${r""?right_pad(24)}|${modelbase.get_attribute_label(nonIdAttr)?right_pad(24)}|
    </#if>
  </#list>

</#list>