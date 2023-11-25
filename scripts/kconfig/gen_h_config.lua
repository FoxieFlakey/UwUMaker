#!/usr/bin/env lua5.4
-- Generates C config

function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end

  io.write("#define ")
  io.write((line:gsub("^([^=]+)=", "%1 ")))
  print()
end

for line in io.stdin:lines() do
  processOneLine(line)
end

