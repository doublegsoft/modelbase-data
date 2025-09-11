<#import '/$/modelbase.ftl' as modelbase>
<#list model.objects as obj>
  <#if !obj.isLabelled('persistence')><#continue></#if>
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
    <#list obj.attributes as attr>
      <#if attr.persistenceName??>
        <#assign domaintype = attr.constraint.domainType.toString()>

-- ${modelbase.get_object_persistence_text(obj)}  ${modelbase.get_attribute_label(attr)}
alter table `${obj.persistenceName}` change `${attr.persistenceName}` `${attr.persistenceName}` ${typebase.typename(domaintype, "sql")!'varchar(64)'} comment '${modelbase.get_attribute_label(attr)}';    
alter table `${obj.persistenceName}` add `${attr.persistenceName}` ${typebase.typename(domaintype, "sql")!'varchar(64)'} comment '${modelbase.get_attribute_label(attr)}';
alter table `${obj.persistenceName}` drop column `${attr.persistenceName}`;
      </#if>
    </#list>
    <#if obj.getLabelledOptions('persistence')['revision']??>

      <#list obj.attributes as attr>
        <#if attr.persistenceName??>
          <#assign domaintype = attr.constraint.domainType.toString()>
alter table `${obj.getLabelledOptions('persistence')['revision']}` change `${attr.persistenceName}` `${attr.persistenceName}` ${typebase.typename(domaintype, "sql")!'varchar(64)'} comment '${modelbase.get_attribute_label(attr)}';          
alter table `${obj.getLabelledOptions('persistence')['revision']}` add `${attr.persistenceName}` ${typebase.typename(domaintype, "sql")!'varchar(64)'} comment '${modelbase.get_attribute_label(attr)}';
alter table `${obj.getLabelledOptions('persistence')['revision']}` drop column `${attr.persistenceName}`;
        </#if>
      </#list>
    </#if>
  </#if>
</#list>
