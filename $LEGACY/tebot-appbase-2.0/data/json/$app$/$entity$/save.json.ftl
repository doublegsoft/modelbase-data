<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
{
  "data": {
    "${modelbase.get_attribute_sql_name(attrId)}":"123456"
  }
}