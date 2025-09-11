local M = {}

function M.process_request(str)
  local json = require "json"
  
  local db = require "gm/db"
  local sql = require "gm/sql"
  
  local params = json.decode(str)
  local start = params.start
  local limit = params.limit
  
  local sql_find = sql.find_${entity.name}(params)
  
  local ret, err = db.paginate(sql_find, start, limit)
  
  if err ~= nil then
    return "{\"error\":{\"code\":500,\"message\":\"" .. err .. "\"}}"
  end
  
  return json.encode(ret)
end

return M