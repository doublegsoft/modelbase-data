local M = {}

function M.process_request(str)
  local json = require "json"
  
  local db = require "gm/db"
  local sql = require "gm/sql"
  
  local params = json.decode(str)
  
  local sql_find = sql.find_${entity.name}(params)
  
  local rows, err = db.many(sql_find)
  
  if err ~= nil then
    return "{\"error\":{\"code\":500,\"message\":\"" .. err .. "\"}}"
  end
  
  local ret = {}
  ret.data = rows;
  return json.encode(ret)
end

return M