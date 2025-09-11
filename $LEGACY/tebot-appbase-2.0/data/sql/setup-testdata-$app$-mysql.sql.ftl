<#import '/$/modelbase.ftl' as modelbase>
<#function get_named_entity(attr)>
  <#if attr.type.custom>
    <#assign obj = model.findObjectByName(attr.type.name)>
    <#assign objId = modelbase.get_id_attributes(obj)[0]>
    <#return obj.persistenceName + '#' + objId.persistenceName>
  <#elseif attr.type.name == 'uuid'>
    <#return 'sequence'>
  <#elseif attr.getLabelledOptions('reference')['value']! == 'id'>
    <#return 'sequence'>
  <#elseif attr.getLabelledOptions('reference')['value']! == 'type'>
    <#return 'string'>
  <#elseif attr.name == 'id_card_number'>
    <#return 'id_card_number'>
  <#elseif attr.name == 'mobile'>
    <#return 'mobile'>
  <#elseif attr.constraint.domainType.name?contains("person")>
    <#return 'person'>
  <#elseif attr.constraint.domainType.name?contains("department")>
    <#return 'department'>
  <#elseif attr.constraint.domainType.name?contains("enum")>
    <#return 'enum'>
  <#elseif attr.constraint.domainType.name == 'state'>
    <#return 'constant'>
  <#elseif attr.constraint.domainType.name == 'json'>
    <#return 'string'>
  <#elseif attr.type.name == 'datetime'>
    <#return 'datetime'>
  <#elseif attr.type.name == 'date'>
    <#return 'date'>
  <#elseif attr.type.name == 'number'>
    <#return 'number'>
  <#elseif attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return 'integer'>
  </#if>
  <#return 'string'>
</#function>
${tatabase.clear()!}
<#assign COUNT = 10>
<#assign Timestamp = statics['java.sql.Timestamp']>
<#list model.objects as obj>
  <#if !obj.persistenceName??><#continue></#if>
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign namedEntity = get_named_entity(attr)>
    <#if attr.constraint.identifiable>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'sequence', COUNT, '')}
    <#elseif attr.type.custom>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'sequence', COUNT, '')}
    <#elseif attr.name == 'state'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'constant', COUNT, 'E')}
    <#elseif attr.type.name == 'bool'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'constant', COUNT, 'T')}
    <#elseif namedEntity == 'string'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'string', COUNT, ((attr.type.length!100) / 10)?string)}
    <#elseif namedEntity == 'json'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'string', COUNT, ((attr.type.length!100) / 10)?string)}
    <#elseif namedEntity == 'enum'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'enum', COUNT, attr.constraint.domainType.name)}
    <#elseif namedEntity == 'number'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'number', COUNT, '')}
    <#elseif namedEntity == 'date' || namedEntity == 'datetime' || namedEntity == 'time'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, namedEntity, COUNT, '2000-01-01 12:00:00')}
    <#elseif attr.type.name == 'integer' || attr.type.name == 'int'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'constant', COUNT, '20')}
    <#elseif attr.constraint.domainType.name == 'state'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'constant', COUNT, 'E')}
    <#elseif attr.constraint.domainType.name == 'text'>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, 'constant', COUNT, '这是一个文本')}
    <#else>
      ${tatabase.build(obj.persistenceName, attr.persistenceName, namedEntity, COUNT, '')}
    </#if>
  </#list>
</#list>

<#list model.objects as obj>
  <#if !obj.persistenceName??><#continue></#if>
  <#assign rows = tatabase.values(obj.persistenceName)>
  <#list rows as row>
insert into ${obj.persistenceName} (<#list row?keys as key>${key}<#if key?index != row?keys?size - 1>,</#if></#list>)
values (<#list row?keys as key>'${row[key]}'<#if key?index != row?keys?size - 1>,</#if></#list>);
  </#list>
  <#assign attrJson = []>
  <#list obj.attributes as attr>
    <#if attr.persistenceName?? && attr.constraint.domainType.name == 'json'>
      <#assign attrJson = attrJson + [attr]>
    </#if>
  </#list>
  <#list attrJson as attr>
update ${obj.persistenceName} set ${attr.persistenceName} = '{}';
  </#list>
</#list>