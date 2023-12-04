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

local input = io.stdin
local output = io.stdout
local pos = {
  line = 1,
  char = 0
}

function posInfo()
  return ("%d:%d"):format(pos.line, pos.char)
end

function getChar()
  local chr = input:read(1)
  if not chr then
    io.stderr:write(posInfo()..": EOF unexpected\n")
    os.exit(1)
  end

  if chr == "\n" then
    pos.line = pos.line + 1
    pos.char = 0
  else
    pos.char = pos.char + 1
  end
  return chr
end

function expandMacro()

end

function processChar(chr)
  if chr ~= "$" then
    output:write(chr)
    return
  end

  local buffer = {}
  chr = getChar()
  if chr ~= "(" and chr ~= "$" then
    io.stderr:write(posInfo()..": Expected '(' or '$' got '"..chr.."'\n")
    os.exit(1)
  end
  
  -- Escaping the $
  if chr == "$" then
    output:write("$")
    return
  end

  -- Continue reading until matching ')'
  
  chr = getChar()
  while chr ~= ")" do
    if chr == "(" and buffer[#buffer] == "$" then
      io.stderr:write(posInfo()..": Nested macro not supported yet: "..table.concat(buffer).."\n")
      os.exit(1)
    elseif chr == "$" and buffer[#buffer] == "$" then
      -- Remove last $ (escaping $$)
      table.remove(buffer)
    end
    table.insert(buffer, chr)

    local stringStarter
    
    if chr == "\"" or chr == "\'" then
      stringStarter = chr
    end

    if stringStarter then
      while chr ~= stringStarter do
        chr = getChar()
        table.insert(buffer, chr)
      end
    end

    chr = getChar()
  end
  buffer = table.concat(buffer):sub(1, -2)

  expandMacro(buffer)
end

local chr = getChar()
while chr ~= nil do
  processChar(chr)
  chr = getChar()
end





