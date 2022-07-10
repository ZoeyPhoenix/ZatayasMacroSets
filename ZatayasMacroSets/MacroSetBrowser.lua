local addonname, addon = ...

local function spairs(t, order) -- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
  -- collect the keys
  local keys = {}
  for k in pairs(t) do
    keys[#keys + 1] = k
  end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys 
  if order then
    table.sort(keys, function(a, b)
      return order(t, a, b)
    end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

local ZatayasMacroSetBrowser = ZatayasMacroSetBrowser or CreateFrame("Frame", "ZatayasMacroSetBrowser", UIParent)

ZatayasMacroSetBrowser:HookScript("OnShow", function(self)
  ZatayasMacroSetBrowser:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  ZatayasMacroSetBrowser:UpdateSetButtons()
  ZatayasMacroSetBrowser:ResetMacroButtons()
  ZatayasMacroSetBrowser:ClearMacroDetails()
end)

ZatayasMacroSetBrowser:SetSize(600, 452)

ZatayasMacroSetBrowser:SetMovable(true)
ZatayasMacroSetBrowser:EnableMouse(true)
ZatayasMacroSetBrowser:SetUserPlaced(false)
ZatayasMacroSetBrowser:RegisterForDrag("LeftButton")
ZatayasMacroSetBrowser:SetScript("OnDragStart", ZatayasMacroSetBrowser.StartMoving)
ZatayasMacroSetBrowser:SetScript("OnDragStop", ZatayasMacroSetBrowser.StopMovingOrSizing)


ZatayasMacroSetBrowser:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})
ZatayasMacroSetBrowser:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

ZatayasMacroSetBrowser.ZatayasMacroSetBrowserTitleTxt = ZatayasMacroSetBrowser.ZatayasMacroSetBrowserTitleTxt or ZatayasMacroSetBrowser:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMacroSetBrowser.ZatayasMacroSetBrowserTitleTxt:SetPoint("TOP", ZatayasMacroSetBrowser, "TOP", 0, -10)
ZatayasMacroSetBrowser.ZatayasMacroSetBrowserTitleTxt:SetFont("Fonts\\FRIZQT__.TTF", 10, nil)
ZatayasMacroSetBrowser.ZatayasMacroSetBrowserTitleTxt:SetText("Zataya's Macro Sets - Browser")

ZatayasMacroSetBrowser.SetsFrame = ZatayasMacroSetBrowser.SetsFrame or
                                       CreateFrame("Frame", "ZatayasMacroSetBrowserSetsFrame", ZatayasMacroSetBrowser)
ZatayasMacroSetBrowser.SetsFrame:EnableMouse(true)
ZatayasMacroSetBrowser.SetsFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})

ZatayasMacroSetBrowser.SetsFrame:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser.SetsFrame:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.SetsFrame:SetPoint("TOPLEFT", ZatayasMacroSetBrowser, "TOPLEFT", 5, -25)
ZatayasMacroSetBrowser.SetsFrame:SetSize(150, ZatayasMacroSetBrowser:GetHeight() - 30)

ZatayasMacroSetBrowser.SetsFrame.ScrollFrame = ZatayasMacroSetBrowser.SetsFrame.ScrollFrame or
                                                   CreateFrame("ScrollFrame", "ZatayasMacroSetBrowserSetsScrollFrame",
        ZatayasMacroSetBrowser.SetsFrame, "UIPanelScrollFrameTemplate")

ZatayasMacroSetBrowser.SetsFrame.ScrollChild = ZatayasMacroSetBrowser.SetsFrame.ScrollChild or
                                                   CreateFrame("Frame", "ZatayasMacroSetBrowserSetsScrollChild", nil) -- ZatayasMacroSetBrowser.SetsFrame.ScrollFrame)

local scrollbarName = ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:GetName()
ZatayasMacroSetBrowser.SetsFrame.ScrollBar = _G[scrollbarName .. "ScrollBar"]
ZatayasMacroSetBrowser.SetsFrame.ScrollUpButton = _G[scrollbarName .. "ScrollBarScrollUpButton"]
ZatayasMacroSetBrowser.SetsFrame.ScrollDownDutton = _G[scrollbarName .. "ScrollBarScrollDownButton"]

