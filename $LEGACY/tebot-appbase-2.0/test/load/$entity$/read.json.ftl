<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
{
  "${modelbase.get_attribute_sql_name(attrId)}": "001"
}