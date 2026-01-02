-------------------------------------------------------------------------------
-- MayTTK: Portuguese Localization (ptBR)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "ptBR" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s carregado! |cffffff00/ttk|r para configurações"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "Ativado"
L["DISABLED"] = "Desativado"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r Quadro bloqueado"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r Quadro desbloqueado"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r Display visível"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r Display oculto"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r Posição redefinida"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r Botão do minimapa %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r Pré-visualização LIGADA - Arraste para posicionar"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r Pré-visualização DESLIGADA"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r Dados limpos"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r Comandos: toggle | show | hide | lock | reset | minimap | preview | (vazio = configurações)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r Modo debug LIGADO"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r Modo debug DESLIGADO"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r Configurações"
L["HEADER_GENERAL"] = "Geral"
L["HEADER_APPEARANCE"] = "Aparência"
L["HEADER_FRAME_STYLE"] = "Estilo do quadro"
L["HEADER_POSITIONING"] = "Posicionamento"

-- Settings Options
L["OPT_ENABLED"] = "Ativar addon"
L["OPT_SHOW_UI"] = "Mostrar TTK"
L["OPT_LOCK_FRAME"] = "Bloquear posição"
L["OPT_HISTORY"] = "Mostrar setas de tendência"
L["OPT_HISTORY_DESC"] = "indicadores de tendência"
L["OPT_MINIMAP"] = "Mostrar botão do minimapa"
L["OPT_FONT"] = "Fonte"
L["OPT_FONT_SIZE"] = "Tamanho da fonte"
L["OPT_COLORS"] = "Cores"
L["OPT_TREND_STYLE"] = "Estilo de tendência"
L["OPT_SCALE"] = "Escala"
L["OPT_SHOW_BG"] = "Mostrar fundo"
L["OPT_SHOW_BORDER"] = "Mostrar borda"
L["OPT_BG_OPACITY"] = "Opacidade do fundo"
L["OPT_ATTACH_TARGET"] = "Anexar ao alvo (detecta ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "Ponto de âncora"
L["OPT_ANCHOR_TO"] = "Anexar a"
L["OPT_OFFSET_X"] = "Deslocamento X"
L["OPT_OFFSET_Y"] = "Deslocamento Y"

-- Buttons
L["BTN_PREVIEW"] = "Pré-visualizar"
L["BTN_RESET_POS"] = "Redefinir pos."
L["BTN_CLEAR_DATA"] = "Limpar dados"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "Calculadora de tempo até a morte"
L["COMPARTMENT_LEFT_CLICK"] = "Clique esquerdo"
L["COMPARTMENT_RIGHT_CLICK"] = "Clique direito"
L["COMPARTMENT_SETTINGS"] = "Abrir configurações"
L["COMPARTMENT_TOGGLE"] = "Alternar addon"
L["MINIMAP_DRAG"] = "Arraste para reposicionar"