ZatayasMacroSetBrowser.SetsFrame.ScrollUpButton:ClearAllPoints()
ZatayasMacroSetBrowser.SetsFrame.ScrollUpButton:SetPoint("TOPRIGHT", ZatayasMacroSetBrowser.SetsFrame.ScrollFrame,
    "TOPRIGHT", -5, -2)

ZatayasMacroSetBrowser.SetsFrame.ScrollDownDutton:ClearAllPoints()
ZatayasMacroSetBrowser.SetsFrame.ScrollDownDutton:SetPoint("BOTTOMRIGHT", ZatayasMacroSetBrowser.SetsFrame.ScrollFrame,
    "BOTTOMRIGHT", -5, 2)

ZatayasMacroSetBrowser.SetsFrame.ScrollBar:ClearAllPoints()
ZatayasMacroSetBrowser.SetsFrame.ScrollBar:SetPoint("TOP", ZatayasMacroSetBrowser.SetsFrame.ScrollUpButton, "BOTTOM", 0,
    4)
ZatayasMacroSetBrowser.SetsFrame.ScrollBar:SetPoint("BOTTOM", ZatayasMacroSetBrowser.SetsFrame.ScrollDownDutton, "TOP",
    0, -4)

ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:SetScrollChild(ZatayasMacroSetBrowser.SetsFrame.ScrollChild)

ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.SetsFrame, "TOPLEFT", 0, -5)
ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", ZatayasMacroSetBrowser.SetsFrame, "BOTTOMRIGHT", 0,
    5)

ZatayasMacroSetBrowser.SetsFrame.ScrollChild:SetSize(ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:GetWidth(),
    (ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:GetHeight() * 2))

ZatayasMacroSetBrowser.SetsFrame.ButtonFrame = ZatayasMacroSetBrowser.SetsFrame.ButtonFrame or
                                                   CreateFrame("Frame", "ZatayasMacroSetBrowserSetsFrameButtonFrame",
        ZatayasMacroSetBrowser.SetsFrame.ScrollChild)
ZatayasMacroSetBrowser.SetsFrame.ButtonFrame:SetAllPoints(ZatayasMacroSetBrowser.SetsFrame.ScrollChild)

ZatayasMacroSetBrowser.SetButtons = {}

local height = -2
for i = 1, 200 do
  local button = CreateFrame("Button", "ZatayasMacroSetBrowserSetsFrameButton" .. i,
      ZatayasMacroSetBrowser.SetsFrame.ButtonFrame)
  button:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.SetsFrame.ButtonFrame, "TOPLEFT", 2, height)
  button:SetSize(128, 20)

  button:SetText("Button" .. i)
  button:GetFontString():SetTextColor(1, 1, 1, 1)
  button:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

  button:SetNormalFontObject("GameFontNormal")

  ZatayasMacroSets:SetTextures(button)
  height = height - 22
  ZatayasMacroSetBrowser.SetsFrame.ButtonFrame:SetSize(100, height + 10)

  button:Hide()
  ZatayasMacroSetBrowser.SetButtons[i] = button
end

ZatayasMacroSetBrowser.SetmacrosFrame = ZatayasMacroSetBrowser.SetmacrosFrame or
                                            CreateFrame("Frame", "ZatayasMacroSetBrowserSetmacrosFrame",
        ZatayasMacroSetBrowser)
ZatayasMacroSetBrowser.SetmacrosFrame:EnableMouse(true)
ZatayasMacroSetBrowser.SetmacrosFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})
ZatayasMacroSetBrowser.SetmacrosFrame:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser.SetmacrosFrame:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.SetmacrosFrame:SetPoint("TOPLEFT", ZatayasMacroSetBrowser, "TOPLEFT", 155, -25)
ZatayasMacroSetBrowser.SetmacrosFrame:SetSize(440, 200)

ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt = ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt or ZatayasMacroSetBrowser.SetmacrosFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt:SetPoint("TOP", ZatayasMacroSetBrowser.SetmacrosFrame, "TOP", 0, -20)
ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt:SetFont("Fonts\\FRIZQT__.TTF", 10, nil)
ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt:SetText("Select a set to continue.")

ZatayasMacroSetBrowser.MacroButtons = {}

local columns = {
  [6] = 0,
  [12] = 0,
  [18] = 0
}
local rows = {
  [1] = -50,
  [2] = -95,
  [3] = -140
}
local row = 1

