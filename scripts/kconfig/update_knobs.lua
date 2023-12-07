#!/usr/bin/env lua5.4

-- Deletes and touch $(KCONFIG_KNOBS_DIR) accordingly
-- to changes in $(DOTCONFIG_PATH)

local knobsPath = os.getenv("KCONFIG_KNOBS_DIR")
local dotConfigPath = os.getenv("DOTCONFIG_PATH")

function process(key, value)
  local path = knobsPath.."/"..key
  local knob = io.open(path, "r+")
  if not knob then
    knob = assert(io.open(path, "w+"))
  end
  
  local knob<close> = knob
  local knobVal = assert(knob:read("*a"))
  assert(knob:close())
  
  if knobVal ~= value then
    local truncatedKnob<close> = assert(io.open(path, "w"))
    assert(truncatedKnob:write(value))
  end
end

function syncConfig(config)
  for _, entry in ipairs(config) do
    process(entry.key, entry.value)
  end
end

local configMap = {}
do
  local configFile<close> = assert(io.open(dotConfigPath))
  local config = {}

  for line in assert(configFile:lines()) do
    if line:sub(1,1) ~= "#" and line:match("^CONFIG_") ~= nil then
      local key, value = line:match("^([^=]-)=(.*)$")
      table.insert(config, {
        key = key,
        value = value
      })
      configMap[key] = value
    end
  end

  syncConfig(config)
end

do
  local knobs<close> = assert(io.popen("find '"..knobsPath.."' -name 'CONFIG_*' -type f -exec basename {} ';'"))
  local config = {}

  for knob in assert(knobs:lines()) do
    -- The option became unset
    if configMap[knob] == nil then
      table.insert(config, {
        key = knob,
        value = ""
      })
    end
  end

  assert(knobs:close())
  syncConfig(config)
end

