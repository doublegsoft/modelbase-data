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
  if not util.is_empty(id) then
    local sql_update = sql.update_${entity.name}(params)
    local ret, err = db.execute(sql_update)
    if err ~= nil then
      return "{\"error\":{\"code\":500,\"message\":\"" .. err .. "\"}}"
    end
    local ret = {}
    ret.data = params
    return json.encode(params)
  end
  
  params["${modelbase.get_attribute_sql_name(attrId)}"] = util.uuid()
  local sql_insert = sql.insert_${entity.name}(params)
  
  local ret, err = db.execute(sql_insert)
  
  if err ~= nil then
    return "{\"error\":{\"code\":500,\"message\":\"" .. err .. "\"}}"
  end
  
  local ret = {}
  ret.data = params
  return json.encode(ret)
end

return M