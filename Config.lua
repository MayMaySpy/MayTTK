-------------------------------------------------------------------------------
-- MayTTK: Configuration
-- Constants, defaults, presets, and utility functions
-------------------------------------------------------------------------------
local addonName, addon = ...

-- Addon Metadata
addon.name = addonName
addon.VERSION = "1.0.0"
addon.AUTHOR = "May"
addon.CONFIG_VERSION = 1

-- Debug Mode
addon.debugMode = false

function addon:Debug(fmt, ...)
    if not self.debugMode then return end
    local msg
    if select("#", ...) > 0 then
        local success, result = pcall(string.format, fmt, ...)
        msg = success and result or (fmt .. " [format error]")
    else
        msg = fmt
    end
    print("|cff888888[MayTTK Debug]|r", msg)
end

function addon:ToggleDebug()
    self.debugMode = not self.debugMode
    print(self.L[self.debugMode and "CMD_DEBUG_ON" or "CMD_DEBUG_OFF"])
end

-------------------------------------------------------------------------------
-- Media Assets
-------------------------------------------------------------------------------
addon.Media = {
    backdrop = "Interface\\Tooltips\\UI-Tooltip-Background",
    border   = "Interface\\Tooltips\\UI-Tooltip-Border",
    icon     = "Interface\\Icons\\ability_warrior_bloodbath",
}

-------------------------------------------------------------------------------
-- Font Options
-------------------------------------------------------------------------------
addon.FONTS = {
    { name = "Friz Quadrata", path = "Fonts\\FRIZQT__.TTF" },
    { name = "Morpheus",      path = "Fonts\\MORPHEUS.TTF" },
    { name = "Skurri",        path = "Fonts\\SKURRI.TTF" },
    { name = "Arial Narrow",  path = "Fonts\\ARIALN.TTF" },
    { name = "2002",          path = "Fonts\\2002.TTF" },
    { name = "2002 Bold",     path = "Fonts\\2002B.TTF" },
    { name = "Express Way",   path = "Fonts\\EXPRESSWAY.TTF" },
}

-------------------------------------------------------------------------------
-- Color Presets (fast/medium/slow TTK thresholds)
-------------------------------------------------------------------------------
addon.COLOR_PRESETS = {
    { name = "Classic", fast = {1.0, 0.3, 0.3}, medium = {1.0, 0.8, 0.2}, slow = {0.3, 1.0, 0.3} },
    { name = "Warm",    fast = {1.0, 0.4, 0.2}, medium = {1.0, 0.6, 0.3}, slow = {0.9, 0.8, 0.4} },
    { name = "Cool",    fast = {0.4, 0.6, 1.0}, medium = {0.5, 0.8, 0.9}, slow = {0.3, 0.9, 0.7} },
    { name = "White",   fast = {1.0, 1.0, 1.0}, medium = {1.0, 1.0, 1.0}, slow = {1.0, 1.0, 1.0} },
    { name = "Gold",    fast = {1.0, 0.82, 0},  medium = {1.0, 0.82, 0},  slow = {1.0, 0.82, 0} },
    { name = "Purple",  fast = {0.8, 0.4, 1.0}, medium = {0.6, 0.5, 0.9}, slow = {0.5, 0.6, 0.8} },
}

-------------------------------------------------------------------------------
-- Trend Indicator Styles
-------------------------------------------------------------------------------
addon.TREND_STYLES = {
    { name = "Off",    up = "",    down = "",    stable = "" },
    { name = "Arrows", up = " ^",  down = " v",  stable = "" },
}

-------------------------------------------------------------------------------
-- Anchor Points
-------------------------------------------------------------------------------
addon.ANCHOR_POINTS = {
    { name = "Top Left",     value = "TOPLEFT" },
    { name = "Top",          value = "TOP" },
    { name = "Top Right",    value = "TOPRIGHT" },
    { name = "Left",         value = "LEFT" },
    { name = "Center",       value = "CENTER" },
    { name = "Right",        value = "RIGHT" },
    { name = "Bottom Left",  value = "BOTTOMLEFT" },
    { name = "Bottom",       value = "BOTTOM" },
    { name = "Bottom Right", value = "BOTTOMRIGHT" },
}

-------------------------------------------------------------------------------
-- Limits
-------------------------------------------------------------------------------
addon.MAX_DAMAGE_BUCKETS = 200
addon.TTK_FAST = 5
addon.TTK_MEDIUM = 15

-------------------------------------------------------------------------------
-- Default Configuration
-------------------------------------------------------------------------------
addon.DEFAULT_CONFIG = {
    configVersion = 1,
    enabled = true,
    updateInterval = 0.1,
    showUI = true,
    lockFrame = false,
    framePosition = nil,
    fontSize = 18,
    fontIndex = 1,
    colorPresetIndex = 1,
    trendStyleIndex = 2,
    showBackground = true,
    showBorder = true,
    bgOpacity = 0.75,
    frameScale = 1.0,
    historyEnabled = true,
    historyTimeWindow = 300,
    minimap = {
        hide = false,
        minimapPos = 220,
        lock = false,
    },
    attachToTarget = false,
    anchorPoint = 5,
    anchorToPoint = 8,
    targetOffsetX = 0,
    targetOffsetY = 0,
}

