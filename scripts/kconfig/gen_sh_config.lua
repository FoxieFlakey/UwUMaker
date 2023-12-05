#!/usr/bin/env lua5.4
-- Generates shell config

function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end

  print(line)
end

for line in io.stdin:lines() do
  processOneLine(line)
end

