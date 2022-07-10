-- Created by Zataya - A52 (Ascension) - Zoey#0666 Discord
-- If you require modifications to this addon please let me know so i can put out an update. 
-- I prefer to not create forks. If you do fork this, please credit me and also let me know.
local addonname, addon = ...

local ZatayasMacroSets = ZatayasMacroSets or CreateFrame("Frame", "ZatayasMacroSets", MacroFrame)
ZatayasMacroSets:SetScript("OnEvent", function(self, event, ...)
  self[event](self, ...)
end)

Zms_Config = {} -- Global config table for savedvariables
Zms_Config.Sets = {}

ZatayasMacroSets.Version = GetAddOnMetadata(addonname, "Version")

ZatayasMacroSets.AddonNameChatColor = "|cFF9370DB"
ZatayasMacroSets.TextChatColor = "|cFFFFFFFF"

ZatayasMacroSets.isInCombat = false

ZatayasMacroSets:SetSize(600, 432)
ZatayasMacroSets:ClearAllPoints()
ZatayasMacroSets:EnableMouse(true)
ZatayasMacroSets:SetBackdrop({
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
ZatayasMacroSets:SetBackdropColor(0, 0, 0, 1)
ZatayasMacroSets:SetBackdropBorderColor(1, 1, 1, 1)
-- --/frame

ZatayasMacroSets.ZatayasMacroSetsTitleTxt = ZatayasMacroSets:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMacroSets.ZatayasMacroSetsTitleTxt:SetPoint("TOP", ZatayasMacroSets, "TOP", 0, -5)
ZatayasMacroSets.ZatayasMacroSetsTitleTxt:SetFont("Fonts\\FRIZQT__.TTF", 10, nil)
ZatayasMacroSets.ZatayasMacroSetsTitleTxt:SetText("Zataya's Macro Sets")

ZatayasMacroSets.ZatayasMacroSetsSetCntTxt = ZatayasMacroSets:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMacroSets.ZatayasMacroSetsSetCntTxt:SetPoint("BOTTOMLEFT", ZatayasMacroSets, "BOTTOMLEFT", 15, 8)
ZatayasMacroSets.ZatayasMacroSetsSetCntTxt:SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

function ZatayasMacroSets:SetTextures(button)
  local ntex = button:CreateTexture()
  ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
  ntex:SetTexCoord(0, 0.625, 0, 0.6875)
  ntex:SetAllPoints()
  button:SetNormalTexture(ntex)

  local htex = button:CreateTexture()
  htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
  htex:SetTexCoord(0, 0.625, 0, 0.6875)
  htex:SetAllPoints()
  button:SetHighlightTexture(htex)

  local ptex = button:CreateTexture()
  ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
  ptex:SetTexCoord(0, 0.625, 0, 0.6875)
  ptex:SetAllPoints()
  button:SetPushedTexture(ptex)
end

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

function ZatayasMacroSets:PutInChatBox(text)
  text = type(text) ~= "string" and "" or text
  local e = SELECTED_CHAT_FRAME.editBox
  ChatEdit_ActivateChat(e)
  e:SetText(text)
end

function ZatayasMacroSets:slashCommand(command, args)
  for key, func in pairs(SlashCmdList) do
    local i = 1
    local c = _G[("SLASH_%s1"):format(key)]
    while c do
      if c == command then
        func(args)
        return
      end
      i = i + 1
      c = _G[("SLASH_%s%d"):format(key, i)]
    end
  end
end

function ZatayasMacroSets:Trim(s)
  return s:match("^%s*(.-)%s*$")
end

function ZatayasMacroSets:ShortenString(s, max)
  --local max = 16
  if s then
    local len = #s
    if len > max then
      return string.sub(s, 1, max) .. ".."
    else
      return s
    end
  end
end

function ZatayasMacroSets:GetTextureID(texture)
  for i = 1, GetNumMacroIcons() do
    local t = GetMacroIconInfo(i)
    if texture == t then
      return i
    end
  end
  return 1
end

function ZatayasMacroSets:SaveSet(setname)
  Zms_Config.Sets[setname] = {}

  for macroSlot = 37, 54 do
    local name, iconTexture, body, isLocal = GetMacroInfo(macroSlot)
    if name then
      Zms_Config.Sets[setname][macroSlot] = {}
      Zms_Config.Sets[setname][macroSlot].name = name
      Zms_Config.Sets[setname][macroSlot].iconTexture = iconTexture
      Zms_Config.Sets[setname][macroSlot].body = body
      Zms_Config.Sets[setname][macroSlot].isLocal = isLocal
    else
      Zms_Config.Sets[setname][macroSlot] = false
    end
  end
  ZatayasMacroSets:PrintToChat(string.format("Saved: %s", setname))
  ZatayasMacroSets:UpdateSetButtons()
  ZatayasMacroSets:UpdateSetButtons()
end

function ZatayasMacroSets:RestoreSet(setname)
  if not ZatayasMacroSets.isInCombat then
    if Zms_Config.Sets[setname] then
      if MacroFrame and MacroFrame:IsShown() then
        MacroExitButton:Click() -- Close the window prior to changing macros. The window doesnt seem to update until its closed and opened.
      end

      local d = 54
      while (true) do -- looping backwards since macros move up in the index as ones below get deleted. Could also just keep deleting index 1 until GetMacroInfo(1) returns nil
        DeleteMacro(d)

        d = d - 1
        if d == 36 then
          break
        end
      end

      for macroSlot = 37, 54 do
        local newName, newIconTexture, newBody, newisLocal

        if Zms_Config.Sets[setname][macroSlot] then
          newName = Zms_Config.Sets[setname][macroSlot].name
          newIconTexture = Zms_Config.Sets[setname][macroSlot].iconTexture
          newBody = Zms_Config.Sets[setname][macroSlot].body
          newisLocal = Zms_Config.Sets[setname][macroSlot].isLocal
        end

        local name, iconTexture, body, isLocal = GetMacroInfo(macroSlot)

        if name and newName then
          -- edit -- we are deleting all macros before restore now, so this isnt really needed, but leaving it anyway
          local _ = EditMacro(macroSlot, newName, ZatayasMacroSets:GetTextureID(newIconTexture), newBody, newisLocal, 1)
        elseif not name and newName then
          -- create
          local _ = CreateMacro(newName, ZatayasMacroSets:GetTextureID(newIconTexture), newBody, 1)
        end
      end
      ZatayasMacroSets:PrintToChat(string.format("Restored: %s", setname))

      if not MacroFrame or not MacroFrame:IsShown() then
        ShowMacroFrame()
      end
    else
      ZatayasMacroSets:PrintToChat(string.format("%s does not exist", setname))
    end
  else
    ZatayasMacroSets:PrintToChat(string.format("Please leave combat and try again!"))
  end

end

function ZatayasMacroSets:PrintToChat(msg)
  local output = ZatayasMacroSets.AddonNameChatColor .. "ZMS:|r " .. ZatayasMacroSets.TextChatColor .. msg .. "|r"
  if DEFAULT_CHAT_FRAME == SELECTED_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage(output)
  else
    DEFAULT_CHAT_FRAME:AddMessage(output)
    SELECTED_CHAT_FRAME:AddMessage(output)
  end
end

function ZatayasMacroSets:SetFrameHooks()
  ShowMacroFrame() -- macroframe doesnt exist until it is opened

  ZatayasMacroSets:SetParent(MacroFrame)
  MacroFrame:HookScript("OnShow", function()
    -- ZatayasMacroSets:SetParent(MacroFrame)
    ZatayasMacroSets:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", -30, -10)
    ZatayasMacroSets:UpdateSetButtons()
    ZatayasMacroSets:Show()
  end)

  MacroFrame:HookScript("OnHide", function()
    if ZatayasMacroSets:IsShown() then
      ZatayasMacroSets:Hide()
    end
  end)

  MacroExitButton:Click() -- close the macro window
end

-- frame events
function ZatayasMacroSets:CheckUpdates()
  if not Zms_Config then
    Zms_Config = {}
  end
  if not Zms_Config.Sets then
    Zms_Config.Sets = {}
  end
end

ZatayasMacroSets:RegisterEvent("ADDON_LOADED")
function ZatayasMacroSets:ADDON_LOADED(...)
  if addonname == ... then
    ZatayasMacroSets:CheckUpdates()
    ZatayasMacroSets:CreateSetsButtons()
  end
end

ZatayasMacroSets:RegisterEvent("PLAYER_LOGIN")
function ZatayasMacroSets:PLAYER_LOGIN(...)
  ZatayasMacroSets:PrintToChat(string.format("%s loaded! %s /zms", addonname, ZatayasMacroSets.Version))

  ZatayasMacroSets:SetFrameHooks()
end

ZatayasMacroSets:RegisterEvent("PLAYER_REGEN_ENABLED")
function ZatayasMacroSets:PLAYER_REGEN_ENABLED(...)
  ZatayasMacroSets.isInCombat = false
end

ZatayasMacroSets:RegisterEvent("PLAYER_REGEN_DISABLED")
function ZatayasMacroSets:PLAYER_REGEN_DISABLED(...)
  ZatayasMacroSets.isInCombat = true
end
-- /frameevents 

-- Buttons

ZatayasMacroSets.MacroSetButtons = {} -- buttons displayed in our frame for each saved set.

local columns = {
  [16] = 1,
  [32] = 2,
  [48] = 3,
  [64] = 4,
  [80] = 5,
  [96] = 6,
  [112] = 7,
  [128] = 8,
  [144] = 9,
  [160] = 10
}

function ZatayasMacroSets:CreateSetsButtons()

  local vspace = 3
  local hspace = 9

  local top = -40

  local x = hspace
  local y = top

  local h = 20
  local w = 100

  for i = 1, 176 do

    local button = CreateFrame("Button", "ZatayasMacroSetsSetButton" .. i, ZatayasMacroSets)
    button:SetPoint("TOPLEFT", ZatayasMacroSets, "TOPLEFT", x, y)
    button:SetWidth(w)
    button:SetHeight(h)

    button:SetText("Button" .. i)
    button:GetFontString():SetTextColor(1, 1, 1, 1)
    button:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

    button:SetNormalFontObject("GameFontNormal")

    ZatayasMacroSets:SetTextures(button)

    button:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown")

    ZatayasMacroSets.MacroSetButtons[i] = button

    y = y - h - vspace

    if columns[i] then
      x = (w * columns[i]) + hspace
      y = top
    end
  end

  ZatayasMacroSets:UpdateSetButtons()

  local newbtn = CreateFrame("Button", nil, ZatayasMacroSets)
  newbtn:SetPoint("TOP", ZatayasMacroSets, "TOP", 0, -20)
  newbtn:SetHeight(15)
  newbtn:SetWidth(40)
  newbtn:SetText("new")
  newbtn:GetFontString():SetTextColor(1, 1, 1, 1)
  newbtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

  newbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMacroSets:SetTextures(newbtn)

  newbtn:SetScript("OnClick", function(self, button, down)
    ZatayasMacroSets:PrintToChat("Please enter a name")
    ZatayasMacroSets:PutInChatBox("/zms save ")
  end)

  newbtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(newbtn, "ANCHOR_CURSOR");
    GameTooltip:AddLine("Save a new set of macros.");
    GameTooltip:Show()
  end)

  newbtn:SetScript("OnLeave", function(self)
    GameTooltip:Hide();
  end)

  local brwrbtn = CreateFrame("Button", nil, ZatayasMacroSets)
  brwrbtn:SetPoint("TOP", ZatayasMacroSets, "BOTTOM", 0, 0)
  brwrbtn:SetHeight(15)
  brwrbtn:SetWidth(40)
  brwrbtn:SetText("browser")
  brwrbtn:GetFontString():SetTextColor(1, 1, 1, 1)
  brwrbtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

  newbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMacroSets:SetTextures(brwrbtn)

  brwrbtn:SetScript("OnClick", function(self, button, down)
    ZatayasMacroSetBrowser:Show()
  end)

  brwrbtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(brwrbtn, "ANCHOR_CURSOR");
    GameTooltip:AddLine("Open the macro set browser");
    GameTooltip:Show()
  end)

  newbtn:SetScript("OnLeave", function(self)
    GameTooltip:Hide();
  end)
