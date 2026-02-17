local addonName, ns = ...

local defaults = {
  profile = {
    firstRun = true,
    classToken = nil,
    specName = nil,
    roleFilter = "ALL",
    search = "",
    favorites = {},
    recent = {},
    anchor = nil,
  },
}

local function mergeDefaults(src, dst)
  for k, v in pairs(src) do
    if type(v) == "table" then
      if type(dst[k]) ~= "table" then
        dst[k] = {}
      end
      mergeDefaults(v, dst[k])
    elseif dst[k] == nil then
      dst[k] = v
    end
  end
end

local function setupDB()
  MidnightMacroForgeDB = MidnightMacroForgeDB or {}
  mergeDefaults(defaults, MidnightMacroForgeDB)
end

local function printInfo(msg)
  print("|cff59b8f9Midnight Macro Forge|r: " .. msg)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
  if event ~= "ADDON_LOADED" or arg1 ~= addonName then return end

  setupDB()

  SLASH_MIDNIGHTMACROFORGE1 = "/mmf"
  SLASH_MIDNIGHTMACROFORGE2 = "/midmacro"
  SlashCmdList.MIDNIGHTMACROFORGE = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "help" then
      printInfo("/mmf: ouvrir/fermer l'interface")
      printInfo("/mmf reset: reset profil")
      printInfo("/mmf favorites: nombre de favoris")
      return
    end

    if msg == "reset" then
      MidnightMacroForgeDB = {}
      setupDB()
      if ns.UI and ns.UI.frame then
        ns.UI.frame:ClearAllPoints()
        ns.UI.frame:SetPoint("CENTER")
      end
      printInfo("Profil réinitialisé.")
      return
    end

    if msg == "favorites" then
      local count = 0
      for _, isFav in pairs(MidnightMacroForgeDB.profile.favorites) do
        if isFav then count = count + 1 end
      end
      printInfo("Favoris: " .. count)
      return
    end

    ns.UI:Toggle()
  end

  if MidnightMacroForgeDB.profile.firstRun then
    printInfo("chargé (prepatch-ready). Tape |cffffffff/mmf|r pour ouvrir le créateur guidé.")
    MidnightMacroForgeDB.profile.firstRun = false
  end
end)
