#!/usr/bin/env lua5.4
-- Generates shell config

-- The .config already acceptable to shell as it is
function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end

  print(line)
end

for line in io.stdin:lines() do
  processOneLine(line)
end

