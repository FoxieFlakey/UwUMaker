#!/usr/bin/env lua5.4
-- Generates lua config

print([[local n = {}
local m = {}
local y = {}

local M = {
  KconfigTriState = {
    n = n,
    m = m,
    y = y
  },
  config = {
]])

function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end

  local name, value = line:match("^([^=]-)=(.*)$")
  if not name then
    return
  end
  print(("    [%q] = %s,"):format(name, value))
end

for line in io.stdin:lines() do
  processOneLine(line)
end

print([[  }
}
return M]])

