#!/usr/bin/env lua5.4
-- FIXME: This is ugliest lua script I ever created TwT

local ExtraStringOps<const> = require("lua.ExtraStringOps")

function forEachObject(outputNamePaths, f)
  for outputNamePath in outputNamePaths:gmatch("[^ ]+") do
    f(outputNamePath)
  end
end

-- Generate link_rules.mak include paths for each output name
function genIncludes(outputNamePaths)
  local includes = ""
  for outputNamePath in outputNamePaths:gmatch("[^ ]+") do
    -- Replace basename with link_rules.mak
    local linkRulesPath = outputNamePath:match("^(.-)/[^/]+$").."/link_rules.mak"
    includes = includes.." "..linkRulesPath
  end
  return includes
end

local ALWAYS_OBJECTS<const> = assert(os.getenv("ALWAYS_OBJECTS"), "Please set ALWAYS_OBJECTS env")
local STATIC_OBJECTS<const> = assert(os.getenv("STATIC_OBJECTS"), "Please set STATIC_OBJECTS env")
local SHARED_OBJECTS<const> = assert(os.getenv("SHARED_OBJECTS"), "Please set SHARED_OBJECTS env")

local LINK_OUTPUT<const> = assert(os.getenv("LINK_OUTPUT"), "Please set LINK_OUTPUT env")
local ARCHIVE_NAME<const> = assert(os.getenv("ARCHIVE_NAME"), "Please set ARCHIVE_NAME env")
local COMPILE_COMMANDS_FILES<const> = assert(os.getenv("COMPILE_COMMANDS_FILES"), "Please set COMPILE_COMMANDS_FILES env")
local LINK_FLAGS<const> = assert(os.getenv("LINK_FLAGS"), "Please set LINK_FLAGS env")
local OUTPUT_TYPE<const> = assert(os.getenv("OUTPUT_TYPE"), "Please set OUTPUT_TYPE env")
local SAVE_AS<const> = assert(os.getenv("SAVE_AS"), "Please set SAVE_AS env")
local STATIC_LIB_EXTENSION<const> = assert(os.getenv("STATIC_LIB_EXTENSION"), "Please set STATIC_LIB_EXTENSION env")
local SHARED_LIB_EXTENSION<const> = assert(os.getenv("SHARED_LIB_EXTENSION"), "Please set SHARED_LIB_EXTENSION env")
local IS_SUBPROJECT<const> = tonumber((assert(os.getenv("IS_SUBPROJECT"), "Please set IS_SUBPROJECT env"))) > 0
local COMPILE_COMMANDS_JSON_OUTPUT<const> = assert(os.getenv("COMPILE_COMMANDS_JSON_OUTPUT"), "Please set COMPILE_COMMANDS_JSON_OUTPUT env")
local OBJS_DIR<const> = assert(os.getenv("OBJS_DIR"), "Please set OBJS_DIR env")

local SUBDIR<const> = assert(os.getenv("SUBDIR"), "Please export SUBDIR env")
local IS_TOP_SUBDIR<const> = SUBDIR == "/"

local linkerFlags = LINK_FLAGS

-- Generate link flags from SHARED_OBJECTS
forEachObject(SHARED_OBJECTS, function (obj)
  linkerFlags = linkerFlags..((" -L$(dir $(shell cat %s)) -l$(patsubst lib%%"..SHARED_LIB_EXTENSION..",%%,$(notdir $(shell cat %s)))"):format(obj, obj))
end)

-- Generate link flags from STATIC_OBJECTS
forEachObject(STATIC_OBJECTS, function (obj)
  linkerFlags = linkerFlags.." $(shell cat "..obj..")"
end)

local linkPrereqs = ""
local subProjectCheckSelfDeps = ""
forEachObject(SHARED_OBJECTS.." "..STATIC_OBJECTS, function (obj)
  linkPrereqs = linkPrereqs.." $(shell cat "..obj..")"
  if ExtraStringOps.isPrefixedBy(OBJS_DIR, obj) then
    subProjectCheckSelfDeps = subProjectCheckSelfDeps.." /check_self/$(shell cat "..obj..")"
  end
end)

forEachObject(ALWAYS_OBJECTS, function (obj)
  if ExtraStringOps.isPrefixedBy(OBJS_DIR, obj) then
    subProjectCheckSelfDeps = subProjectCheckSelfDeps.." /check_self/$(shell cat "..obj..")"
  end
end)

local LINK_FLAGS<const> = linkerFlags
linkerFlags = nil

local makeIncludes = ""
makeIncludes = makeIncludes.." "..genIncludes(ALWAYS_OBJECTS)
makeIncludes = makeIncludes.." "..genIncludes(SHARED_OBJECTS)
makeIncludes = makeIncludes.." "..genIncludes(STATIC_OBJECTS)
makeIncludes = makeIncludes.." "..os.getenv("EXTRA_INCLUDES")

local output = ""
function appendOutput(str)
  output = output..str
end

-- Generate suitable rules for
-- these types
function link_executable()
  appendOutput("\t$Q$(PRINT_STATUS) LD 'Linking $(@:$(abspath "..OBJS_DIR..")%=%)'\n")
	appendOutput("\t$Q"..os.getenv("AR").." t "..ARCHIVE_NAME.." | xargs "..os.getenv("CC").." "..LINK_FLAGS.." -o $@\n")
