#!/usr/bin/env lua5.4
-- Generates lua config

print([[local n = 0
local m = 1
local y = 2

local M = {]])

function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end

  local name, value = line:match("^([^=]+)=(.+)$")
  print(("  [%q] = %s,"):format(name, value))
end

for line in io.stdin:lines() do
  processOneLine(line)
end

print([[}
return M]])