-------------------------------------------------------------------------------
-- Config Migration
-------------------------------------------------------------------------------
function addon:MigrateConfig(savedVars)
    local currentVersion = savedVars.configVersion or 0
    if currentVersion < self.CONFIG_VERSION then
        self:Debug("Migrating config from v%d to v%d", currentVersion, self.CONFIG_VERSION)
        -- Future migrations go here
        savedVars.configVersion = self.CONFIG_VERSION
    end
    return savedVars
end

-------------------------------------------------------------------------------
-- Config Validation
-- Ensures saved values are within valid ranges to prevent errors from
-- corrupted or hand-edited SavedVariables
-------------------------------------------------------------------------------
function addon:ValidateConfig(config)
    local function clamp(val, min, max, default)
        if type(val) ~= "number" then return default end
        return math.max(min, math.min(max, val))
    end
    
    local function clampIndex(val, maxIndex, default)
        if type(val) ~= "number" then return default end
        return math.max(1, math.min(maxIndex, math.floor(val)))
    end
    
    -- Validate numeric ranges
    config.fontSize = clamp(config.fontSize, 8, 48, self.DEFAULT_CONFIG.fontSize)
    config.frameScale = clamp(config.frameScale, 0.25, 4, self.DEFAULT_CONFIG.frameScale)
    config.bgOpacity = clamp(config.bgOpacity, 0, 1, self.DEFAULT_CONFIG.bgOpacity)
    config.updateInterval = clamp(config.updateInterval, 0.05, 1, self.DEFAULT_CONFIG.updateInterval)
    config.historyTimeWindow = clamp(config.historyTimeWindow, 60, 600, self.DEFAULT_CONFIG.historyTimeWindow)
    config.targetOffsetX = clamp(config.targetOffsetX, -500, 500, self.DEFAULT_CONFIG.targetOffsetX)
    config.targetOffsetY = clamp(config.targetOffsetY, -500, 500, self.DEFAULT_CONFIG.targetOffsetY)
    
    -- Validate index references (must be valid table indices)
    config.fontIndex = clampIndex(config.fontIndex, #self.FONTS, self.DEFAULT_CONFIG.fontIndex)
    config.colorPresetIndex = clampIndex(config.colorPresetIndex, #self.COLOR_PRESETS, self.DEFAULT_CONFIG.colorPresetIndex)
    config.trendStyleIndex = clampIndex(config.trendStyleIndex, #self.TREND_STYLES, self.DEFAULT_CONFIG.trendStyleIndex)
    config.anchorPoint = clampIndex(config.anchorPoint, #self.ANCHOR_POINTS, self.DEFAULT_CONFIG.anchorPoint)
    config.anchorToPoint = clampIndex(config.anchorToPoint, #self.ANCHOR_POINTS, self.DEFAULT_CONFIG.anchorToPoint)
    
    -- Validate booleans (coerce to boolean)
    local function toBool(val, default)
        if type(val) == "boolean" then return val end
        return default
    end
    
    config.enabled = toBool(config.enabled, self.DEFAULT_CONFIG.enabled)
    config.showUI = toBool(config.showUI, self.DEFAULT_CONFIG.showUI)
    config.lockFrame = toBool(config.lockFrame, self.DEFAULT_CONFIG.lockFrame)
    config.showBackground = toBool(config.showBackground, self.DEFAULT_CONFIG.showBackground)
    config.showBorder = toBool(config.showBorder, self.DEFAULT_CONFIG.showBorder)
    config.historyEnabled = toBool(config.historyEnabled, self.DEFAULT_CONFIG.historyEnabled)
    config.attachToTarget = toBool(config.attachToTarget, self.DEFAULT_CONFIG.attachToTarget)
    
    -- Validate minimap sub-table
    if config.minimap then
        config.minimap.hide = toBool(config.minimap.hide, self.DEFAULT_CONFIG.minimap.hide)
        config.minimap.lock = toBool(config.minimap.lock, self.DEFAULT_CONFIG.minimap.lock)
        config.minimap.minimapPos = clamp(config.minimap.minimapPos, 0, 360, self.DEFAULT_CONFIG.minimap.minimapPos)
    end
    
    -- Validate framePosition if present
    if config.framePosition then
        if type(config.framePosition) ~= "table" then
            config.framePosition = nil
        end
    end
    
    self:Debug("Config validated")
    return config
end

-------------------------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------------------------

function addon:GetBackdropInfo()
    local cfg = self.config
    
    -- Return fresh table each time - WoW's SetBackdrop compares table identity
    -- and won't update if the same table reference is passed with changed values
    return {
        bgFile = cfg.showBackground and self.Media.backdrop or nil,
        edgeFile = cfg.showBorder and self.Media.border or nil,
        tile = true,
        tileSize = 16,
        edgeSize = cfg.showBorder and 16 or 0,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    }
end