end

function link_shared_lib()
  appendOutput("\t$Q$(PRINT_STATUS) LD 'Linking $(@:$(abspath "..OBJS_DIR..")%=%)'\n")
	--appendOutput("\t$Q"..os.getenv("LD").." --whole-archive "..LINK_FLAGS.." -shared "..ARCHIVE_NAME.." -o $@\n")
  appendOutput("\t$Q"..os.getenv("AR").." t "..ARCHIVE_NAME.." | xargs "..os.getenv("CC").." "..LINK_FLAGS.." -shared -o $@\n")
end

function link_archive()
  appendOutput("\t$Q$(PRINT_STATUS) AR 'Archiving $(@:$(abspath "..OBJS_DIR..")%=%)'\n")
  appendOutput("\t$Q$(RM) -f -- $@\n")
	appendOutput("\t$Q"..os.getenv("AR").." t "..ARCHIVE_NAME.." | xargs "..os.getenv("AR").." rcsP $@ \n")
  appendOutput("\t$Q$(PRINT_STATUS) OBJCOPY 'Hiding symbols of $(@:$(abspath "..OBJS_DIR..")%=%)'\n")
	appendOutput("\t$Q"..os.getenv("OBJCOPY").." --localize-hidden $@\n")
end

local includeGuardName<const> = "GUARD_"..SAVE_AS:gsub("[^a-zA-Z0-9]", "_")

appendOutput("#######################################\n")
appendOutput("ifndef "..includeGuardName.."\n")
appendOutput(includeGuardName.." := y\n")

appendOutput("include "..makeIncludes.."\n")

appendOutput("#### Always to be updated objects\n")
forEachObject(ALWAYS_OBJECTS, function (obj)
  appendOutput("ALWAYS_UPDATE += $(shell cat "..obj..")\n")
end)
appendOutput("#### Compile command files appending\n")
appendOutput("COMPILE_COMMANDS_FILES += "..COMPILE_COMMANDS_FILES.."\n")

appendOutput("#### Check project rule deps (the actual check shown as additional /do_check_self/% is there to allow parallelization)\n")
appendOutput(".PHONY: /check_self/"..LINK_OUTPUT.."\n")
appendOutput("/check_self/"..LINK_OUTPUT..": "..subProjectCheckSelfDeps.." /do_check_self/"..LINK_OUTPUT.."\n")

-- Only top subdir can generate link output
if IS_TOP_SUBDIR then
  appendOutput("#### Link output rule\n")
  appendOutput(LINK_OUTPUT..": export SUBPROJECT := "..os.getenv("SUBPROJECT").."\n")
  appendOutput(LINK_OUTPUT..": "..ARCHIVE_NAME.." "..linkPrereqs.."\n")
  if OUTPUT_TYPE == "y" then
    link_executable()
  elseif OUTPUT_TYPE == "m" then
    link_shared_lib()
  elseif OUTPUT_TYPE == "n" then
    link_archive()
  else
    error("Unknown type "..OUTPUT_TYPE)
  end

  appendOutput("#### Actually do the project check rule\n")
  appendOutput("#### If subproject compilation depends on another\n")
  appendOutput("#### subproject like compile e.g. compile a header\n")
  appendOutput("#### generator or source gen add to this deps \n")
  appendOutput(".PHONY: /do_check_self/"..LINK_OUTPUT.."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT := "..os.getenv("SUBPROJECT").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT_SHARED_CACHE_DIR := "..os.getenv("SHARED_CACHE_DIR").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT_CACHE_DIR := "..os.getenv("CACHE_DIR").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT_LANG_RULES_DIR := "..os.getenv("LANG_RULES_DIR").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT_DOTCONFIG_PATH := "..os.getenv("DOTCONFIG_PATH").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT_BUILD_DIR := "..os.getenv("BUILD_DIR").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": export SUBPROJECT_DIR := "..os.getenv("PROJECT_DIR").."\n")
  appendOutput("/do_check_self/"..LINK_OUTPUT..": \n")
  appendOutput("\t$Q$(MAKE) -f makefiles/subdir/call_subproj_trampoline.mak cmd_compile_project\n")

  appendOutput("#### Compile command.json rule\n")
  appendOutput(COMPILE_COMMANDS_JSON_OUTPUT..": $(COMPILE_COMMANDS_FILES)\n")
  appendOutput("\t"..os.getenv("Q")..os.getenv("LUA").." scripts/subdir/merge_compile_command_json.lua $^ > $@\n")
end

if not IS_SUBPROJECT and IS_TOP_SUBDIR then 
  appendOutput("#### Common name to run goals needed\n")
  appendOutput(".PHONY: cmd_run\n")
  appendOutput("cmd_run: /check_self/"..LINK_OUTPUT.." .WAIT $(ALWAYS_UPDATE) "..LINK_OUTPUT.." .WAIT "..COMPILE_COMMANDS_JSON_OUTPUT.."\n")
  appendOutput("\t@:\n")
end

appendOutput("endif\n")
appendOutput("#######################################\n")

local outputHandle<close> = assert(io.open(SAVE_AS, "w"))
assert(outputHandle:write(output))
outputHandle:close()