local x = 85
for i = 1, 18 do
  local button = CreateFrame("Button", "ZatayasMacroSetBrowserSetmacrosFrameMacroButton" .. i,
      ZatayasMacroSetBrowser.SetmacrosFrame)
  button:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.SetmacrosFrame, "TOPLEFT", x, rows[row])
  button:SetSize(40, 40)

  button:SetText(i)
  button:GetFontString():SetTextColor(1, 1, 1, 1)
  button:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

  button:SetNormalFontObject("GameFontNormal")

  --ZatayasMacroSets:SetTextures(button)
  button:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    tile = true,
    tileSize = 32,
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = {
      left = 2,
      right = 2,
      top = 2,
      bottom = 2
    }
  })

  ZatayasMacroSetBrowser.MacroButtons[i] = button

  x = x + 45

  if columns[i] then
    row = row + 1
    x = 85
  end
end

ZatayasMacroSetBrowser.MacroDetailFrame = ZatayasMacroSetBrowser.MacroDetailFrame or
                                              CreateFrame("Frame", "ZatayasMacroSetBrowserMacroDetailFrame",
        ZatayasMacroSetBrowser)
ZatayasMacroSetBrowser.MacroDetailFrame:EnableMouse(true)
ZatayasMacroSetBrowser.MacroDetailFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})

ZatayasMacroSetBrowser.MacroDetailFrame:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser.MacroDetailFrame:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.MacroDetailFrame:SetPoint("TOPLEFT", ZatayasMacroSetBrowser, "TOPLEFT", 155, -225)
ZatayasMacroSetBrowser.MacroDetailFrame:SetSize(440, 185)

ZatayasMacroSetBrowser.MacroDetailFrame.Icon = ZatayasMacroSetBrowser.MacroDetailFrame.Icon or
                                                   CreateFrame("Frame", "ZatayasMacroSetBrowserMacroDetailFrameIcon",
        ZatayasMacroSetBrowser.MacroDetailFrame)
ZatayasMacroSetBrowser.MacroDetailFrame.Icon:EnableMouse(true)
ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})

ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.MacroDetailFrame, "TOPLEFT", 5,
    -5)
ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetSize(40, 40)




ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt = ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt or ZatayasMacroSetBrowser.MacroDetailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.MacroDetailFrame.Icon, "TOPRIGHT", 0, -5)
ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt:SetFont("Fonts\\FRIZQT__.TTF", 10, nil)
ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt:SetText("Select a macro.")



ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder = ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder or
                                                            CreateFrame("Frame",
        "ZatayasMacroSetBrowserMacroDetailFrameEditboxHolder", ZatayasMacroSetBrowser)
ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})
ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.MacroDetailFrame,
    "TOPLEFT", 5, -45)
ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:SetSize(430, 135)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame = ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame or
                                                          CreateFrame("ScrollFrame",
        "ZatayasMacroSetBrowserMacroDetailFrameScrollFrame", ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder,
        "UIPanelScrollFrameTemplate")

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild = ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild or
                                                          CreateFrame("Button",
        "ZatayasMacroSetBrowserMacroDetailFrameScrollChild", nil) -- ZatayasMacroSetBrowser.SetsFrame.ScrollFrame)

