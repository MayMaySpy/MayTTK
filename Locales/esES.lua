-------------------------------------------------------------------------------
-- MayTTK: Spanish Localization (esES/esMX)
-------------------------------------------------------------------------------
local addonName, addon = ...
local locale = GetLocale()
if locale ~= "esES" and locale ~= "esMX" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s cargado! |cffffff00/ttk|r para configuración"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "Activado"
L["DISABLED"] = "Desactivado"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r Marco bloqueado"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r Marco desbloqueado"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r Pantalla visible"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r Pantalla oculta"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r Posición restablecida"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r Botón del minimapa %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r Vista previa ACTIVADA - Arrastra para posicionar"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r Vista previa DESACTIVADA"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r Datos borrados"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r Comandos: toggle | show | hide | lock | reset | minimap | preview | (vacío = configuración)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r Modo debug ACTIVADO"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r Modo debug DESACTIVADO"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r Configuración"
L["HEADER_GENERAL"] = "General"
L["HEADER_APPEARANCE"] = "Apariencia"
L["HEADER_FRAME_STYLE"] = "Estilo del marco"
L["HEADER_POSITIONING"] = "Posicionamiento"

-- Settings Options
L["OPT_ENABLED"] = "Activar addon"
L["OPT_SHOW_UI"] = "Mostrar TTK"
L["OPT_LOCK_FRAME"] = "Bloquear posición"
L["OPT_HISTORY"] = "Mostrar flechas de tendencia"
L["OPT_HISTORY_DESC"] = "indicadores de tendencia"
L["OPT_MINIMAP"] = "Mostrar botón del minimapa"
L["OPT_FONT"] = "Fuente"
L["OPT_FONT_SIZE"] = "Tamaño de fuente"
L["OPT_COLORS"] = "Colores"
L["OPT_TREND_STYLE"] = "Estilo de tendencia"
L["OPT_SCALE"] = "Escala"
L["OPT_SHOW_BG"] = "Mostrar fondo"
L["OPT_SHOW_BORDER"] = "Mostrar borde"
L["OPT_BG_OPACITY"] = "Opacidad del fondo"
L["OPT_ATTACH_TARGET"] = "Adjuntar al objetivo (detecta ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "Punto de anclaje"
L["OPT_ANCHOR_TO"] = "Adjuntar a"
L["OPT_OFFSET_X"] = "Desplazamiento X"
L["OPT_OFFSET_Y"] = "Desplazamiento Y"

-- Buttons
L["BTN_PREVIEW"] = "Vista previa"
L["BTN_RESET_POS"] = "Restablecer pos."
L["BTN_CLEAR_DATA"] = "Borrar datos"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "Calculadora de tiempo hasta la muerte"
L["COMPARTMENT_LEFT_CLICK"] = "Clic izquierdo"
L["COMPARTMENT_RIGHT_CLICK"] = "Clic derecho"
L["COMPARTMENT_SETTINGS"] = "Abrir configuración"
L["COMPARTMENT_TOGGLE"] = "Alternar addon"
L["MINIMAP_DRAG"] = "Arrastra para reposicionar"

