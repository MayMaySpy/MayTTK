-------------------------------------------------------------------------------
-- MayTTK: Core Module
-- Event handling, slash commands, initialization
-- Must load last (see .toc)
-------------------------------------------------------------------------------
local addonName, addon = ...
local L = addon.L

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local FRAME_DETECTION_DELAY = 0.5    -- Seconds to wait before detecting UI frames

-- State
addon.isInitialized = false
addon.lastUpdate = 0
addon.eventFrame = nil

-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
function addon:Initialize()
    if self.isInitialized then return end
    
    MayTTKDB = MayTTKDB or {}
    MayTTKDB = self:MigrateConfig(MayTTKDB)
    
    -- Ensure nested tables exist in SavedVariables (not just via __index)
    -- This is required for LibDBIcon to properly save minimap position
    MayTTKDB.minimap = MayTTKDB.minimap or {}
    for k, v in pairs(self.DEFAULT_CONFIG.minimap) do
        if MayTTKDB.minimap[k] == nil then
            MayTTKDB.minimap[k] = v
        end
    end
    
    -- Validate config values are within expected ranges
    MayTTKDB = self:ValidateConfig(MayTTKDB)
    
    self.config = setmetatable(MayTTKDB, { __index = self.DEFAULT_CONFIG })
    
    self:RegisterEvents()
    self:CreateDisplayFrame()
    self:CreateMinimapButton()
    self:RegisterSlashCommands()
    
    print(string.format(L["ADDON_LOADED"], self.VERSION))
    self.isInitialized = true
    self:Debug("Initialization complete")
end

-------------------------------------------------------------------------------
-- Minimap Button (LibDBIcon)
-- Uses the standard LibDBIcon library for maximum compatibility with all
-- minimap shapes and LDB-compatible displays.
-------------------------------------------------------------------------------
function addon:CreateMinimapButton()
    if self.LDBObject then return end
    
    local LDB = LibStub("LibDataBroker-1.1", true)
    local LDBIcon = LibStub("LibDBIcon-1.0", true)
    
    if not LDB or not LDBIcon then
        self:Debug("LibDataBroker or LibDBIcon not found")
        return
    end
    
    -- Create the data broker object
    -- Note: Callbacks capture 'self' from outer scope for consistent access
    self.LDBObject = LDB:NewDataObject("MayTTK", {
        type = "data source",
        text = "MayTTK",
        icon = self.Media.icon,
        OnClick = function(_, button)
            if button == "LeftButton" then
                self:ShowConfig()
            elseif button == "RightButton" then
                self.config.enabled = not self.config.enabled
                self:UpdateMinimapIcon()
                print(string.format(L["ADDON_STATUS"], self.config.enabled and L["ENABLED"] or L["DISABLED"]))
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText("MayTTK", 1, 1, 1)
            tooltip:AddLine(L["COMPARTMENT_TOOLTIP"], nil, nil, nil, true)
            tooltip:AddLine(" ")
            tooltip:AddDoubleLine(L["COMPARTMENT_LEFT_CLICK"], L["COMPARTMENT_SETTINGS"], 0.8, 0.8, 0.8, 1, 1, 1)
            tooltip:AddDoubleLine(L["COMPARTMENT_RIGHT_CLICK"], L["COMPARTMENT_TOGGLE"], 0.8, 0.8, 0.8, 1, 1, 1)
            tooltip:AddLine(" ")
            tooltip:AddLine(L["MINIMAP_DRAG"], 0.5, 0.5, 0.5)
        end,
    })
    
    -- Register with LibDBIcon
    LDBIcon:Register("MayTTK", self.LDBObject, self.config.minimap)
    
    self.LDBIcon = LDBIcon
    self:UpdateMinimapIcon()
    self:Debug("Minimap button created (LibDBIcon)")
end

function addon:UpdateMinimapIcon()
    if not self.LDBIcon then return end
    
    local button = self.LDBIcon:GetMinimapButton("MayTTK")
    if button and button.icon then
        if self.config.enabled then
            button.icon:SetDesaturated(false)
            button.icon:SetVertexColor(1, 1, 1)
        else
            button.icon:SetDesaturated(true)
            button.icon:SetVertexColor(0.5, 0.5, 0.5)
        end
    end
end

function addon:ToggleMinimapButton()
    if not self.LDBIcon then return end
    
    if self.config.minimap.hide then
        self.LDBIcon:Hide("MayTTK")
    else
        self.LDBIcon:Show("MayTTK")
    end
end

