-------------------------------------------------------------------------------
-- MayTTK: English Localization (Default)
-- This is the base locale - all keys must be defined here
-------------------------------------------------------------------------------
local addonName, addon = ...

local L = setmetatable({}, {
    __index = function(t, key)
        return key -- Fallback: return the key itself
    end
})

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s loaded! |cffffff00/ttk|r for settings"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "Enabled"
L["DISABLED"] = "Disabled"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r Frame locked"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r Frame unlocked"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r Display shown"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r Display hidden"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r Frame position reset"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r Minimap button %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r Preview ON - Drag to position"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r Preview OFF"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r Data cleared"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r Commands: toggle | show | hide | lock | reset | minimap | preview | (blank = settings)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r Debug mode ON"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r Debug mode OFF"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r Settings"
L["HEADER_GENERAL"] = "General"
L["HEADER_APPEARANCE"] = "Appearance"
L["HEADER_FRAME_STYLE"] = "Frame Style"
L["HEADER_POSITIONING"] = "Positioning"

-- Settings Options
L["OPT_ENABLED"] = "Enable Addon"
L["OPT_SHOW_UI"] = "Show TTK Display"
L["OPT_LOCK_FRAME"] = "Lock Frame Position"
L["OPT_HISTORY"] = "Show Trend Arrows"
L["OPT_HISTORY_DESC"] = "trend indicators"
L["OPT_MINIMAP"] = "Show Minimap Button"
L["OPT_FONT"] = "Font"
L["OPT_FONT_SIZE"] = "Font Size"
L["OPT_COLORS"] = "Colors"
L["OPT_TREND_STYLE"] = "Trend Style"
L["OPT_SCALE"] = "Scale"
L["OPT_SHOW_BG"] = "Show Background"
L["OPT_SHOW_BORDER"] = "Show Border"
L["OPT_BG_OPACITY"] = "Background Opacity"
L["OPT_ATTACH_TARGET"] = "Attach to Target Frame (auto-detects ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "Frame Anchor"
L["OPT_ANCHOR_TO"] = "Attach To"
L["OPT_OFFSET_X"] = "X Offset"
L["OPT_OFFSET_Y"] = "Y Offset"

-- Buttons
L["BTN_PREVIEW"] = "Preview"
L["BTN_RESET_POS"] = "Reset Pos"
L["BTN_CLEAR_DATA"] = "Clear Data"

-- TTK Display Formats
L["TTK_SECONDS"] = "%.1fs"
L["TTK_SECONDS_LONG"] = "%ds"
L["TTK_MINUTES"] = "%dm%ds"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "Time To Kill calculator"
L["COMPARTMENT_LEFT_CLICK"] = "Left-Click"
L["COMPARTMENT_RIGHT_CLICK"] = "Right-Click"
L["COMPARTMENT_SETTINGS"] = "Open Settings"
L["COMPARTMENT_TOGGLE"] = "Toggle Addon"
L["MINIMAP_DRAG"] = "Drag to reposition"

addon.L = L

