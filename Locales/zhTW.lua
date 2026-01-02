-------------------------------------------------------------------------------
-- MayTTK: Traditional Chinese Localization (zhTW)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "zhTW" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s 已載入! |cffffff00/ttk|r 開啟設定"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "已啟用"
L["DISABLED"] = "已停用"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r 框架已鎖定"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r 框架已解鎖"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r 顯示已開啟"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r 顯示已隱藏"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r 位置已重置"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r 小地圖按鈕 %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r 預覽已開啟 - 拖曳以定位"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r 預覽已關閉"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r 資料已清除"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r 指令: toggle | show | hide | lock | reset | minimap | preview | (空白 = 設定)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r 除錯模式已開啟"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r 除錯模式已關閉"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r 設定"
L["HEADER_GENERAL"] = "一般"
L["HEADER_APPEARANCE"] = "外觀"
L["HEADER_FRAME_STYLE"] = "框架樣式"
L["HEADER_POSITIONING"] = "定位"

-- Settings Options
L["OPT_ENABLED"] = "啟用插件"
L["OPT_SHOW_UI"] = "顯示TTK"
L["OPT_LOCK_FRAME"] = "鎖定位置"
L["OPT_HISTORY"] = "顯示趨勢箭頭"
L["OPT_HISTORY_DESC"] = "趨勢指示器"
L["OPT_MINIMAP"] = "顯示小地圖按鈕"
L["OPT_FONT"] = "字體"
L["OPT_FONT_SIZE"] = "字體大小"
L["OPT_COLORS"] = "顏色"
L["OPT_TREND_STYLE"] = "趨勢樣式"
L["OPT_SCALE"] = "縮放"
L["OPT_SHOW_BG"] = "顯示背景"
L["OPT_SHOW_BORDER"] = "顯示邊框"
L["OPT_BG_OPACITY"] = "背景透明度"
L["OPT_ATTACH_TARGET"] = "附著到目標框架 (自動偵測ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "錨點"
L["OPT_ANCHOR_TO"] = "附著到"
L["OPT_OFFSET_X"] = "X偏移"
L["OPT_OFFSET_Y"] = "Y偏移"

-- Buttons
L["BTN_PREVIEW"] = "預覽"
L["BTN_RESET_POS"] = "重置位置"
L["BTN_CLEAR_DATA"] = "清除資料"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "擊殺時間計算器"
L["COMPARTMENT_LEFT_CLICK"] = "左鍵點擊"
L["COMPARTMENT_RIGHT_CLICK"] = "右鍵點擊"
L["COMPARTMENT_SETTINGS"] = "開啟設定"
L["COMPARTMENT_TOGGLE"] = "切換插件"
L["MINIMAP_DRAG"] = "拖曳以重新定位"