-------------------------------------------------------------------------------
-- Slash Commands
-------------------------------------------------------------------------------
local slashCommands = {
    toggle = function(self)
        self.config.enabled = not self.config.enabled
        self:UpdateMinimapIcon()
        print(string.format(L["ADDON_STATUS"], self.config.enabled and L["ENABLED"] or L["DISABLED"]))
        if not self.config.enabled and self.ttkFrame then self.ttkFrame:Hide() end
    end,
    show = function(self)
        self.config.showUI = true
        if self.ttkFrame then self.ttkFrame:Show() end
        print(L["FRAME_SHOWN"])
    end,
    hide = function(self)
        self.config.showUI = false
        if self.ttkFrame then self.ttkFrame:Hide() end
        print(L["FRAME_HIDDEN"])
    end,
    test = function(self) self:TogglePreview() end,
    preview = function(self) self:TogglePreview() end,
    lock = function(self)
        self.config.lockFrame = not self.config.lockFrame
        print(self.config.lockFrame and L["FRAME_LOCKED"] or L["FRAME_UNLOCKED"])
    end,
    reset = function(self) self:ResetFramePosition() print(L["FRAME_RESET"]) end,
    minimap = function(self)
        self.config.minimap.hide = not self.config.minimap.hide
        self:ToggleMinimapButton()
        print(string.format(L["MINIMAP_STATUS"], not self.config.minimap.hide and L["ENABLED"] or L["DISABLED"]))
    end,
    debug = function(self) self:ToggleDebug() end,
    help = function(self) print(L["CMD_HELP"]) end,
}

function addon:RegisterSlashCommands()
    SLASH_MAYTTK1, SLASH_MAYTTK2 = "/mayttk", "/ttk"
    SlashCmdList["MAYTTK"] = function(msg)
        local cmd = msg:lower():trim()
        local handler = slashCommands[cmd]
        if handler then handler(addon) else addon:ShowConfig() end
    end
end

-------------------------------------------------------------------------------
-- Event Handling
-------------------------------------------------------------------------------
function addon:RegisterEvents()
    if self.eventFrame then self.eventFrame:UnregisterAllEvents() end
    
    local frame = self.eventFrame or CreateFrame("Frame")
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    
    frame:SetScript("OnEvent", function(_, event, ...)
        local success, err = pcall(self.OnEvent, self, event, ...)
        if not success and self.debugMode then
            self:Debug("Event error (%s): %s", event, tostring(err))
        end
    end)
    
    self.eventFrame = frame
    self:Debug("Events registered")
end

function addon:UnregisterEvents()
    if self.eventFrame then
        self.eventFrame:UnregisterAllEvents()
        self:StopUpdates()
        self:Debug("Events unregistered")
    end
end

function addon:StartUpdates()
    if self._updatesActive then return end
    if not self.eventFrame then return end
    
    self.eventFrame:SetScript("OnUpdate", function(_, elapsed)
        local success, err = pcall(self.OnUpdate, self, elapsed)
        if not success and self.debugMode then
            self:Debug("OnUpdate error: %s", tostring(err))
        end
    end)
    self._updatesActive = true
    self:Debug("Updates started")
end

function addon:StopUpdates()
    if not self._updatesActive then return end
    if self.eventFrame then
        self.eventFrame:SetScript("OnUpdate", nil)
    end
    self._updatesActive = false
    self:Debug("Updates stopped")
end

function addon:OnEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:Debug("PLAYER_ENTERING_WORLD - resetting state")
        if self.ttkFrame and not self.isPreviewMode then self.ttkFrame:Hide() end
        self:ClearAllData()
        self.currentTargetGUID = nil
        self:StopUpdates()
        
        if not self.frameDetectionDone then
            C_Timer.After(FRAME_DETECTION_DELAY, function()
                self:DelayedFrameDetection()
                self.frameDetectionDone = true
            end)
        end
        return
    end
    
    if not self.config.enabled then return end
    
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        self:HandleCombatLog()
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.currentTargetGUID = UnitGUID("target")
        self:Debug("Target changed: %s", self.currentTargetGUID or "nil")
        
        if self.currentTargetGUID and self.Compat.UnitCanAttack("player", "target") then
            self:StartUpdates()
        else
            self:StopUpdates()
            if self.ttkFrame and not self.isPreviewMode then self.ttkFrame:Hide() end
        end
        self:UpdateDisplay()
    elseif event == "PLAYER_REGEN_DISABLED" then
        self:Debug("Combat started")
        if self.currentTargetGUID then
            self:StartUpdates()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:Debug("Combat ended - clearing data")
        self:ClearAllData()
        self.currentTargetGUID = nil
        self:StopUpdates()
        if not self.isPreviewMode and self.ttkFrame then self.ttkFrame:Hide() end
    end
end

function addon:OnUpdate(elapsed)
    self.lastUpdate = self.lastUpdate + elapsed
    if self.lastUpdate >= self.config.updateInterval then
        local success, err = pcall(self.UpdateDisplay, self)
        if not success and self.debugMode then
            self:Debug("UpdateDisplay error: %s", tostring(err))
        end
        self.lastUpdate = 0
    end
