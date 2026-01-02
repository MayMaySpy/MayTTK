-------------------------------------------------------------------------------
-- MayTTK: Russian Localization (ruRU)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "ruRU" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s загружен! |cffffff00/ttk|r для настроек"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "Включено"
L["DISABLED"] = "Отключено"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r Рамка заблокирована"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r Рамка разблокирована"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r Дисплей показан"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r Дисплей скрыт"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r Позиция сброшена"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r Кнопка миникарты %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r Предпросмотр ВКЛ - Перетащите для позиционирования"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r Предпросмотр ВЫКЛ"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r Данные очищены"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r Команды: toggle | show | hide | lock | reset | minimap | preview | (пусто = настройки)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r Режим отладки ВКЛ"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r Режим отладки ВЫКЛ"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r Настройки"
L["HEADER_GENERAL"] = "Общие"
L["HEADER_APPEARANCE"] = "Внешний вид"
L["HEADER_FRAME_STYLE"] = "Стиль рамки"
L["HEADER_POSITIONING"] = "Позиционирование"

-- Settings Options
L["OPT_ENABLED"] = "Включить аддон"
L["OPT_SHOW_UI"] = "Показать TTK"
L["OPT_LOCK_FRAME"] = "Заблокировать позицию"
L["OPT_HISTORY"] = "Показать стрелки тренда"
L["OPT_HISTORY_DESC"] = "индикаторы тренда"
L["OPT_MINIMAP"] = "Показать кнопку миникарты"
L["OPT_FONT"] = "Шрифт"
L["OPT_FONT_SIZE"] = "Размер шрифта"
L["OPT_COLORS"] = "Цвета"
L["OPT_TREND_STYLE"] = "Стиль тренда"
L["OPT_SCALE"] = "Масштаб"
L["OPT_SHOW_BG"] = "Показать фон"
L["OPT_SHOW_BORDER"] = "Показать рамку"
L["OPT_BG_OPACITY"] = "Прозрачность фона"
L["OPT_ATTACH_TARGET"] = "Прикрепить к цели (определяет ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "Точка привязки"
L["OPT_ANCHOR_TO"] = "Прикрепить к"
L["OPT_OFFSET_X"] = "Смещение X"
L["OPT_OFFSET_Y"] = "Смещение Y"

-- Buttons
L["BTN_PREVIEW"] = "Предпросмотр"
L["BTN_RESET_POS"] = "Сброс поз."
L["BTN_CLEAR_DATA"] = "Очистить данные"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "Калькулятор времени до смерти"
L["COMPARTMENT_LEFT_CLICK"] = "ЛКМ"
L["COMPARTMENT_RIGHT_CLICK"] = "ПКМ"
L["COMPARTMENT_SETTINGS"] = "Открыть настройки"
L["COMPARTMENT_TOGGLE"] = "Переключить аддон"
L["MINIMAP_DRAG"] = "Перетащите для перемещения"

