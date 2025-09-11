<#import '/$/modelbase.ftl' as modelbase>
local M = {}

local util = require('${namespace}/util')

local function sql_value(val, default)
  if util.is_empty(val) then
    return default
  end
  return "'" .. val .. "'"
end

<#list model.objects as obj>
  <#if !obj.isLabelled('persistence')><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign attrRows = []>
  <#assign attrRow = []>
  <#assign attrCount = 0>
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign attrRow = attrRow + [attr]>
    <#assign attrCount = attrCount + 1>
    <#if attrRow?size % 4 == 0>
      <#assign attrRows = attrRows + [attrRow]>
      <#assign attrRow = []>
    </#if>
  </#list>
  <#if attrRow?size != 0>
    <#assign attrRows = attrRows + [attrRow]>
  </#if>

--
-- the insert sql to create a ${obj.name} entity object.
--
function M.insert_${obj.name}(data)
  local ret = ""
  ret = ret .. "insert into ${obj.persistenceName} ("
  <#assign attrIndex = 0>
  <#list attrRows as attrRow>
  ret = ret .. "  <#list attrRow as attr>${attr.persistenceName}<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list>"
  </#list>
  ret = ret .. ") values ("
  <#assign attrIndex = 0>
  <#list attrRows as attrRow>
  ret = ret .. "  <#list attrRow as attr>" .. sql_value(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(attr))}"], "null") .. "<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list> "
  </#list>
  ret = ret ..")"
  return ret
end

--
-- the update sql to update a ${obj.name} entity object.
--
function M.update_${obj.name}(data)
  local ret = ""
  ret = ret .. "update ${obj.persistenceName} "
  <#assign attrIndex = 0>
  <#list attrRows as attrRow>
  ret = ret .. "<#if attrRow?index == 0>set    <#else>       </#if><#list attrRow as attr>${attr.persistenceName} = " .. sql_value(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(attr))}"], "${attr.persistenceName}") .. "<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list> "
  </#list>
  ret = ret ..  "where  <#list idAttrs as idAttr><#if idAttr?index != 0> and </#if>${idAttr.persistenceName} = "  .. sql_value(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(idAttr))}"], "${idAttr.persistenceName}") .. "</#list>\n";
  return ret
end

--
-- the select sql to find ${obj.name} entity objects.
--
function M.find_${obj.name}(data)
  local ret = ""
  <#assign attrIndex = 0>
  <#list attrRows as attrRow>
  ret = ret .. "<#if attrRow?index == 0>select <#else>       </#if><#list attrRow as attr>${attr.persistenceName} as \"${js.nameVariable(modelbase.get_attribute_sql_plain_name(attr))}\"<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list> "
  </#list>
  ret = ret .. "from   ${obj.persistenceName} "
  ret = ret .. "where  1 = 1 "
  <#list idAttrs as idAttr>
  if not util.is_empty(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(idAttr))}"]) then
    ret = ret .. "and    ${idAttr.persistenceName} = " .. sql_value(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(idAttr))}"], "null") .. " "
  end
  </#list>
  <#list obj.attributes as attr>
    <#if !attr.persistenceName?? || !attr.getLabelledOptions('persistence')['query']??><#continue></#if>
  if not util.is_empty(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(attr))}"]) then
    ret = ret .. "and    ${attr.persistenceName} = " .. sql_value(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(attr))}"], "null") .. " "
  end
  </#list>
  return ret
end

--
-- the delete sql to delete a ${obj.name} entity object.
--
function M.delete_${obj.name}(data)
  local ret = ""
  ret = ret .. "delete from ${obj.persistenceName} \n"
  ret = ret .. "where  <#list idAttrs as idAttr><#if idAttr?index != 0> and </#if>${idAttr.persistenceName} = " .. sql_value(data["${js.nameVariable(modelbase.get_attribute_sql_plain_name(idAttr))}"], "${idAttr.persistenceName}") .. "</#list>\n";
  return ret
end

</#list>
return M