end

local framewidthsbycolumn = {
  [1] = 118,
  [2] = 218,
  [3] = 318,
  [4] = 418,
  [5] = 518,
  [6] = 618,
  [7] = 718,
  [8] = 818,
  [9] = 918,
  [10] = 1018
}

local frameheightsbyrow = {
  [0] = 50,
  [1] = 82,
  [2] = 105,
  [3] = 128,
  [4] = 151,
  [5] = 174,
  [6] = 197,
  [7] = 220,
  [8] = 243,
  [9] = 266,
  [10] = 289,
  [11] = 312,
  [12] = 335,
  [13] = 358,
  [14] = 381,
  [15] = 404,
  [16] = 427,
  [17] = 450,
  [18] = 473,
  [19] = 496,
  [20] = 519
}

function ZatayasMacroSets:UpdateSetButtons()
  local row = 0
  local column = 1
  local sets = 0

  ZatayasMacroSets.tmplist = {}
  local y = 1
  for k, v in pairs(Zms_Config.Sets) do -- convert list of use in spairs
    ZatayasMacroSets.tmplist[y] = {}
    ZatayasMacroSets.tmplist[y].Name = k
    ZatayasMacroSets.tmplist[y].Set = v
    ZatayasMacroSets.tmplist[y].Index = y
    y = y + 1
  end

  ZatayasMacroSets.sortedlist = {}

  local z = 1
  for k, v in spairs(ZatayasMacroSets.tmplist, function(t, a, b)
    return string.lower(t[b].Name) > string.lower(t[a].Name)
  end) do
    ZatayasMacroSets.sortedlist[z] = v
    z = z + 1
  end

  for k, v in ipairs(ZatayasMacroSets.MacroSetButtons) do

    if ZatayasMacroSets.sortedlist[k] then

      if columns[k] then
        column = column + 1
      end

      if row < 20 then
        row = row + 1
      end

      ZatayasMacroSets.MacroSetButtons[k]:SetText(ZatayasMacroSets:ShortenString(ZatayasMacroSets.sortedlist[k].Name, 16))
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnClick", function(self, button, down)
        if button and button == "LeftButton" then
          ZatayasMacroSets:RestoreSet(ZatayasMacroSets.sortedlist[k].Name)
        elseif button and button == "RightButton" then
          ZatayasMacroSets:PrintToChat("Please press [Enter] to confirm.")
          ZatayasMacroSets:PutInChatBox("/zms save " .. ZatayasMacroSets.sortedlist[k].Name)
        elseif button and button == "MiddleButton" then
          ZatayasMacroSets:PrintToChat("Please press [Enter] to confirm.")
          ZatayasMacroSets:PutInChatBox("/zms delete " .. ZatayasMacroSets.sortedlist[k].Name)
        end
      end)

      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(ZatayasMacroSets.MacroSetButtons[k], "ANCHOR_CURSOR");
        GameTooltip:AddLine("|cFFFFFFFF" .. ZatayasMacroSets.sortedlist[k].Name .. "|r");
        GameTooltip:AddLine("Left Click: Restore Set");
        GameTooltip:AddLine("Right Click: Overwrite over this set with current macros");
        GameTooltip:AddLine("Middle Click: To delete this set");

        GameTooltip:Show()
      end);

      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnLeave", nil)
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
      end);

      sets = k
      ZatayasMacroSets.MacroSetButtons[k]:Show()
    else
      ZatayasMacroSets.MacroSetButtons[k]:SetText("Button" .. k)
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnClick", nil)
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnEnter", nil)
      ZatayasMacroSets.MacroSetButtons[k]:SetScript("OnLeave", nil)
      ZatayasMacroSets.MacroSetButtons[k]:Hide()
    end

  end

  ZatayasMacroSets.ZatayasMacroSetsSetCntTxt:SetText(string.format("Sets: %s", sets))
  ZatayasMacroSets:SetSize(framewidthsbycolumn[column], frameheightsbyrow[row])
