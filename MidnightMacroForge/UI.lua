local addonName, ns = ...

local UI = {}
ns.UI = UI

local function clamp(v, minV, maxV)
  if v < minV then return minV end
  if v > maxV then return maxV end
  return v
end

local function colorHex(rgb)
  return string.format("|cff%02x%02x%02x", rgb[1] * 255, rgb[2] * 255, rgb[3] * 255)
end

local function stylePanel(frame, bg)
  frame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
  })
  frame:SetBackdropColor(bg[1], bg[2], bg[3], bg[4] or 1)
  frame:SetBackdropBorderColor(0.20, 0.24, 0.30, 1)
end

local function mkPanel(parent, w, h, bg)
  local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  f:SetSize(w, h)
  stylePanel(f, bg or { 0.07, 0.08, 0.10, 0.95 })
  return f
end

local function mkButton(parent, text, h)
  local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
  b:SetHeight(h or 28)
  stylePanel(b, { 0.12, 0.13, 0.16, 1 })
  b.t = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  b.t:SetPoint("CENTER")
  b.t:SetText(text)
  b:SetScript("OnEnter", function(self) self:SetBackdropColor(0.16, 0.18, 0.22, 1) end)
  b:SetScript("OnLeave", function(self) self:SetBackdropColor(0.12, 0.13, 0.16, 1) end)
  return b
end

local function mkInput(parent, w, h)
  local wrap = mkPanel(parent, w, h, { 0.05, 0.06, 0.08, 1 })
  local e = CreateFrame("EditBox", nil, wrap)
  e:SetFontObject(GameFontHighlight)
  e:SetPoint("TOPLEFT", 8, -4)
  e:SetPoint("BOTTOMRIGHT", -8, 4)
  e:SetAutoFocus(false)
  e:SetTextInsets(2, 2, 0, 0)
  wrap.edit = e
  return wrap
end

local function mkCheckbox(parent, text)
  local c = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  c.text:SetText(text)
  return c
end

local function mkDropdown(parent, label, w)
  local box = mkPanel(parent, w, 54, { 0.08, 0.09, 0.12, 1 })
  box.label = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  box.label:SetPoint("TOPLEFT", 10, -8)
  box.label:SetText(label)

  box.btn = mkButton(box, "", 26)
  box.btn:SetPoint("BOTTOMLEFT", 8, 8)
  box.btn:SetPoint("BOTTOMRIGHT", -8, 8)
  box.btn.v = box.btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  box.btn.v:SetPoint("LEFT", 8, 0)
  box.btn.v:SetJustifyH("LEFT")
  box.btn.arrow = box.btn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  box.btn.arrow:SetPoint("RIGHT", -8, 0)
  box.btn.arrow:SetText("▾")

  return box
end

function UI:SaveState()
  local db = MidnightMacroForgeDB
  if not db then return end
  db.profile.classToken = self.selectedClass
  db.profile.specName = self.selectedSpec and self.selectedSpec.name or nil
  db.profile.search = self.searchText or ""
  db.profile.roleFilter = self.roleFilter or "ALL"
  if self.frame then
    local p, _, rp, x, y = self.frame:GetPoint(1)
    db.profile.anchor = { p, rp, x, y }
  end
end

function UI:FilteredTemplates()
  local out = {}
  local specs = self.classData and self.classData.specs or {}
  local search = (self.searchText or ""):lower()
  local roleFilter = self.roleFilter or "ALL"

  for _, spec in ipairs(specs) do
    if roleFilter == "ALL" or roleFilter == spec.role then
      for _, entry in ipairs(spec.entries or {}) do
        local hay = (spec.name .. " " .. entry.label .. " " .. table.concat(entry.tags or {}, " ")):lower()
        if search == "" or hay:find(search, 1, true) then
          table.insert(out, {
            specName = spec.name,
            role = spec.role,
            template = entry,
            key = self.selectedClass .. ":" .. spec.name .. ":" .. entry.label,
          })
        end
      end
    end
  end

  table.sort(out, function(a, b)
    if a.specName == b.specName then
      return a.template.label < b.template.label
    end
    return a.specName < b.specName
  end)

  return out
