local addonName, ns = ...

local Generator = {}
ns.Generator = Generator

local MAX_BODY = 255
local MAX_NAME = 16

local function trim(value)
  return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

function Generator.NormalizeName(name, fallback)
  local value = trim(name)
  if value == "" then
    value = trim(fallback or "NewMacro")
  end
  value = value:gsub("[^%w%s%-_]", "")
  value = value:gsub("%s+", "")
  if #value > MAX_NAME then
    value = value:sub(1, MAX_NAME)
  end
  if value == "" then
    value = "NewMacro"
  end
  return value
end

function Generator.ApplyOptions(body, options)
  local result = trim(body)
  options = options or {}

  if options.targetClause and options.targetClause ~= "" then
    result = result:gsub("{{TARGET}}", options.targetClause)
  else
    result = result:gsub("{{TARGET}}", "")
  end

  if options.spellName and options.spellName ~= "" then
    result = result:gsub("{{SPELL}}", options.spellName)
  end

  if options.addStopCasting and not result:find("/stopcasting", 1, true) then
    result = "/stopcasting\n" .. result
  end

  if options.addTrinketTop and not result:find("/use 13", 1, true) then
    result = result .. "\n/use 13"
  end

  if options.addTrinketBottom and not result:find("/use 14", 1, true) then
    result = result .. "\n/use 14"
  end

  return trim(result)
end

function Generator.BuildPreview(template, options)
  if not template then
    return ""
  end
  return Generator.ApplyOptions(template.body or "", options)
end

function Generator.Validate(name, body)
  local cleanName = trim(name)
  local cleanBody = trim(body)

  if cleanName == "" then
    return false, "Le nom de macro est requis."
  end
  if cleanBody == "" then
    return false, "Le contenu de macro est vide."
  end
  if #cleanName > MAX_NAME then
    return false, string.format("Nom trop long (%d/%d).", #cleanName, MAX_NAME)
  end
  if #cleanBody > MAX_BODY then
    return false, string.format("Macro trop longue (%d/%d). Active le mode split dans un prochain template ou raccourcis la macro.", #cleanBody, MAX_BODY)
  end

  return true, cleanName, cleanBody
end

function Generator.GetMacroCounts()
  local globalCount, charCount = GetNumMacros()
  return globalCount or 0, charCount or 0
end

function Generator.CreateOrUpdate(name, icon, body, perCharacter)
  local ok, a, b = Generator.Validate(name, body)
  if not ok then
    return false, a
  end

  local macroIndex = GetMacroIndexByName(a)
  if macroIndex and macroIndex > 0 then
    EditMacro(macroIndex, nil, icon or 134400, b)
    return true, "Macro mise à jour.", macroIndex
  end

  local globalCount, charCount = Generator.GetMacroCounts()
  if perCharacter then
    if charCount >= MAX_CHARACTER_MACROS then
      return false, string.format("Limite macros personnage atteinte (%d/%d).", charCount, MAX_CHARACTER_MACROS)
    end
  elseif globalCount >= MAX_ACCOUNT_MACROS then
    return false, string.format("Limite macros compte atteinte (%d/%d).", globalCount, MAX_ACCOUNT_MACROS)
  end

  local newIndex = CreateMacro(a, icon or 134400, b, perCharacter and 1 or nil)
  return true, "Macro créée.", newIndex
end
