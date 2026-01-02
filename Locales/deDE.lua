-------------------------------------------------------------------------------
-- MayTTK: German Localization (deDE)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "deDE" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s geladen! |cffffff00/ttk|r für Einstellungen"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "Aktiviert"
L["DISABLED"] = "Deaktiviert"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r Fenster gesperrt"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r Fenster entsperrt"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r Anzeige eingeblendet"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r Anzeige ausgeblendet"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r Fensterposition zurückgesetzt"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r Minimap-Button %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r Vorschau AN - Ziehen zum Positionieren"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r Vorschau AUS"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r Daten gelöscht"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r Befehle: toggle | show | hide | lock | reset | minimap | preview | (leer = Einstellungen)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r Debug-Modus AN"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r Debug-Modus AUS"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r Einstellungen"
L["HEADER_GENERAL"] = "Allgemein"
L["HEADER_APPEARANCE"] = "Aussehen"
L["HEADER_FRAME_STYLE"] = "Fensterstil"
L["HEADER_POSITIONING"] = "Positionierung"

-- Settings Options
L["OPT_ENABLED"] = "Addon aktivieren"
L["OPT_SHOW_UI"] = "TTK-Anzeige zeigen"
L["OPT_LOCK_FRAME"] = "Fensterposition sperren"
L["OPT_HISTORY"] = "Trendpfeile anzeigen"
L["OPT_HISTORY_DESC"] = "Trendindikatoren"
L["OPT_MINIMAP"] = "Minimap-Button anzeigen"
L["OPT_FONT"] = "Schriftart"
L["OPT_FONT_SIZE"] = "Schriftgröße"
L["OPT_COLORS"] = "Farben"
L["OPT_TREND_STYLE"] = "Trendstil"
L["OPT_SCALE"] = "Skalierung"
L["OPT_SHOW_BG"] = "Hintergrund anzeigen"
L["OPT_SHOW_BORDER"] = "Rahmen anzeigen"
L["OPT_BG_OPACITY"] = "Hintergrund-Transparenz"
L["OPT_ATTACH_TARGET"] = "An Zielfenster anheften (erkennt ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "Fenster-Anker"
L["OPT_ANCHOR_TO"] = "Anheften an"
L["OPT_OFFSET_X"] = "X-Versatz"
L["OPT_OFFSET_Y"] = "Y-Versatz"

-- Buttons
L["BTN_PREVIEW"] = "Vorschau"
L["BTN_RESET_POS"] = "Pos. zurücksetzen"
L["BTN_CLEAR_DATA"] = "Daten löschen"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "Zeit bis zum Tod Rechner"
L["COMPARTMENT_LEFT_CLICK"] = "Linksklick"
L["COMPARTMENT_RIGHT_CLICK"] = "Rechtsklick"
L["COMPARTMENT_SETTINGS"] = "Einstellungen öffnen"
L["COMPARTMENT_TOGGLE"] = "Addon umschalten"
L["MINIMAP_DRAG"] = "Ziehen zum Verschieben"