end

function UI:RefreshTemplateList()
  self.rows = self.rows or {}
  self.filtered = self:FilteredTemplates()
  local offset = FauxScrollFrame_GetOffset(self.scrollFrame) or 0

  for i = 1, 11 do
    local row = self.rows[i]
    if not row then
      row = CreateFrame("Button", nil, self.listContainer, "BackdropTemplate")
      row:SetHeight(34)
      stylePanel(row, { 0.10, 0.12, 0.15, 0.95 })
      if i == 1 then
        row:SetPoint("TOPLEFT", 6, -6)
        row:SetPoint("TOPRIGHT", -6, -6)
      else
        row:SetPoint("TOPLEFT", self.rows[i - 1], "BOTTOMLEFT", 0, -4)
        row:SetPoint("TOPRIGHT", self.rows[i - 1], "BOTTOMRIGHT", 0, -4)
      end

      row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      row.name:SetPoint("LEFT", 8, 0)
      row.name:SetJustifyH("LEFT")

      row.meta = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
      row.meta:SetPoint("RIGHT", -34, 0)

      row.fav = mkButton(row, "☆", 20)
      row.fav:SetSize(22, 20)
      row.fav:SetPoint("RIGHT", -6, 0)

      self.rows[i] = row
    end

    local data = self.filtered[i + offset]
    if data then
      row:Show()
      local fav = MidnightMacroForgeDB.profile.favorites[data.key]
      row.fav.t:SetText(fav and "★" or "☆")
      row.name:SetText(string.format("%s%s|r  %s", colorHex(ns.Accent), data.specName, data.template.label))
      row.meta:SetText(string.format("%s • %s", data.role, data.template.difficulty or "Beginner"))
      row:SetScript("OnClick", function()
        self.selectedTemplate = data.template
        self.selectedTemplateKey = data.key
        self.specTitle:SetText(data.specName)
        self.preview:SetText(ns.Generator.BuildPreview(self.selectedTemplate, self:GetMacroOptions()))
        self.nameEdit.edit:SetText(ns.Generator.NormalizeName(data.template.label, data.template.label))
      end)
      row.fav:SetScript("OnClick", function()
        MidnightMacroForgeDB.profile.favorites[data.key] = not MidnightMacroForgeDB.profile.favorites[data.key]
        self:RefreshTemplateList()
      end)
    else
      row:Hide()
    end
  end

  FauxScrollFrame_Update(self.scrollFrame, #self.filtered, 11, 38)
  self.resultCount:SetText(string.format("%d template(s)", #self.filtered))
end

function UI:GetMacroOptions()
  return {
    addStopCasting = self.stopCasting:GetChecked(),
    addTrinketTop = self.trinket1:GetChecked(),
    addTrinketBottom = self.trinket2:GetChecked(),
    targetClause = ns.TargetClauses[self.targetMode] or "",
    spellName = self.builderSpell.edit:GetText(),
  }
end

function UI:RefreshPreview()
  if self.selectedTemplate then
    self.preview:SetText(ns.Generator.BuildPreview(self.selectedTemplate, self:GetMacroOptions()))
  end
end

function UI:SelectClass(token)
  self.selectedClass = token
  self.classData = ns.Templates[token]
  self.classDrop.btn.v:SetText(self.classData and self.classData.className or token)
  self:RefreshTemplateList()
  self:SaveState()
end

function UI:ShowMenu(anchor, options, onPick)
  if self.menu then self.menu:Hide() end
  local menu = mkPanel(self.frame, anchor:GetWidth(), clamp(#options * 24 + 8, 36, 340), { 0.06, 0.07, 0.09, 1 })
  menu:SetFrameStrata("DIALOG")
  menu:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)

  for i, option in ipairs(options) do
    local row = mkButton(menu, option.text, 20)
    row:SetPoint("TOPLEFT", 4, -4 - (i - 1) * 24)
    row:SetPoint("TOPRIGHT", -4, -4 - (i - 1) * 24)
    row:SetScript("OnClick", function()
      onPick(option.value)
      menu:Hide()
    end)
  end
  self.menu = menu
end

function UI:BuildBuilderPanel(parent)
  local p = mkPanel(parent, 280, 148, { 0.08, 0.09, 0.12, 1 })
  p:SetPoint("BOTTOMLEFT", 10, 12)

  local title = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOPLEFT", 10, -8)
  title:SetText("Quick Builder")

  local spellLabel = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  spellLabel:SetPoint("TOPLEFT", 10, -30)
  spellLabel:SetText("Spell name")

  self.builderSpell = mkInput(p, 180, 26)
  self.builderSpell:SetPoint("TOPLEFT", 10, -46)
  self.builderSpell.edit:SetText("Spell Name")

  local grp = mkDropdown(p, "Template", 250)
  grp:SetPoint("TOPLEFT", 10, -78)
  self.builderDrop = grp
  grp.btn.v:SetText("support / utility")

  grp.btn:SetScript("OnClick", function()
    self:ShowMenu(grp.btn, {
      { text = "Support: Friendly mouseover", value = "support:1" },
      { text = "Support: Ground cursor", value = "support:2" },
      { text = "Utility: Startattack helper", value = "utility:1" },
      { text = "Utility: Stopcasting spell", value = "utility:2" },
      { text = "Interrupt: Kick focus", value = "interrupts:1" },
      { text = "Interrupt: Kick mouseover", value = "interrupts:2" },
    }, function(v)
      self.builderChoice = v
      grp.btn.v:SetText(v)
    end)
  end)

  local gen = mkButton(p, "Inject builder in preview", 24)
  gen:SetPoint("BOTTOMLEFT", 10, 10)
  gen:SetPoint("BOTTOMRIGHT", -10, 10)
  gen:SetScript("OnClick", function()
    local cat, idx = (self.builderChoice or "support:1"):match("([^:]+):(%d+)")
    idx = tonumber(idx) or 1
    local ref = ns.BuilderSnippets[cat] and ns.BuilderSnippets[cat][idx]
    if ref then
      local built = ns.Generator.ApplyOptions(ref.body, self:GetMacroOptions())
      self.preview:SetText(built)
      self.selectedTemplate = { label = ref.label, icon = ref.icon, body = ref.body }
      self.selectedTemplateKey = "builder:" .. cat .. ":" .. idx
      self.nameEdit.edit:SetText(ns.Generator.NormalizeName(ref.label, ref.label))
      self.status:SetText("|cff7CFC00Snippet builder chargé.|r")
    end
  end)
end

function UI:Build()
  if self.frame then return end

  local f = CreateFrame("Frame", "MidnightMacroForgeFrame", UIParent, "BackdropTemplate")
  f:SetSize(1040, 680)
  stylePanel(f, { 0.03, 0.04, 0.06, 0.98 })
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", function(frame)
    frame:StopMovingOrSizing()
    self:SaveState()
  end)
  f:SetFrameStrata("HIGH")
  self.frame = f

  local top = mkPanel(f, 1040, 52, { 0.05, 0.06, 0.09, 1 })
  top:SetPoint("TOP")
  local title = top:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("LEFT", 14, 0)
  title:SetText(colorHex(ns.Accent) .. "Midnight Macro Forge|r  •  Premium Guided Creator")

  local close = mkButton(top, "✕", 24)
  close:SetSize(28, 24)
  close:SetPoint("RIGHT", -10, 0)
  close:SetScript("OnClick", function() f:Hide() end)

  local left = mkPanel(f, 350, 606, { 0.06, 0.07, 0.10, 1 })
  left:SetPoint("TOPLEFT", 12, -60)

  local right = mkPanel(f, 654, 606, { 0.06, 0.07, 0.10, 1 })
  right:SetPoint("TOPRIGHT", -12, -60)

  self.classDrop = mkDropdown(left, "Class", 330)
  self.classDrop:SetPoint("TOPLEFT", 10, -10)

  self.roleDrop = mkDropdown(left, "Role Filter", 160)
  self.roleDrop:SetPoint("TOPLEFT", self.classDrop, "BOTTOMLEFT", 0, -8)

  self.targetDrop = mkDropdown(left, "Targeting mode", 160)
  self.targetDrop:SetPoint("TOPRIGHT", self.classDrop, "BOTTOMRIGHT", 0, -8)

  local searchLabel = left:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  searchLabel:SetPoint("TOPLEFT", self.roleDrop, "BOTTOMLEFT", 4, -14)
  searchLabel:SetText("Search template")

  self.searchWrap = mkInput(left, 330, 26)
  self.searchWrap:SetPoint("TOPLEFT", searchLabel, "BOTTOMLEFT", -4, -4)

  self.resultCount = left:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  self.resultCount:SetPoint("TOPRIGHT", self.searchWrap, "BOTTOMRIGHT", 0, -8)

  self.listContainer = mkPanel(left, 330, 330, { 0.04, 0.05, 0.07, 1 })
  self.listContainer:SetPoint("TOPLEFT", self.searchWrap, "BOTTOMLEFT", 0, -8)

  self.scrollFrame = CreateFrame("ScrollFrame", nil, self.listContainer, "FauxScrollFrameTemplate")
  self.scrollFrame:SetPoint("TOPLEFT", 0, -2)
  self.scrollFrame:SetPoint("BOTTOMRIGHT", -28, 2)
  self.scrollFrame:SetScript("OnVerticalScroll", function(sf, offset)
    FauxScrollFrame_OnVerticalScroll(sf, offset, 38, function() self:RefreshTemplateList() end)
  end)

  self.stopCasting = mkCheckbox(left, "Inject /stopcasting")
  self.stopCasting:SetPoint("TOPLEFT", self.listContainer, "BOTTOMLEFT", 2, -8)

  self.trinket1 = mkCheckbox(left, "Inject /use 13")
  self.trinket1:SetPoint("TOPLEFT", self.stopCasting, "BOTTOMLEFT", 0, -4)

  self.trinket2 = mkCheckbox(left, "Inject /use 14")
  self.trinket2:SetPoint("TOPLEFT", self.trinket1, "BOTTOMLEFT", 0, -4)

  self:BuildBuilderPanel(left)

  local head = right:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  head:SetPoint("TOPLEFT", 12, -10)
  head:SetText(colorHex(ns.Accent) .. "Macro Preview|r")

  self.specTitle = right:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  self.specTitle:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, -4)
  self.specTitle:SetText("Pick a template")

  local prevBg = mkPanel(right, 630, 460, { 0.04, 0.05, 0.08, 1 })
  prevBg:SetPoint("TOPLEFT", 12, -54)

  local sf = CreateFrame("ScrollFrame", nil, prevBg, "UIPanelScrollFrameTemplate")
  sf:SetPoint("TOPLEFT", 8, -8)
  sf:SetPoint("BOTTOMRIGHT", -30, 8)

  self.preview = CreateFrame("EditBox", nil, sf)
  self.preview:SetMultiLine(true)
  self.preview:SetAutoFocus(false)
  self.preview:SetFontObject(GameFontHighlight)
  self.preview:SetWidth(580)
  self.preview:SetTextInsets(8, 8, 8, 8)
  sf:SetScrollChild(self.preview)

  local nameLbl = right:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  nameLbl:SetPoint("TOPLEFT", prevBg, "BOTTOMLEFT", 0, -12)
  nameLbl:SetText("Macro name")

  self.nameEdit = mkInput(right, 270, 28)
  self.nameEdit:SetPoint("TOPLEFT", nameLbl, "BOTTOMLEFT", 0, -4)
  self.nameEdit.edit:SetMaxLetters(16)

  self.perCharacter = mkCheckbox(right, "Character macro")
  self.perCharacter:SetPoint("LEFT", self.nameEdit, "RIGHT", 12, 0)

  local counters = right:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  counters:SetPoint("LEFT", self.perCharacter, "RIGHT", 20, 0)
  self.counterText = counters

  local save = mkButton(right, "Create / Update Macro", 32)
  save:SetPoint("BOTTOMLEFT", 12, 12)
  save:SetPoint("BOTTOMRIGHT", -12, 12)

  self.status = right:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.status:SetPoint("BOTTOMLEFT", 12, 50)
  self.status:SetWidth(620)
  self.status:SetJustifyH("LEFT")

  self.classDrop.btn:SetScript("OnClick", function()
    local opts = {}
    for _, token in ipairs(ns.ClassOrder) do
      local name = ns.Templates[token] and ns.Templates[token].className or token
      table.insert(opts, { text = name, value = token })
    end
    self:ShowMenu(self.classDrop.btn, opts, function(v) self:SelectClass(v) end)
  end)

  self.roleDrop.btn:SetScript("OnClick", function()
    self:ShowMenu(self.roleDrop.btn, {
      { text = "ALL", value = "ALL" }, { text = "DAMAGER", value = "DAMAGER" }, { text = "HEALER", value = "HEALER" }, { text = "TANK", value = "TANK" },
    }, function(v)
      self.roleFilter = v
      self.roleDrop.btn.v:SetText(v)
      self:RefreshTemplateList()
      self:SaveState()
    end)
  end)

  self.targetDrop.btn:SetScript("OnClick", function()
    self:ShowMenu(self.targetDrop.btn, {
      { text = "None", value = "none" }, { text = "Mouseover", value = "mouseover" }, { text = "Focus", value = "focus" },
      { text = "Target", value = "target" }, { text = "Player", value = "player" }, { text = "Cursor", value = "cursor" },
    }, function(v)
      self.targetMode = v
      self.targetDrop.btn.v:SetText(v)
      self:RefreshPreview()
    end)
  end)

  local refreshers = { self.stopCasting, self.trinket1, self.trinket2 }
  for _, cb in ipairs(refreshers) do
    cb:SetScript("OnClick", function() self:RefreshPreview() end)
  end

  self.searchWrap.edit:SetScript("OnTextChanged", function(edit)
    self.searchText = edit:GetText()
    self:RefreshTemplateList()
    self:SaveState()
  end)

  save:SetScript("OnClick", function()
    local body = self.preview:GetText() or ""
    local fallback = self.selectedTemplate and self.selectedTemplate.label or "Macro"
    local name = ns.Generator.NormalizeName(self.nameEdit.edit:GetText(), fallback)
    self.nameEdit.edit:SetText(name)

    local ok, msg = ns.Generator.CreateOrUpdate(name, self.selectedTemplate and self.selectedTemplate.icon, body, self.perCharacter:GetChecked())
    if ok then
      self.status:SetText("|cff7CFC00" .. msg .. "|r")
      if self.selectedTemplateKey then
        table.insert(MidnightMacroForgeDB.profile.recent, 1, self.selectedTemplateKey)
        while #MidnightMacroForgeDB.profile.recent > 20 do
          table.remove(MidnightMacroForgeDB.profile.recent)
        end
      end
    else
      self.status:SetText("|cffff4d4f" .. msg .. "|r")
    end
  end)

  f:SetScript("OnShow", function()
    local g, c = ns.Generator.GetMacroCounts()
    self.counterText:SetText(string.format("Account %d/%d  •  Character %d/%d", g, MAX_ACCOUNT_MACROS, c, MAX_CHARACTER_MACROS))
  end)

  self.roleFilter = MidnightMacroForgeDB.profile.roleFilter or "ALL"
  self.searchText = MidnightMacroForgeDB.profile.search or ""
  self.targetMode = "none"
  self.searchWrap.edit:SetText(self.searchText)
  self.roleDrop.btn.v:SetText(self.roleFilter)
  self.targetDrop.btn.v:SetText("none")

  local startClass = MidnightMacroForgeDB.profile.classToken or select(2, UnitClass("player")) or "WARRIOR"
  self:SelectClass(startClass)

  local anchor = MidnightMacroForgeDB.profile.anchor
  if anchor then
    f:ClearAllPoints()
    f:SetPoint(anchor[1], UIParent, anchor[2], anchor[3], anchor[4])
  else
    f:SetPoint("CENTER")
  end
end

function UI:Toggle()
  if not self.frame then
    self:Build()
  end
  if self.frame:IsShown() then
    self.frame:Hide()
    self:SaveState()
  else
    self.frame:Show()
  end
end
