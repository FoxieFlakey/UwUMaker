#!/usr/bin/env lua5.4
local JSON = require("lua.json")

if #arg == 0 then
  print("[]")
  return
end

local final = {}

for _, file in ipairs(arg) do
  local file<close> = assert(io.open(file))
  local data = JSON.decode(file:read("*a"))
  file:close()
  
  if #data > 0 then
    -- Its array
    for _, entry in ipairs(data) do
      table.insert(final, entry)
    end
  else
    table.insert(final, data)
  end
end

print(JSON.encode(final))