end

function ZatayasMacroSets:PrintHelp()
  ZatayasMacroSets:PrintToChat("/zms or /ZatayasMacroSets")
  ZatayasMacroSets:PrintToChat(
      "/zms save setname | to save your current macros to a set, provide an existing setname to overwrite")
  ZatayasMacroSets:PrintToChat(
      "/zms restore setname | to restore the saved set to your current macros, Must be out of combat!")
  ZatayasMacroSets:PrintToChat(
      "/zms delete setname | to delete this saved set. This cannot be undone. The macros will be gone..")
end

SLASH_ZMS1 = "/Zms"
SLASH_ZMS2 = "/ZatayasMacroSets"
SlashCmdList["ZMS"] = function(msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if msg ~= "" then
    if string.lower(cmd) == "save" then
      if args then
        ZatayasMacroSets:SaveSet(args)
      else
        ZatayasMacroSets:PrintToChat("Please provide a name.")
      end
    elseif string.lower(cmd) == "restore" then
      if args then
        ZatayasMacroSets:RestoreSet(args)
      else
        ZatayasMacroSets:PrintToChat("Please provide a name.")
      end
    elseif string.lower(cmd) == "list" then
      for k, v in pairs(Zms_Config.Sets) do
        ZatayasMacroSets:PrintToChat(k)
      end
    elseif string.lower(cmd) == "delete" then
      if args then
        if Zms_Config.Sets[args] then
          Zms_Config.Sets[args] = nil
          ZatayasMacroSets:PrintToChat(string.format("Set %s has been deleted.", args))
          ZatayasMacroSets:UpdateSetButtons()
        else
          ZatayasMacroSets:PrintToChat(string.format("No set with name %s exists. Nothing to delete.", args))
        end
      else
        ZatayasMacroSets:PrintToChat("Please provide a name.")
      end
    elseif string.lower(cmd) == "browser" then
      ZatayasMacroSetBrowser:Show()
    else
      ZatayasMacroSets:PrintHelp()
    end
  else
    ZatayasMacroSets:PrintHelp()
  end
end
