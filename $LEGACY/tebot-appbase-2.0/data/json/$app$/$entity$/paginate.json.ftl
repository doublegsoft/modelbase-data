<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
{
  "total": 100,
  "data": [{
    "${modelbase.get_attribute_sql_name(attrId)}":"123456"
  }]
}