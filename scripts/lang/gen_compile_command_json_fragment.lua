#!/usr/bin/env lua5.4
local JSON = require("lua.json")

if #arg ~= 4 then
  io.stderr:write("Usage: "..arg[0].." <directory> <file> <output> <command>\n")
  os.exit(1)
end

local fragment = {
  directory = arg[1],
  file = arg[2],
  output = arg[3],
  command = arg[4],
}

print(JSON.encode(fragment))