local scrollbarName = ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:GetName()
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollBar = _G[scrollbarName .. "ScrollBar"]
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollUpButton = _G[scrollbarName .. "ScrollBarScrollUpButton"]
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollDownDutton = _G[scrollbarName .. "ScrollBarScrollDownButton"]

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollUpButton:ClearAllPoints()
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollUpButton:SetPoint("TOPRIGHT",
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame, "TOPRIGHT", -5, -2)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollDownDutton:ClearAllPoints()
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollDownDutton:SetPoint("BOTTOMRIGHT",
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame, "BOTTOMRIGHT", -5, 2)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollBar:ClearAllPoints()
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollBar:SetPoint("TOP",
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollUpButton, "BOTTOM", 0, 4)
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollBar:SetPoint("BOTTOM",
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollDownDutton, "TOP", 0, -4)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:SetScrollChild(ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:SetPoint("TOPLEFT",
    ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder, "TOPLEFT", 0, -5)
ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:SetPoint("BOTTOMRIGHT",
    ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder, "BOTTOMRIGHT", 0, 5)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild:SetSize(
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:GetWidth(),
    (ZatayasMacroSetBrowser.SetsFrame.ScrollFrame:GetHeight() * 2))

ZatayasMacroSetBrowser.MacroDetailFrame.Editbox = ZatayasMacroSetBrowser.MacroDetailFrame.Editbox or
                                                      CreateFrame('EditBox',
        "ZatayasMacroSetBrowserMacroDetailFrameEditbox", ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetMultiLine(true)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:EnableMouse(true)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetAutoFocus(false)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetMaxLetters(255)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetFont('Fonts\\ARIALN.ttf', 13, 'THINOUTLINE')
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetWidth(400)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetPoint("TOPLEFT", ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild,
    "TOPLEFT", 5, -2)
ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetScript('OnEscapePressed', function(self)
  self:ClearFocus()
end)

local function SetEditHeight()
  if ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:GetHeight() <
      ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:GetHeight() then
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild:SetHeight(
        ZatayasMacroSetBrowser.MacroDetailFrame.EditboxHolder:GetHeight() - 10)
  else
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild:SetHeight(
        ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:GetHeight())
  end
end

ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetScript('OnCursorChanged', function(self)
  local vs = ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:GetVerticalScroll();
  local h = ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:GetHeight();

  if vs + arg2 > 0 or 0 > vs + arg2 - arg4 + h then
    ZatayasMacroSetBrowser.MacroDetailFrame.ScrollFrame:SetVerticalScroll(arg2 * -1);
  end

  SetEditHeight()
  if ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro then
    ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro.body = self:GetText()
  end
end)

ZatayasMacroSetBrowser.MacroDetailFrame.ScrollChild:SetScript("OnClick", function(self, button)
  if button == 'LeftButton' then
    ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetFocus()
  end
end)

SetEditHeight()

ZatayasMacroSetBrowser.ButtonFrame = ZatayasMacroSetBrowser.ButtonFrame or
                                         CreateFrame("Frame", "ZatayasMacroSetBrowserButtonFrame",
        ZatayasMacroSetBrowser)
ZatayasMacroSetBrowser.ButtonFrame:EnableMouse(true)
ZatayasMacroSetBrowser.ButtonFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})
ZatayasMacroSetBrowser.ButtonFrame:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSetBrowser.ButtonFrame:SetBackdropBorderColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.ButtonFrame:SetPoint("TOPLEFT", ZatayasMacroSetBrowser, "TOPLEFT", 155, -408)
ZatayasMacroSetBrowser.ButtonFrame:SetSize(440, 38)

ZatayasMacroSetBrowser.CloseBtn = ZatayasMacroSetBrowser.CloseBtn or
                                      CreateFrame("Button", "ZatayasMacroSetBrowserCloseButton",
        ZatayasMacroSetBrowser.ButtonFrame)
ZatayasMacroSetBrowser.CloseBtn:SetPoint("RIGHT", ZatayasMacroSetBrowser.ButtonFrame, "RIGHT", -5, 0)
ZatayasMacroSetBrowser.CloseBtn:SetSize(75, 23)

ZatayasMacroSetBrowser.CloseBtn:SetText("Close")
ZatayasMacroSetBrowser.CloseBtn:GetFontString():SetTextColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.CloseBtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

ZatayasMacroSetBrowser.CloseBtn:SetNormalFontObject("GameFontNormal")

ZatayasMacroSets:SetTextures(ZatayasMacroSetBrowser.CloseBtn)

ZatayasMacroSetBrowser.CloseBtn:RegisterForClicks("LeftButtonDown")

ZatayasMacroSetBrowser.CloseBtn:SetScript("OnClick", function(self, button, down)
  ZatayasMacroSetBrowser:Hide()
end)


ZatayasMacroSetBrowser.ToGenBtn = ZatayasMacroSetBrowser.ToGenBtn or
                                      CreateFrame("Button", "ZatayasMacroSetBrowserCloseButton",
        ZatayasMacroSetBrowser.ButtonFrame)
ZatayasMacroSetBrowser.ToGenBtn:SetPoint("LEFT", ZatayasMacroSetBrowser.ButtonFrame, "LEFT", 5, 0)
ZatayasMacroSetBrowser.ToGenBtn:SetSize(75, 23)

