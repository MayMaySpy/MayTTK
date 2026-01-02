-------------------------------------------------------------------------------
-- MayTTK: DPS & TTK Calculation Engine
-- Adaptive EWMA-based DPS calculation with variance-adjusted smoothing
-------------------------------------------------------------------------------
local addonName, addon = ...

-- Performance: localize globals
local GetTime, UnitHealth = GetTime, UnitHealth
local UnitExists, UnitIsDead = UnitExists, UnitIsDead
local math_min, math_max, math_floor, math_sqrt = math.min, math.max, math.floor, math.sqrt
local table_remove, wipe, pairs, ipairs, type = table.remove, wipe, pairs, ipairs, type

-------------------------------------------------------------------------------
-- Algorithm Constants
-------------------------------------------------------------------------------
-- DPS calculation windows (seconds)
local INSTANT_WINDOW = 2
local SHORT_WINDOW = 5
local LONG_WINDOW = 15

-- EWMA smoothing parameters
local EWMA_ALPHA_MIN = 0.2
local EWMA_ALPHA_MAX = 0.5
local VARIANCE_SENSITIVITY = 2.0
local DPS_DROP_FLOOR = 0.5           -- Minimum DPS as fraction of previous
local MIN_DPS_DIVISOR = 0.5          -- Minimum time divisor for DPS calc

-- Data retention
local HISTORY_CLEANUP_INTERVAL = 10
local BUCKET_RETENTION = 35
local DPS_HISTORY_SIZE = 8
local TTK_CAP = 600
local TTK_HISTORY_RING_SIZE = 100

-- Trend detection
local TREND_WINDOW_SECONDS = 5       -- How far back to look for trend
local TREND_MIN_SAMPLES = 3          -- Minimum samples needed for trend
local TREND_MAX_SAMPLES = 8          -- Maximum samples to consider
local TREND_THRESHOLD_MIN = 1.0      -- Minimum TTK change to register trend
local TREND_THRESHOLD_PCT = 0.1      -- TTK change as percentage of value

-------------------------------------------------------------------------------
-- Data Storage
-------------------------------------------------------------------------------
addon.damageBuckets = {}
addon.ttkHistory = {}
addon.ttkHistoryIndex = 0
addon.combatStartTime = {}
addon.smoothedDPS = {}
addon.dpsHistory = {}
addon.absorbedDamage = {}

-------------------------------------------------------------------------------
-- Data Management
-------------------------------------------------------------------------------
function addon:ClearAllData()
    wipe(self.damageBuckets)
    wipe(self.ttkHistory)
    self.ttkHistoryIndex = 0
    wipe(self.combatStartTime)
    wipe(self.smoothedDPS)
    wipe(self.dpsHistory)
    wipe(self.absorbedDamage)
    self.frameMaxWidth = nil
    self:Debug("All data cleared")
end

function addon:ClearDamageBuckets()
    wipe(self.damageBuckets)
    wipe(self.smoothedDPS)
    wipe(self.dpsHistory)
end

function addon:ClearTTKHistory()
    wipe(self.ttkHistory)
    self.ttkHistoryIndex = 0
end

-------------------------------------------------------------------------------
-- Damage Tracking
-------------------------------------------------------------------------------
function addon:RecordDamage(targetGUID, amount)
    if not amount or amount <= 0 then return end
    
    local now = GetTime()
    local bucketKey = math_floor(now)
    
    if not self.combatStartTime[targetGUID] then
        self.combatStartTime[targetGUID] = now
        self:Debug("New target, combat started")
    end
    
    self.damageBuckets[targetGUID] = self.damageBuckets[targetGUID] or {}
    local buckets = self.damageBuckets[targetGUID]
    buckets[bucketKey] = (buckets[bucketKey] or 0) + amount
    
    if not self.lastBucketCleanup or now - self.lastBucketCleanup > HISTORY_CLEANUP_INTERVAL then
        self:CleanupBuckets()
        self.lastBucketCleanup = now
    end
end

function addon:RecordAbsorb(targetGUID, amount)
    if not amount or amount <= 0 then return end
    
    local bucketKey = math_floor(GetTime())
    self.absorbedDamage[targetGUID] = self.absorbedDamage[targetGUID] or {}
    local buckets = self.absorbedDamage[targetGUID]
    buckets[bucketKey] = (buckets[bucketKey] or 0) + amount
