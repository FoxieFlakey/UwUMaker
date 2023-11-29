#!/usr/bin/env lua5.4

if #arg < 2 then
  io.stderr:write("Usage: "..arg[0].." <pad to> <string>\n")
  os.exit(1)
end

local padLen = tonumber(arg[1])
if not (padLen and math.type(padLen) == "integer") then
  io.stderr:write("'Pad to' is not integer\n")
  os.exit(1)
end

io.write(arg[2]..string.rep(" ", padLen - #arg[2]))
io.close()