ZatayasMacroSetBrowser.ToGenBtn:SetText("To General")
ZatayasMacroSetBrowser.ToGenBtn:GetFontString():SetTextColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.ToGenBtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

ZatayasMacroSetBrowser.ToGenBtn:SetNormalFontObject("GameFontNormal")

ZatayasMacroSets:SetTextures(ZatayasMacroSetBrowser.ToGenBtn)

ZatayasMacroSetBrowser.ToGenBtn:RegisterForClicks("LeftButtonDown")

ZatayasMacroSetBrowser.ToGenBtn:SetScript("OnClick", function(self, button, down)
  if ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro then
    if MacroFrame and MacroFrame:IsShown() then
      MacroExitButton:Click() -- Close the window prior to changing macros. The window doesnt seem to update until its closed and opened.
    end
    local macro = ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro
    local _ = CreateMacro(macro.name, ZatayasMacroSets:GetTextureID(macro.iconTexture), macro.body, 0)
    ZatayasMacroSets:PrintToChat("Created macro ".. macro.name.." in General macros.")
    if not MacroFrame or not MacroFrame:IsShown() then
      ShowMacroFrame()
    end
  end
end)

ZatayasMacroSetBrowser.ToGenBtn:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
  GameTooltip:AddLine("Push the currently selected macro into the General Macros");

  GameTooltip:Show()
end)

ZatayasMacroSetBrowser.ToGenBtn:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)


ZatayasMacroSetBrowser.ToCharBtn = ZatayasMacroSetBrowser.ToCharBtn or
                                      CreateFrame("Button", "ZatayasMacroSetBrowserCloseButton",
        ZatayasMacroSetBrowser.ButtonFrame)
ZatayasMacroSetBrowser.ToCharBtn:SetPoint("LEFT", ZatayasMacroSetBrowser.ToGenBtn, "RIGHT", 5, 0)
ZatayasMacroSetBrowser.ToCharBtn:SetSize(75, 23)

ZatayasMacroSetBrowser.ToCharBtn:SetText("To Character")
ZatayasMacroSetBrowser.ToCharBtn:GetFontString():SetTextColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.ToCharBtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

ZatayasMacroSetBrowser.ToCharBtn:SetNormalFontObject("GameFontNormal")

ZatayasMacroSets:SetTextures(ZatayasMacroSetBrowser.ToCharBtn)

ZatayasMacroSetBrowser.ToCharBtn:RegisterForClicks("LeftButtonDown")

ZatayasMacroSetBrowser.ToCharBtn:SetScript("OnClick", function(self, button, down)
  if ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro then
    if MacroFrame and MacroFrame:IsShown() then
      MacroExitButton:Click() -- Close the window prior to changing macros. The window doesnt seem to update until its closed and opened.
    end
    local macro = ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro
    local _ = CreateMacro(macro.name, ZatayasMacroSets:GetTextureID(macro.iconTexture), macro.body, 1)
    ZatayasMacroSets:PrintToChat("Created macro ".. macro.name.." in Character macros.")
    if not MacroFrame or not MacroFrame:IsShown() then
      ShowMacroFrame()
    end
  end
end)

ZatayasMacroSetBrowser.ToCharBtn:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
  GameTooltip:AddLine("Push the currently selected macro into the Character Specific Macros");

  GameTooltip:Show()
end)

ZatayasMacroSetBrowser.ToCharBtn:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)


ZatayasMacroSetBrowser.UpMacBtn = ZatayasMacroSetBrowser.UpMacBtn or
                                      CreateFrame("Button", "ZatayasMacroSetBrowserUpdateMacroButton",
        ZatayasMacroSetBrowser.ButtonFrame)
ZatayasMacroSetBrowser.UpMacBtn:SetPoint("LEFT", ZatayasMacroSetBrowser.ToCharBtn, "RIGHT", 50, 0)
ZatayasMacroSetBrowser.UpMacBtn:SetSize(75, 23)

ZatayasMacroSetBrowser.UpMacBtn:SetText("Update macro")
ZatayasMacroSetBrowser.UpMacBtn:GetFontString():SetTextColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.UpMacBtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

ZatayasMacroSetBrowser.UpMacBtn:SetNormalFontObject("GameFontNormal")

ZatayasMacroSets:SetTextures(ZatayasMacroSetBrowser.UpMacBtn)

