local M = {}

function M.replace(text, old, new)
  return text:gsub(M.escapeGsubSearchMagics(old), M.escapeGsubReplaceMagics(new))
end

function M.replaceEnd(text, old, new)
  return text:gsub(M.escapeGsubSearchMagics(old).."$", M.escapeGsubReplaceMagics(new))
end

function M.replaceStart(text, old, new)
  return text:gsub("^"..M.escapeGsubSearchMagics(old), M.escapeGsubReplaceMagics(new))
end

function M.escapeGsubSearchMagics(s)
  return (s:gsub('[%^%$%(%)%%%.%[%]%*%+%-%?]','%%%1'))
end

function M.escapeGsubReplaceMagics(s)
  return (s:gsub('[%%]','%%%%'))
end

function M.isPrefixedBy(prefix, string)
  -- If replace sucessful that mean it was prefixed
  return M.replaceStart(string, prefix, "") ~= string
end

return M

