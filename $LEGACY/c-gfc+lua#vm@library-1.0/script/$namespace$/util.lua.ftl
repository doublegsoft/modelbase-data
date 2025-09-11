local M = {}

function M:is_empty(val)
  return val == nil or val == ""
end

function M:count_array(val)
  local ret = 0
  local index
  for index in pairs(groups) do
    ret = ret + 1
  end
  return ret
end

return M