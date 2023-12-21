#!/usr/bin/env lua5.4
-- Generates C config

function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end
  
  if not line:match("^[^=]-=.*$") then
    return
  end

  local name, value = line:match("^([^=]-)=(.*)$")
  if not name then
    return
  end
  if value == "y" then
    value = "1"
  elseif value == "n" or value == "m" then
    error("Shouldn't occur")
  end

  io.write("#define ")
  io.write(name.." "..value)
  print()
end

for line in io.stdin:lines() do
  processOneLine(line)
end

