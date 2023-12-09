#!/usr/bin/env lua5.4

if #arg ~= 1 then
  io.stderr:write("Usage: "..arg[0].." <UwUMaker dir>\n")
  os.exit(1)
end

print(arg[1].."/lib/?.so;"..package.cpath)

