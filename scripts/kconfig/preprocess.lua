#!/usr/bin/env lua5.4
-- Input in stdin and output at stdout
-- also follows includes

local vars = setmetatable({}, {
  __index = function (self, key)
    return os.getenv(key)
  end
})

-- Control how deep includes goes
local depth = 0
local maxDepth = 200
local includeStack = {}

for line in io.stdin:lines() do
  print(line) 
end