ZatayasMacroSetBrowser.UpMacBtn:RegisterForClicks("LeftButtonDown")

ZatayasMacroSetBrowser.UpMacBtn:SetScript("OnClick", function(self, button, down)
  if ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro and ZatayasMacroSetBrowser.MacroDetailFrame.CurrentSet then
    local set = ZatayasMacroSetBrowser.MacroDetailFrame.CurrentSet
    local macro = ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro
    local index = ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacroIndex
    Zms_Config.Sets[set][index].body = macro.body
    ZatayasMacroSets:PrintToChat(string.format("Updated %s in %s", macro.name, set))
  end
end)

ZatayasMacroSetBrowser.UpMacBtn:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
  GameTooltip:AddLine("Push updates to the currently selected macro back into its set.");

  GameTooltip:Show()
end)

ZatayasMacroSetBrowser.UpMacBtn:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)


ZatayasMacroSetBrowser.ShowMacroBtn = ZatayasMacroSetBrowser.ShowMacroBtn or
                                      CreateFrame("Button", "ZatayasMacroSetBrowserShowMacrosButton",
        ZatayasMacroSetBrowser.ButtonFrame)
ZatayasMacroSetBrowser.ShowMacroBtn:SetPoint("TOPLEFT", ZatayasMacroSetBrowser, "TOPLEFT", 10, -5)
ZatayasMacroSetBrowser.ShowMacroBtn:SetSize(50, 20)

ZatayasMacroSetBrowser.ShowMacroBtn:SetText("Macros")
ZatayasMacroSetBrowser.ShowMacroBtn:GetFontString():SetTextColor(1, 1, 1, 1)
ZatayasMacroSetBrowser.ShowMacroBtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

ZatayasMacroSetBrowser.ShowMacroBtn:SetNormalFontObject("GameFontNormal")

ZatayasMacroSets:SetTextures(ZatayasMacroSetBrowser.ShowMacroBtn)

ZatayasMacroSetBrowser.ShowMacroBtn:RegisterForClicks("LeftButtonDown")

ZatayasMacroSetBrowser.ShowMacroBtn:SetScript("OnClick", function(self, button, down)
  ShowMacroFrame()
end)

ZatayasMacroSetBrowser.ShowMacroBtn:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
  GameTooltip:AddLine("Open the standard macro dialog");

  GameTooltip:Show()
end)

ZatayasMacroSetBrowser.ShowMacroBtn:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)


function ZatayasMacroSetBrowser:ClearMacroDetails()
  ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    tile = true,
    tileSize = 32,
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = {
      left = 2,
      right = 2,
      top = 2,
      bottom = 2
    }
  })
  ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetText("")
  ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt:SetText("Select a macro.")
  ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro = nil
end

function ZatayasMacroSetBrowser:LoadMacroDetails(setname, macro, index)
  ZatayasMacroSetBrowser.MacroDetailFrame.Icon:SetBackdrop({
    bgFile = macro.iconTexture,
    tile = true,
    tileSize = 32,
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = {
      left = 2,
      right = 2,
      top = 2,
      bottom = 2
    }
  })
  ZatayasMacroSetBrowser.MacroDetailFrame.Editbox:SetText(macro.body)
  ZatayasMacroSetBrowser.MacroDetailFrame.IconTitleTxt:SetText("Name: "..macro.name)
  ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacro = macro
  ZatayasMacroSetBrowser.MacroDetailFrame.CurrentMacroIndex = index

end

function ZatayasMacroSetBrowser:ResetMacroButtons()

  ZatayasMacroSetBrowser.MacroDetailFrame.CurrentSet = nil
  ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt:SetText("Select a set to continue.")

  for k, v in ipairs(ZatayasMacroSetBrowser.MacroButtons) do
      ZatayasMacroSetBrowser.MacroButtons[k].macro = nil
      ZatayasMacroSetBrowser.MacroButtons[k]:SetText(k)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnLeave", nil)
      
      ZatayasMacroSetBrowser.MacroButtons[k]:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        tile = true,
        tileSize = 32,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {
          left = 2,
          right = 2,
          top = 2,
          bottom = 2
        }
      })
  end
end

