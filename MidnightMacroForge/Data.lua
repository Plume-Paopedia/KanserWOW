local addonName, ns = ...

ns.Accent = { 0.35, 0.73, 0.98 }
ns.InterfaceVersion = 120000

local function T(label, icon, body, tags, difficulty)
  return {
    label = label,
    icon = icon or 134400,
    body = body,
    tags = tags or {},
    difficulty = difficulty or "Beginner",
  }
end

local function Spec(name, role, entries)
  return {
    name = name,
    role = role,
    entries = entries,
  }
end

ns.ClassOrder = {
  "DEATHKNIGHT", "DEMONHUNTER", "DRUID", "EVOKER", "HUNTER", "MAGE", "MONK",
  "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR",
}

ns.TargetClauses = {
  none = "",
  mouseover = "[@mouseover,exists,nodead]",
  focus = "[@focus,exists,nodead]",
  target = "[@target,exists,nodead]",
  player = "[@player]",
  cursor = "[@cursor]",
}

ns.Templates = {
  DEATHKNIGHT = {
    className = "Death Knight",
    specs = {
      Spec("Blood", "TANK", {
        T("Mitigation stack", 136120, "#showtooltip Icebound Fortitude\n/cast Icebound Fortitude\n/cast Vampiric Blood", { "defensive", "m+" }),
        T("Grip focus", 237532, "#showtooltip Death Grip\n/cast [@focus,harm,nodead][] Death Grip", { "utility", "raid" }),
      }),
      Spec("Frost", "DAMAGER", {
        T("Pillar burst", 135277, "#showtooltip Pillar of Frost\n/cast Pillar of Frost\n/use 13", { "burst", "raid" }),
      }),
      Spec("Unholy", "DAMAGER", {
        T("Army burst", 136119, "#showtooltip Summon Gargoyle\n/cast Unholy Assault\n/cast Summon Gargoyle", { "burst", "raid" }),
      }),
    },
  },
  DEMONHUNTER = {
    className = "Demon Hunter",
    specs = {
      Spec("Havoc", "DAMAGER", {
        T("Essence break burst", 1247264, "#showtooltip Metamorphosis\n/cast Metamorphosis\n/cast Essence Break", { "burst", "raid" }),
      }),
      Spec("Vengeance", "TANK", {
        T("Tank wall", 1247265, "#showtooltip Demon Spikes\n/cast Demon Spikes\n/cast Fiery Brand", { "defensive", "m+" }),
      }),
    },
  },
  DRUID = {
    className = "Druid",
    specs = {
      Spec("Balance", "DAMAGER", {
        T("Celestial alignment", 136096, "#showtooltip Celestial Alignment\n/cast Celestial Alignment\n/use 13", { "burst", "raid" }),
      }),
      Spec("Feral", "DAMAGER", {
        T("Berserk burst", 132242, "#showtooltip Berserk\n/cast Berserk\n/cast Tiger's Fury", { "burst" }),
      }),
      Spec("Guardian", "TANK", {
        T("Survival stack", 132276, "#showtooltip Survival Instincts\n/cast Survival Instincts\n/cast Barkskin", { "defensive" }),
      }),
      Spec("Restoration", "HEALER", {
        T("Swiftmend mouseover", 134914, "#showtooltip Swiftmend\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] Swiftmend", { "heal" }),
      }),
    },
  },
  EVOKER = {
    className = "Evoker",
    specs = {
      Spec("Devastation", "DAMAGER", {
        T("Dragonrage burst", 4622466, "#showtooltip Dragonrage\n/cast Dragonrage\n/use 13", { "burst" }),
      }),
      Spec("Preservation", "HEALER", {
        T("Rescue mouseover", 4622461, "#showtooltip Rescue\n/cast [@mouseover,help,nodead][@target,help,nodead] Rescue", { "heal", "utility" }),
      }),
      Spec("Augmentation", "DAMAGER", {
        T("Ebon Might helper", 4622470, "#showtooltip Ebon Might\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] Ebon Might", { "support" }),
      }),
    },
  },
  HUNTER = {
    className = "Hunter",
    specs = {
      Spec("Beast Mastery", "DAMAGER", {
        T("Bestial burst", 132127, "#showtooltip Bestial Wrath\n/cast Bestial Wrath\n/cast Bloodshed", { "burst" }),
      }),
      Spec("Marksmanship", "DAMAGER", {
        T("Trueshot burst", 236179, "#showtooltip Trueshot\n/cast Trueshot\n/use 13", { "burst" }),
      }),
      Spec("Survival", "DAMAGER", {
        T("Harpoon focus", 132223, "#showtooltip Harpoon\n/cast [@focus,harm,nodead][] Harpoon", { "utility", "pvp" }),
      }),
    },
  },
  MAGE = {
    className = "Mage",
    specs = {
      Spec("Arcane", "DAMAGER", {
        T("Arcane surge", 236205, "#showtooltip Arcane Surge\n/cast Arcane Surge\n/use 13", { "burst" }),
      }),
      Spec("Fire", "DAMAGER", {
        T("Combustion burst", 135824, "#showtooltip Combustion\n/cast Combustion\n/use 13", { "burst" }),
      }),
      Spec("Frost", "DAMAGER", {
        T("Icy veins burst", 135838, "#showtooltip Icy Veins\n/cast Icy Veins\n/use 13", { "burst" }),
      }),
    },
  },
  MONK = {
    className = "Monk",
    specs = {
      Spec("Brewmaster", "TANK", {
        T("Fort brew", 620827, "#showtooltip Fortifying Brew\n/cast Fortifying Brew\n/cast Dampen Harm", { "defensive" }),
      }),
      Spec("Mistweaver", "HEALER", {
        T("Life cocoon mouseover", 627485, "#showtooltip Life Cocoon\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] Life Cocoon", { "heal" }),
      }),
      Spec("Windwalker", "DAMAGER", {
        T("Serenity burst", 988197, "#showtooltip Serenity\n/cast Serenity\n/use 13", { "burst" }),
      }),
    },
  },
  PALADIN = {
    className = "Paladin",
    specs = {
      Spec("Holy", "HEALER", {
        T("Lay on Hands smart", 524354, "#showtooltip Lay on Hands\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] Lay on Hands", { "heal", "panic" }),
        T("Cleanse mouseover", 135953, "#showtooltip Cleanse\n/cast [@mouseover,help,nodead][] Cleanse", { "dispel", "m+" }),
      }),
      Spec("Protection", "TANK", {
        T("Double defensive", 135875, "#showtooltip Ardent Defender\n/cast Ardent Defender\n/cast Guardian of Ancient Kings", { "defensive" }),
      }),
      Spec("Retribution", "DAMAGER", {
        T("Wings burst", 135875, "#showtooltip Avenging Wrath\n/cast Avenging Wrath\n/cast Execution Sentence", { "burst" }),
      }),
    },
  },
  PRIEST = {
    className = "Priest",
    specs = {
      Spec("Discipline", "HEALER", {
        T("Pain Suppression smart", 135936, "#showtooltip Pain Suppression\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] Pain Suppression", { "heal", "panic" }),
      }),
      Spec("Holy", "HEALER", {
        T("Guardian Spirit smart", 237542, "#showtooltip Guardian Spirit\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] Guardian Spirit", { "heal", "panic" }),
      }),
      Spec("Shadow", "DAMAGER", {
        T("PI burst", 136207, "#showtooltip Power Infusion\n/cast Power Infusion\n/use 13", { "burst" }),
      }),
    },
  },
  ROGUE = {
    className = "Rogue",
    specs = {
      Spec("Assassination", "DAMAGER", {
        T("Vendetta burst", 236270, "#showtooltip Deathmark\n/cast Deathmark\n/cast Shiv", { "burst" }),
      }),
      Spec("Outlaw", "DAMAGER", {
        T("Adrenaline rush", 236286, "#showtooltip Adrenaline Rush\n/cast Adrenaline Rush\n/use 13", { "burst" }),
      }),
      Spec("Subtlety", "DAMAGER", {
        T("Shadow dance", 136207, "#showtooltip Shadow Dance\n/cast Shadow Dance\n/cast Symbols of Death", { "burst" }),
      }),
    },
  },
  SHAMAN = {
    className = "Shaman",
    specs = {
      Spec("Elemental", "DAMAGER", {
        T("Elemental burst", 136048, "#showtooltip Stormkeeper\n/cast Stormkeeper\n/use 13", { "burst" }),
      }),
      Spec("Enhancement", "DAMAGER", {
        T("Ascendance burst", 237581, "#showtooltip Ascendance\n/cast Ascendance\n/use 13", { "burst" }),
      }),
      Spec("Restoration", "HEALER", {
        T("Spirit link", 252174, "#showtooltip Spirit Link Totem\n/cast [@cursor] Spirit Link Totem", { "heal", "raid" }),
      }),
    },
  },
  WARLOCK = {
    className = "Warlock",
    specs = {
      Spec("Affliction", "DAMAGER", {
        T("Darkglare setup", 841382, "#showtooltip Summon Darkglare\n/cast Soul Rot\n/cast Summon Darkglare", { "burst" }),
      }),
      Spec("Demonology", "DAMAGER", {
        T("Nether portal", 841379, "#showtooltip Nether Portal\n/cast Grimoire: Felguard\n/cast Nether Portal", { "burst" }),
      }),
      Spec("Destruction", "DAMAGER", {
        T("Infernal burst", 136219, "#showtooltip Summon Infernal\n/cast Summon Infernal\n/use 13", { "burst" }),
      }),
    },
  },
  WARRIOR = {
    className = "Warrior",
    specs = {
      Spec("Arms", "DAMAGER", {
        T("Avatar opener", 132355, "#showtooltip Avatar\n/cast Avatar\n/cast Colossus Smash\n/cast Mortal Strike", { "burst", "raid" }),
      }),
      Spec("Fury", "DAMAGER", {
        T("Recklessness burst", 132109, "#showtooltip Recklessness\n/cast Recklessness\n/cast Avatar\n/use 13", { "burst" }),
      }),
      Spec("Protection", "TANK", {
        T("Shield wall panic", 132362, "#showtooltip Shield Wall\n/cast Shield Wall\n/cast Last Stand", { "defensive", "m+" }),
      }),
    },
  },
}

ns.BuilderSnippets = {
  interrupts = {
    { label = "Kick focus", icon = 132938, body = "#showtooltip\n/cast [@focus,harm,nodead][] {{SPELL}}" },
    { label = "Kick mouseover", icon = 132938, body = "#showtooltip\n/cast [@mouseover,harm,nodead][] {{SPELL}}" },
  },
  support = {
    { label = "Friendly mouseover", icon = 135953, body = "#showtooltip\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] {{SPELL}}" },
    { label = "Ground cursor", icon = 134400, body = "#showtooltip\n/cast [@cursor] {{SPELL}}" },
  },
  utility = {
    { label = "Startattack helper", icon = 132147, body = "#showtooltip\n/startattack\n/cast {{SPELL}}" },
    { label = "Stopcasting + spell", icon = 132175, body = "#showtooltip\n/stopcasting\n/cast {{SPELL}}" },
  },
}
