-------------------------------------------------------------------------------
-- MayTTK: Compatibility Layer
-- Handles API differences between all WoW editions
-- Must load first (see .toc)
-------------------------------------------------------------------------------
local addonName, addon = ...

local Compat = {}

-------------------------------------------------------------------------------
-- WoW Project IDs
-- These match Blizzard's WOW_PROJECT_* constants
-------------------------------------------------------------------------------
local PROJECT_MAINLINE = WOW_PROJECT_MAINLINE or 1           -- Retail
local PROJECT_CLASSIC = WOW_PROJECT_CLASSIC or 2             -- Classic Era (Vanilla)
local PROJECT_TBC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5 -- TBC Classic
local PROJECT_WRATH = WOW_PROJECT_WRATH_CLASSIC or 11        -- Wrath Classic
local PROJECT_CATA = WOW_PROJECT_CATACLYSM_CLASSIC or 14     -- Cata Classic
local PROJECT_MISTS = 18                                      -- MoP Remix/Classic (unofficial)
local CURRENT_PROJECT = WOW_PROJECT_ID or PROJECT_MAINLINE

-------------------------------------------------------------------------------
-- Version Detection Functions
-------------------------------------------------------------------------------
Compat.IsRetail = function() return CURRENT_PROJECT == PROJECT_MAINLINE end
Compat.IsClassicEra = function() return CURRENT_PROJECT == PROJECT_CLASSIC end
Compat.IsTBC = function() return CURRENT_PROJECT == PROJECT_TBC end
Compat.IsWrath = function() return CURRENT_PROJECT == PROJECT_WRATH end
Compat.IsCata = function() return CURRENT_PROJECT == PROJECT_CATA end
Compat.IsMists = function() return CURRENT_PROJECT == PROJECT_MISTS end

-- Legacy alias for backward compatibility
Compat.IsClassic = Compat.IsClassicEra

-- Returns true for any non-Retail edition
Compat.IsAnyClassic = function() return not Compat.IsRetail() end

function Compat.GetVersionInfo()
    local version, build, date, tocversion = GetBuildInfo()
    return {
        version = version,
        build = build,
        date = date,
        tocversion = tocversion,
        projectID = CURRENT_PROJECT,
        -- Edition flags
        isRetail = Compat.IsRetail(),
        isClassicEra = Compat.IsClassicEra(),
        isTBC = Compat.IsTBC(),
        isWrath = Compat.IsWrath(),
        isCata = Compat.IsCata(),
        isMists = Compat.IsMists(),
        isAnyClassic = Compat.IsAnyClassic(),
    }
end

-- Get a human-readable edition name
function Compat.GetEditionName()
    if Compat.IsRetail() then return "Retail" end
    if Compat.IsClassicEra() then return "Classic Era" end
    if Compat.IsTBC() then return "TBC Classic" end
    if Compat.IsWrath() then return "Wrath Classic" end
    if Compat.IsCata() then return "Cata Classic" end
    if Compat.IsMists() then return "MoP Classic" end
    return "Unknown"
end

-- API feature flags
Compat.hasBackdropTemplate = (BackdropTemplateMixin ~= nil)
Compat.hasSettingsAPI = (Settings and Settings.RegisterCanvasLayoutCategory ~= nil)

-- UnitCanAttack compatibility wrapper
function Compat.UnitCanAttack(unit1, unit2)
    if UnitCanAttack then
        return UnitCanAttack(unit1, unit2)
    end
    if not UnitExists(unit1) or not UnitExists(unit2) or UnitIsUnit(unit1, unit2) then
        return false
    end
    local reaction = UnitReaction(unit1, unit2)
    return reaction and reaction <= 4
end

-- Frame template compatibility
function Compat.GetBackdropTemplate()
    return Compat.hasBackdropTemplate and "BackdropTemplate" or nil
end

-- C_Timer polyfill for legacy clients
if not C_Timer then
    C_Timer = {
        After = function(delay, callback)
            local frame = CreateFrame("Frame")
            local elapsed = 0
            frame:SetScript("OnUpdate", function(self, delta)
                elapsed = elapsed + delta
                if elapsed >= delay then
                    self:SetScript("OnUpdate", nil)
                    callback()
                end
            end)
        end
    }
end

addon.Compat = Compat