end

function addon:GetRecentAbsorbs(targetGUID, window)
    local buckets = self.absorbedDamage[targetGUID]
    if not buckets then return 0 end
    
    local currentSec = math_floor(GetTime())
    local total = 0
    for sec = currentSec - window + 1, currentSec do
        total = total + (buckets[sec] or 0)
    end
    return total
end

function addon:CleanupBuckets()
    local now = math_floor(GetTime())
    local cutoff = now - BUCKET_RETENTION
    local maxBuckets = addon.MAX_DAMAGE_BUCKETS or 200
    
    -- Helper function to clean a bucket table with age and count limits
    local function cleanBucketTable(bucketTable)
        for targetGUID, buckets in pairs(bucketTable) do
            local count, oldestSec = 0, now
            
            -- Remove old entries and count remaining
            for second in pairs(buckets) do
                if second < cutoff then
                    buckets[second] = nil
                else
                    count = count + 1
                    if second < oldestSec then oldestSec = second end
                end
            end
            
            -- Enforce maximum bucket count by removing oldest entries
            if count > maxBuckets then
                for sec = oldestSec, oldestSec + (count - maxBuckets) do
                    buckets[sec] = nil
                end
            end
            
            -- Remove empty target entries
            if count == 0 then bucketTable[targetGUID] = nil end
        end
    end
    
    cleanBucketTable(self.damageBuckets)
    cleanBucketTable(self.absorbedDamage)
end

-------------------------------------------------------------------------------
-- DPS Calculation
-------------------------------------------------------------------------------
function addon:GetCombatDuration(targetGUID)
    targetGUID = targetGUID or self.currentTargetGUID
    local startTime = targetGUID and self.combatStartTime[targetGUID]
    return startTime and (GetTime() - startTime) or 0
end

function addon:GetAverageDPS(window, targetGUID, now, duration)
    local buckets = self.damageBuckets[targetGUID]
    if not buckets then return 0, 0 end
    
    local currentSec = math_floor(now)
    local total, hitBuckets = 0, 0
    for sec = currentSec - window + 1, currentSec do
        local damage = buckets[sec]
        if damage then
            total = total + damage
            hitBuckets = hitBuckets + 1
        end
    end
    if total == 0 then return 0, 0 end
    
    local divisor = duration < window and math_max(duration, MIN_DPS_DIVISOR) or window
    return total / divisor, hitBuckets
end

function addon:CalculateDPS()
    local now = GetTime()
    local targetGUID = self.currentTargetGUID or ""
    local duration = self:GetCombatDuration(targetGUID)
    
    if duration <= 0 then return 0 end
    
    local instantDPS, hitBuckets = self:GetAverageDPS(INSTANT_WINDOW, targetGUID, now, duration)
    
    -- Low-frequency damage: extend window for more stable readings
    local isLowFrequency = hitBuckets < 2
    if isLowFrequency then
        instantDPS = self:GetAverageDPS(SHORT_WINDOW, targetGUID, now, duration)
    end
    
    -- Short fights: skip smoothing
    if duration < 3 then
        self.smoothedDPS[targetGUID] = instantDPS
        return instantDPS
    end
    
    -- DPS floor: prevent wild drops from misses
    local prevDPS = self.smoothedDPS[targetGUID] or self:GetAverageDPS(SHORT_WINDOW, targetGUID, now, duration)
    if prevDPS > 0 and instantDPS < prevDPS * DPS_DROP_FLOOR then
        instantDPS = prevDPS * DPS_DROP_FLOOR
    end
    
    -- EWMA smoothing with adaptive alpha
    local alpha = isLowFrequency and EWMA_ALPHA_MIN or self:GetAdaptiveAlpha(targetGUID)
    local smoothed = (alpha * instantDPS) + ((1 - alpha) * prevDPS)
    
    -- Long fights: anchor to long-term average
    if duration > 10 then
        local longDPS = self:GetAverageDPS(LONG_WINDOW, targetGUID, now, duration)
        smoothed = (smoothed * 0.85) + (longDPS * 0.15)
    end
    
    self.smoothedDPS[targetGUID] = smoothed
    self:TrackDPSHistory(targetGUID, instantDPS)
    
    return smoothed
