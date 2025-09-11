<#import "/$/modelbase.ftl" as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
local M = {}

function M.process_request(str)
  local json = require "json"
  
  local util = require "gm/util"
  local db = require "gm/db"
  local sql = require "gm/sql"
  
  local params = json.decode(str)
  
  local id = params["${modelbase.get_attribute_sql_name(attrId)}"]
  if util.is_empty(id) then
    return "{\"error\":{\"code\":500,\"message\":\"没有传入任何数据标识符！\"}}"
  end

  local sql_find = sql.find_${entity.name}(params)
  
  local found, err = db.single(sql_find)
  
  local ret = {}
  ret.data = found;
  return json.encode(ret)
end

return M