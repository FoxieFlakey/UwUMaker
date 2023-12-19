#!/usr/bin/env lua5.4
-- Generates Rust config
-- TODO: A way to tell whether its bool or tristate

print([[#![allow(unused)]
#![allow(dead_code)]
pub enum KConfigTriState {
  No,
  Mod,
  Yes
}
]])

local tristateLookup = {
  ["n"] = "No",
  ["m"] = "Mod",
  ["y"] = "Yes"
}

function processOneLine(line)
  if line:sub(1,1) == "#" then
    return
  end

  local name, value = line:match("^([^=]-)=(.*)$")
  if not name then
    return
  end
  io.write("const "..name..": ")
  if value:sub(1,1) == "\"" then
    io.write("&str = "..value..";")
  elseif value:match("[nym]") then
    io.write("KConfigTriState = KConfigTriState::"..tristateLookup[value:match("[nym]")]..";")
  elseif value:match("^[0-9]+$") then
    io.write("i32 = "..tostring(value)..";")
  else
    error("Unknown value!")
  end
  print()
end

for line in io.stdin:lines() do
  processOneLine(line)
end


