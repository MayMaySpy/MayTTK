-------------------------------------------------------------------------------
-- MayTTK: French Localization (frFR)
-------------------------------------------------------------------------------
local addonName, addon = ...
if GetLocale() ~= "frFR" then return end

local L = addon.L

-- System Messages
L["ADDON_LOADED"] = "|cff00ff00MayTTK|r v%s chargé! |cffffff00/ttk|r pour les paramètres"
L["ADDON_STATUS"] = "|cff00ff00MayTTK:|r %s"
L["ENABLED"] = "Activé"
L["DISABLED"] = "Désactivé"
L["FRAME_LOCKED"] = "|cff00ff00MayTTK:|r Fenêtre verrouillée"
L["FRAME_UNLOCKED"] = "|cff00ff00MayTTK:|r Fenêtre déverrouillée"
L["FRAME_SHOWN"] = "|cff00ff00MayTTK:|r Affichage visible"
L["FRAME_HIDDEN"] = "|cff00ff00MayTTK:|r Affichage masqué"
L["FRAME_RESET"] = "|cff00ff00MayTTK:|r Position réinitialisée"
L["MINIMAP_STATUS"] = "|cff00ff00MayTTK:|r Bouton minicarte %s"
L["PREVIEW_ON"] = "|cff00ff00MayTTK:|r Aperçu ACTIVÉ - Glissez pour positionner"
L["PREVIEW_OFF"] = "|cff00ff00MayTTK:|r Aperçu DÉSACTIVÉ"
L["DATA_CLEARED"] = "|cff00ff00MayTTK:|r Données effacées"

-- Slash Commands
L["CMD_HELP"] = "|cff00ff00MayTTK:|r Commandes: toggle | show | hide | lock | reset | minimap | preview | (vide = paramètres)"
L["CMD_DEBUG_ON"] = "|cff00ff00MayTTK:|r Mode debug ACTIVÉ"
L["CMD_DEBUG_OFF"] = "|cff00ff00MayTTK:|r Mode debug DÉSACTIVÉ"

-- Settings Headers
L["SETTINGS_TITLE"] = "|cff00ff00MayTTK|r Paramètres"
L["HEADER_GENERAL"] = "Général"
L["HEADER_APPEARANCE"] = "Apparence"
L["HEADER_FRAME_STYLE"] = "Style de fenêtre"
L["HEADER_POSITIONING"] = "Positionnement"

-- Settings Options
L["OPT_ENABLED"] = "Activer l'addon"
L["OPT_SHOW_UI"] = "Afficher le TTK"
L["OPT_LOCK_FRAME"] = "Verrouiller la position"
L["OPT_HISTORY"] = "Afficher les flèches de tendance"
L["OPT_HISTORY_DESC"] = "indicateurs de tendance"
L["OPT_MINIMAP"] = "Afficher le bouton minicarte"
L["OPT_FONT"] = "Police"
L["OPT_FONT_SIZE"] = "Taille de police"
L["OPT_COLORS"] = "Couleurs"
L["OPT_TREND_STYLE"] = "Style de tendance"
L["OPT_SCALE"] = "Échelle"
L["OPT_SHOW_BG"] = "Afficher le fond"
L["OPT_SHOW_BORDER"] = "Afficher la bordure"
L["OPT_BG_OPACITY"] = "Opacité du fond"
L["OPT_ATTACH_TARGET"] = "Attacher à la cible (détecte ElvUI/SUF)"
L["OPT_ANCHOR_POINT"] = "Point d'ancrage"
L["OPT_ANCHOR_TO"] = "Attacher à"
L["OPT_OFFSET_X"] = "Décalage X"
L["OPT_OFFSET_Y"] = "Décalage Y"

-- Buttons
L["BTN_PREVIEW"] = "Aperçu"
L["BTN_RESET_POS"] = "Réinit. pos."
L["BTN_CLEAR_DATA"] = "Effacer données"

-- Minimap / Addon Compartment
L["COMPARTMENT_TOOLTIP"] = "Calculateur de temps avant la mort"
L["COMPARTMENT_LEFT_CLICK"] = "Clic gauche"
L["COMPARTMENT_RIGHT_CLICK"] = "Clic droit"
L["COMPARTMENT_SETTINGS"] = "Ouvrir les paramètres"
L["COMPARTMENT_TOGGLE"] = "Activer/Désactiver"
L["MINIMAP_DRAG"] = "Glissez pour repositionner"

