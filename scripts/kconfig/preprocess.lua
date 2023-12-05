#!/usr/bin/env lua5.4

if #arg ~= 2 then
  io.stderr:write("Usage: "..arg[0].." <input Kconfig dir> <output dir>\n")
  os.exit(1)
end
  
local inputDir = arg[1]
local outputDir = arg[2]

local includeStack = {}

local maxDepth = 200
local maxSubstDepth = 50

function quitWithError(errmsg)
  io.stderr:write("Error: "..errmsg.."\n")
  for _, file in ipairs(includeStack) do
    io.stderr:write(("At file '%s', line %d\n"):format(file.path, file.line))
  end
  os.exit(1)
end

local substDepth = 0
function doSubst(str)
  if substDepth >= maxSubstDepth then
    quitWithError("Too many nested substitution")
  end

  substDepth = substDepth + 1
  local res = str:gsub("(%$[[]([=]*)[[](.-)[%]]%2[%]])", function (orig, _, content)
    -- Try substitute recursively
    content = doSubst(content)
    
    print("Exec: "..content)
    -- Do the substitution
    local handle<close> = assert(io.popen(content))
    local res = assert(handle:read("*a"))
    assert(handle:close())
    return res:gsub("([^\n])[\n]?$", "%1")
  end)
  substDepth = substDepth - 1
  return res
end

outputPath = outputDir.."/Kconfig"

function preprocOneFile(inputPath, outputPath)
  if #includeStack == maxDepth then
    quitWithError("Include nests too deep (recursive include??)")
  end

  local current = {
    path = inputPath,
    outputPath = outputPath,
    line = 1
  }
  table.insert(includeStack, current)

  local inputHandle<close>, err = io.open(inputPath)
  if not inputHandle then
    quitWithError(("Cannot open input '%s': %s"):format(inputPath, err))
  end
  local outputHandle<close>, err = io.open(outputPath, "w")
  if not outputHandle then
    quitWithError(("Cannot open output '%s': %s"):format(outputPath, err))
  end
    
  for line in inputHandle:lines() do
    -- Reset substDepth
    substDepth = 0
    
    -- Include detected!
    local includePath = select(2, string.match(line, "^[ ]*source[ ]*([\"\'])(.-)%1"))
    if includePath then
      -- Gsub away file name part and create directory structure UwU
      assert(os.execute("$MKDIR -p '"..outputDir.."/"..includePath:gsub("[^/]-$", "").."'"))
      preprocOneFile(inputDir.."/"..includePath, outputDir.."/"..includePath)
    else
      outputHandle:write(doSubst(line))
      outputHandle:write("\n")
    end

    current.line = current.line + 1
  end
end

-- Start preprocessing
preprocOneFile(inputDir.."/Kconfig", outputDir.."/Kconfig")