end

-------------------------------------------------------------------------------
-- Combat Log Processing
-------------------------------------------------------------------------------

--[[
SPELL_ABSORBED has a variable argument structure depending on what caused
the damage that was absorbed. The absorb amount is always the last numeric
argument, but its position varies:

1. Spell damage absorbed by spell shield:
   [1-11] Standard prefix, [12-14] damaging spell info, [15-17] absorbing spell info,
   [18] absorber GUID, [19] absorber name, [20] absorber flags, [21] absorber raid flags,
   [22] ABSORB AMOUNT

2. Spell damage absorbed by buff:
   [1-11] Standard prefix, [12-14] damaging spell info, [15] absorber GUID,
   [16] absorber name, [17] absorber flags, [18] absorber raid flags,
   [19] ABSORB AMOUNT

3. Swing damage absorbed:
   [1-11] Standard prefix, [12] absorber GUID, [13] absorber name,
   [14] absorber flags, [15] absorber raid flags, [16] ABSORB AMOUNT

We detect the format by checking which argument position contains a number,
starting from the end (most common case first).
--]]
function addon:HandleCombatLog()
    local cachedTargetGUID = self.currentTargetGUID
    if not cachedTargetGUID then return end
    
    local _, subevent, _, _, _, _, _, eventTargetGUID, _, _, _,
          arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22 = CombatLogGetCurrentEventInfo()
    
    if eventTargetGUID ~= cachedTargetGUID then return end
    
    -- Handle absorb events
    if subevent == "SPELL_ABSORBED" then
        local absorbAmount
        local absorbFormat = "unknown"
        
        -- Check for absorb amount in expected positions (most common first)
        if type(arg22) == "number" then
            absorbAmount = arg22
            absorbFormat = "spell-spell"
        elseif type(arg19) == "number" then
            absorbAmount = arg19
            absorbFormat = "spell-buff"
        elseif type(arg16) == "number" then
            absorbAmount = arg16
            absorbFormat = "swing"
        end
        
        if absorbAmount and absorbAmount > 0 then
            self:RecordAbsorb(eventTargetGUID, absorbAmount)
            self:Debug("Absorb recorded: %d (format: %s)", absorbAmount, absorbFormat)
        elseif self.debugMode then
            -- Log unexpected format for debugging
            self:Debug("SPELL_ABSORBED: Could not parse absorb amount. arg16=%s, arg19=%s, arg22=%s",
                tostring(arg16), tostring(arg19), tostring(arg22))
        end
        return
    end
    
    -- Handle damage events
    local amount, overkill
    if subevent == "SWING_DAMAGE" then
        amount, overkill = arg12, arg13
    elseif subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "RANGE_DAMAGE" then
        amount, overkill = arg15, arg16
    else
        return
    end
    
    overkill = overkill or 0
    if overkill > 0 then
        amount = amount - overkill
    end
    
    if amount and amount > 0 then
        self:RecordDamage(eventTargetGUID, amount)
        self:Debug("Damage: %d (%s)%s", amount, subevent, 
            overkill > 0 and string.format(" [overkill: %d]", overkill) or "")
    end
end

-------------------------------------------------------------------------------
-- Addon Loader
-------------------------------------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, loadedAddon)
    if loadedAddon == addonName then
        self:UnregisterEvent("ADDON_LOADED")
        addon:Initialize()
    end
end)

_G["MayTTK"] = addon

-------------------------------------------------------------------------------
-- Addon Compartment (Retail 10.x+)
-- Note: These are global functions called by WoW, so we use 'addon' explicitly
-------------------------------------------------------------------------------
function MayTTK_OnAddonCompartmentClick(_, button)
    if button == "LeftButton" then
        addon:ShowConfig()
    elseif button == "RightButton" then
        addon.config.enabled = not addon.config.enabled
        addon:UpdateMinimapIcon()
        print(string.format(L["ADDON_STATUS"], addon.config.enabled and L["ENABLED"] or L["DISABLED"]))
    end
end

function MayTTK_OnAddonCompartmentEnter(_, menuButtonFrame)
    GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_LEFT")
    GameTooltip:SetText("MayTTK", 1, 1, 1)
    GameTooltip:AddLine(L["COMPARTMENT_TOOLTIP"], nil, nil, nil, true)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["COMPARTMENT_LEFT_CLICK"], L["COMPARTMENT_SETTINGS"], 0.8, 0.8, 0.8, 1, 1, 1)
    GameTooltip:AddDoubleLine(L["COMPARTMENT_RIGHT_CLICK"], L["COMPARTMENT_TOGGLE"], 0.8, 0.8, 0.8, 1, 1, 1)
    GameTooltip:Show()
end

function MayTTK_OnAddonCompartmentLeave()
    GameTooltip:Hide()
end
