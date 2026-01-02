-------------------------------------------------------------------------------
-- MayTTK: Simplified Chinese Localization (zhCN)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "zhCN" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s 已加载! |cffffff00/ttk|r 打开设置"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "已启用"
L["DISABLED"] = "已禁用"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r 框体已锁定"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r 框体已解锁"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r 显示已开启"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r 显示已隐藏"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r 位置已重置"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r 小地图按钮 %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r 预览已开启 - 拖动以定位"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r 预览已关闭"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r 数据已清除"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r 命令: toggle | show | hide | lock | reset | minimap | preview | (空 = 设置)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r 调试模式已开启"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r 调试模式已关闭"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r 设置"
L["HEADER_GENERAL"] = "常规"
L["HEADER_APPEARANCE"] = "外观"
L["HEADER_FRAME_STYLE"] = "框体样式"
L["HEADER_POSITIONING"] = "定位"

-- Settings Options
L["OPT_ENABLED"] = "启用插件"
L["OPT_SHOW_UI"] = "显示TTK"
L["OPT_LOCK_FRAME"] = "锁定位置"
L["OPT_HISTORY"] = "显示趋势箭头"
L["OPT_HISTORY_DESC"] = "趋势指示器"
L["OPT_MINIMAP"] = "显示小地图按钮"
L["OPT_FONT"] = "字体"
L["OPT_FONT_SIZE"] = "字体大小"
L["OPT_COLORS"] = "颜色"
L["OPT_TREND_STYLE"] = "趋势样式"
L["OPT_SCALE"] = "缩放"
L["OPT_SHOW_BG"] = "显示背景"
L["OPT_SHOW_BORDER"] = "显示边框"
L["OPT_BG_OPACITY"] = "背景透明度"
L["OPT_ATTACH_TARGET"] = "附着到目标框体 (自动检测ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "锚点"
L["OPT_ANCHOR_TO"] = "附着到"
L["OPT_OFFSET_X"] = "X偏移"
L["OPT_OFFSET_Y"] = "Y偏移"

-- Buttons
L["BTN_PREVIEW"] = "预览"
L["BTN_RESET_POS"] = "重置位置"
L["BTN_CLEAR_DATA"] = "清除数据"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "击杀时间计算器"
L["COMPARTMENT_LEFT_CLICK"] = "左键点击"
L["COMPARTMENT_RIGHT_CLICK"] = "右键点击"
L["COMPARTMENT_SETTINGS"] = "打开设置"
L["COMPARTMENT_TOGGLE"] = "切换插件"
L["MINIMAP_DRAG"] = "拖动以重新定位"