end

function addon:GetAdaptiveAlpha(targetGUID)
    local history = self.dpsHistory[targetGUID]
    if not history or #history < 3 then return EWMA_ALPHA_MIN end
    
    local sum, sumSq, count = 0, 0, #history
    for _, dpsValue in ipairs(history) do
        sum = sum + dpsValue
        sumSq = sumSq + dpsValue * dpsValue
    end
    
    local mean = sum / count
    if mean <= 0 then return EWMA_ALPHA_MIN end
    
    local variance = (sumSq / count) - (mean * mean)
    local cv = math_sqrt(math_max(0, variance)) / mean
    local blendFactor = math_min(cv * VARIANCE_SENSITIVITY, 1.0)
    
    return EWMA_ALPHA_MIN + blendFactor * (EWMA_ALPHA_MAX - EWMA_ALPHA_MIN)
end

function addon:TrackDPSHistory(targetGUID, dps)
    self.dpsHistory[targetGUID] = self.dpsHistory[targetGUID] or {}
    local history = self.dpsHistory[targetGUID]
    history[#history + 1] = dps
    while #history > DPS_HISTORY_SIZE do
        table_remove(history, 1)
    end
end

-------------------------------------------------------------------------------
-- TTK Calculation
-------------------------------------------------------------------------------
function addon:CalculateTTK()
    if not UnitExists("target") or UnitIsDead("target") then return nil end
    if not self.Compat.UnitCanAttack("player", "target") then return nil end
    
    local dps = self:CalculateDPS()
    local health = UnitHealth("target")
    if dps <= 0 or health <= 0 then return nil end
    
    local guid = self.currentTargetGUID
    local recentAbsorbs = guid and self:GetRecentAbsorbs(guid, 3) or 0
    
    return math_min((health + recentAbsorbs) / dps, TTK_CAP)
end

-------------------------------------------------------------------------------
-- TTK History (Ring Buffer)
-------------------------------------------------------------------------------
function addon:AddTTKToHistory(ttk)
    if not self.config.historyEnabled or not ttk then return end
    
    self.ttkHistoryIndex = (self.ttkHistoryIndex % TTK_HISTORY_RING_SIZE) + 1
    local idx = self.ttkHistoryIndex
    
    local entry = self.ttkHistory[idx]
    if entry then
        entry.time = GetTime()
        entry.ttk = ttk
        entry.targetGUID = self.currentTargetGUID or ""
    else
        self.ttkHistory[idx] = {
            time = GetTime(),
            ttk = ttk,
            targetGUID = self.currentTargetGUID or ""
        }
    end
end

function addon:CleanupTTKHistory()
    local cutoff = GetTime() - self.config.historyTimeWindow
    for i = 1, #self.ttkHistory do
        if self.ttkHistory[i] and self.ttkHistory[i].time < cutoff then
            self.ttkHistory[i].time = 0
        end
    end
end

function addon:GetTTKTrend()
    local history = self.ttkHistory
    local historyCount = #history
    if historyCount < TREND_MIN_SAMPLES then return "stable" end
    
    local now = GetTime()
    local targetGUID = self.currentTargetGUID or ""
    local cutoff = now - TREND_WINDOW_SECONDS
    local recentTTKs = {}
    
    local startIdx = self.ttkHistoryIndex
    for offset = 0, math_min(historyCount, TTK_HISTORY_RING_SIZE) - 1 do
        local idx = startIdx - offset
        if idx < 1 then idx = idx + TTK_HISTORY_RING_SIZE end
        
        local entry = history[idx]
        if entry and entry.time >= cutoff and entry.targetGUID == targetGUID then
            recentTTKs[#recentTTKs + 1] = entry.ttk
            if #recentTTKs >= TREND_MAX_SAMPLES then break end
        end
    end
    
    if #recentTTKs < TREND_MIN_SAMPLES then return "stable" end
    
    local oldestTTK, newestTTK = recentTTKs[#recentTTKs], recentTTKs[1]
    local threshold = math_max(TREND_THRESHOLD_MIN, oldestTTK * TREND_THRESHOLD_PCT)
    local diff = newestTTK - oldestTTK
    
    if diff > threshold then return "increasing"
    elseif diff < -threshold then return "decreasing" end
    return "stable"
end