function ZatayasMacroSetBrowser:UpdateMacroButtons(setname)
  local row = 0
  local column = 1

  ZatayasMacroSetBrowser.tmplist = {}

  ZatayasMacroSetBrowser.MacroDetailFrame.CurrentSet = setname
  ZatayasMacroSetBrowser.SetmacrosFrameTitleTxt:SetText("Set: "..setname)
  local MacroSet = Zms_Config.Sets[setname]

  for k, v in ipairs(ZatayasMacroSetBrowser.MacroButtons) do

    local x = k + 36

    if MacroSet[x] then
      ZatayasMacroSetBrowser.MacroButtons[k].macro = MacroSet[x]
      ZatayasMacroSetBrowser.MacroButtons[k]:SetText(ZatayasMacroSets:ShortenString(MacroSet[x].name, 4))
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnClick", function(self, button, down)
        ZatayasMacroSetBrowser:LoadMacroDetails(setname, ZatayasMacroSetBrowser.MacroButtons[k].macro, x)
      end)

      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(ZatayasMacroSetBrowser.MacroButtons[k], "ANCHOR_CURSOR");
        GameTooltip:AddLine("|cFFFFFFFF" .. MacroSet[x].name .. "|r");

        GameTooltip:Show()
      end)

      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnLeave", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
      end)

      ZatayasMacroSetBrowser.MacroButtons[k]:SetBackdrop({
        bgFile = MacroSet[x].iconTexture,
        tile = true,
        tileSize = 32,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {
          left = 2,
          right = 2,
          top = 2,
          bottom = 2
        }
      })
      ZatayasMacroSetBrowser.MacroButtons[k]:Show()
    else
      ZatayasMacroSetBrowser.MacroButtons[k].macro = nil
      ZatayasMacroSetBrowser.MacroButtons[k]:SetText(k)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSetBrowser.MacroButtons[k]:SetScript("OnLeave", nil)
      
      ZatayasMacroSetBrowser.MacroButtons[k]:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        tile = true,
        tileSize = 32,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {
          left = 2,
          right = 2,
          top = 2,
          bottom = 2
        }
      })
    end

  end
end

function ZatayasMacroSetBrowser:UpdateSetButtons()
  local row = 0
  local column = 1

  ZatayasMacroSetBrowser.tmplist = {}
  local y = 1
  for k, v in pairs(Zms_Config.Sets) do -- convert list of use in spairs
    ZatayasMacroSetBrowser.tmplist[y] = {}
    ZatayasMacroSetBrowser.tmplist[y].Name = k
    ZatayasMacroSetBrowser.tmplist[y].Set = v
    ZatayasMacroSetBrowser.tmplist[y].Index = y
    y = y + 1
  end

  ZatayasMacroSetBrowser.sortedlist = {}

  local z = 1
  for k, v in spairs(ZatayasMacroSetBrowser.tmplist, function(t, a, b)
    return string.lower(t[b].Name) > string.lower(t[a].Name)
  end) do
    ZatayasMacroSetBrowser.sortedlist[z] = v
    z = z + 1
  end

  for k, v in ipairs(ZatayasMacroSetBrowser.SetButtons) do

    if ZatayasMacroSetBrowser.sortedlist[k] then

      ZatayasMacroSetBrowser.SetButtons[k]:SetText(ZatayasMacroSets:ShortenString(ZatayasMacroSetBrowser.sortedlist[k].Name, 16))
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnClick", function(self, button, down)
        ZatayasMacroSetBrowser:UpdateMacroButtons(ZatayasMacroSetBrowser.sortedlist[k].Name)
      end)

      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(ZatayasMacroSetBrowser.SetButtons[k], "ANCHOR_CURSOR");
        GameTooltip:AddLine("|cFFFFFFFF" .. ZatayasMacroSetBrowser.sortedlist[k].Name .. "|r");
        GameTooltip:Show()
      end)

      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnLeave", nil)
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
      end)

      ZatayasMacroSetBrowser.SetButtons[k]:Show()
    else
      ZatayasMacroSetBrowser.SetButtons[k]:SetText("Button" .. k)
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSetBrowser.SetButtons[k]:SetScript("OnLeave", nil)
      ZatayasMacroSetBrowser.SetButtons[k]:Hide()
    end

  end

  local count = 0
  for _ in pairs(Zms_Config.Sets)do count = count + 1 end
  ZatayasMacroSetBrowser.SetsFrame.ScrollChild:SetHeight( count * 25)
end

ZatayasMacroSetBrowser:Hide()