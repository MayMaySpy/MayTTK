-------------------------------------------------------------------------------
-- MayTTK: Display & UI
-- TTK frame creation, styling, and positioning
-------------------------------------------------------------------------------
local addonName, addon = ...

local CreateFrame, UIParent, unpack = CreateFrame, UIParent, unpack
local math_max, math_floor, string_format = math.max, math.floor, string.format

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local FRAME_DETECTION_MAX_RETRIES = 5
local FRAME_DETECTION_RETRY_DELAY = 1.0  -- Doubles each retry (exponential backoff)

-- State
addon.ttkFrame = nil
addon.isPreviewMode = false
addon.detectedTargetFrame = nil
addon._frameDetectionRetries = 0

-------------------------------------------------------------------------------
-- Target Frame Detection (ElvUI, SUF, Default)
-- Attempts to detect custom unit frame addons with retry logic for late-loading UIs
-------------------------------------------------------------------------------
function addon:GetTargetFrame(forceRedetect)
    if self.detectedTargetFrame and not forceRedetect then
        return self.detectedTargetFrame
    end
    
    -- Check ElvUI
    if ElvUF_Target and ElvUF_Target:IsObjectType("Frame") then
        self.detectedTargetFrame = ElvUF_Target
        self:Debug("Detected ElvUI target frame")
        return ElvUF_Target
    end
    
    -- Check Shadowed Unit Frames
    if SUFUnittarget and SUFUnittarget:IsObjectType("Frame") then
        self.detectedTargetFrame = SUFUnittarget
        self:Debug("Detected SUF target frame")
        return SUFUnittarget
    end
    
    -- Fallback to default Blizzard frame
    return TargetFrame
end

function addon:DelayedFrameDetection()
    if not self.config.attachToTarget then return end
    
    local frame = self:GetTargetFrame(true)
    
    if frame ~= TargetFrame then
        -- Found a custom frame, attach to it
        self:Debug("Attached to detected frame: %s", frame:GetName() or "unknown")
        self:LoadFramePosition()
        self._frameDetectionRetries = 0
        return
    end
    
    -- Custom frame not found, retry with exponential backoff
    self._frameDetectionRetries = self._frameDetectionRetries + 1
    
    if self._frameDetectionRetries < FRAME_DETECTION_MAX_RETRIES then
        local delay = FRAME_DETECTION_RETRY_DELAY * (2 ^ (self._frameDetectionRetries - 1))
        self:Debug("Custom frame not found, retry %d/%d in %.1fs", 
            self._frameDetectionRetries, FRAME_DETECTION_MAX_RETRIES, delay)
        C_Timer.After(delay, function()
            self:DelayedFrameDetection()
        end)
    else
        self:Debug("No custom frame detected after %d attempts, using default TargetFrame", 
            FRAME_DETECTION_MAX_RETRIES)
        self._frameDetectionRetries = 0
    end
end

-------------------------------------------------------------------------------
-- Color & Formatting
-------------------------------------------------------------------------------
function addon:GetTTKColor(ttk)
    local preset = self.COLOR_PRESETS[self.config.colorPresetIndex] or self.COLOR_PRESETS[1]
    local tier = ttk <= self.TTK_FAST and "fast" or ttk <= self.TTK_MEDIUM and "medium" or "slow"
    return unpack(preset[tier])
end

function addon:GetTrendText(trend)
    local style = self.TREND_STYLES[self.config.trendStyleIndex] or self.TREND_STYLES[1]
    return style[trend == "increasing" and "up" or trend == "decreasing" and "down" or "stable"]
end

function addon:FormatTTK(ttk)
    local L = self.L
    if ttk < 10 then
        return string_format(L["TTK_SECONDS"], ttk)
    elseif ttk < 60 then
        return string_format(L["TTK_SECONDS_LONG"], math_floor(ttk))
    else
        return string_format(L["TTK_MINUTES"], math_floor(ttk / 60), math_floor(ttk % 60))
    end
end

-------------------------------------------------------------------------------
-- Frame Creation
-------------------------------------------------------------------------------
function addon:CreateDisplayFrame()
    if self.ttkFrame then return end
    
    local frame = CreateFrame("Frame", "MayTTKFrame", UIParent, self.Compat.GetBackdropTemplate())
    frame:SetSize(80, 28)
    frame:SetPoint("CENTER", 0, -200)
    frame:SetFrameStrata("HIGH")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    
    frame:SetScript("OnDragStart", function(f)
        if not self.config.lockFrame and not self.config.attachToTarget and not InCombatLockdown() then
            f:StartMoving()
        end
    end)
    
    frame:SetScript("OnDragStop", function(f)
        f:StopMovingOrSizing()
        self:SaveFramePosition()
    end)
    
    local text = frame:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER")
    local fontInfo = self.FONTS[self.config.fontIndex] or self.FONTS[1]
    text:SetFont(fontInfo.path, self.config.fontSize, "OUTLINE")
    text:SetText("--")
    frame.Text = text
    
    self.ttkFrame = frame
    self:ApplyFrameStyle()
    self:LoadFramePosition()
    frame:Hide()
    self:Debug("Display frame created")
end

-------------------------------------------------------------------------------
-- Styling
-------------------------------------------------------------------------------
function addon:ApplyFrameStyle()
    local frame = self.ttkFrame
    if not frame then return end
    
    if frame.SetBackdrop then
        frame:SetBackdrop(self:GetBackdropInfo())
        
        -- Set alpha to 0 when disabled for explicit hiding
        local bgAlpha = self.config.showBackground and self.config.bgOpacity or 0
        local borderAlpha = self.config.showBorder and 0.9 or 0
        
        frame:SetBackdropColor(0, 0, 0, bgAlpha)
        frame:SetBackdropBorderColor(0.4, 0.4, 0.4, borderAlpha)
    end
    
    local fontInfo = self.FONTS[self.config.fontIndex] or self.FONTS[1]
    frame.Text:SetFont(fontInfo.path, self.config.fontSize, "OUTLINE")
    frame:SetScale(self.config.frameScale)
end

-------------------------------------------------------------------------------
-- Position Management
-------------------------------------------------------------------------------
function addon:SaveFramePosition()
    if not self.ttkFrame or self.config.attachToTarget then return end
    local point, _, relativePoint, x, y = self.ttkFrame:GetPoint()
    self.config.framePosition = { point = point, relativePoint = relativePoint, x = x, y = y }
    self:Debug("Frame position saved")
end

function addon:LoadFramePosition()
    local frame = self.ttkFrame
    if not frame then return end
    
    frame:ClearAllPoints()
    
    if self.config.attachToTarget then
        local targetFrame = self:GetTargetFrame()
        if targetFrame then
            local myPoint = self.ANCHOR_POINTS[self.config.anchorPoint] or self.ANCHOR_POINTS[5]
            local toPoint = self.ANCHOR_POINTS[self.config.anchorToPoint] or self.ANCHOR_POINTS[8]
            frame:SetPoint(myPoint.value, targetFrame, toPoint.value, self.config.targetOffsetX, self.config.targetOffsetY)
            frame:SetMovable(false)
            frame:EnableMouse(not self.config.lockFrame)
            self:Debug("Frame attached to %s", targetFrame:GetName() or "TargetFrame")
        end
    else
        frame:SetMovable(true)
        frame:EnableMouse(true)
        local pos = self.config.framePosition
        if pos then
            frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
        else
            frame:SetPoint("CENTER", 0, -200)
        end
    end
end

function addon:ResetFramePosition()
    if not self.ttkFrame then return end
    self.ttkFrame:ClearAllPoints()
    if self.config.attachToTarget then
        self.config.anchorPoint = 5
        self.config.anchorToPoint = 8
        self.config.targetOffsetX = 0
        self.config.targetOffsetY = 0
        self:LoadFramePosition()
    else
        self.ttkFrame:SetPoint("CENTER", 0, -200)
        self.config.framePosition = nil
    end
    self:Debug("Frame position reset")
end

function addon:UpdateTargetAnchor()
    if self.ttkFrame then
        self:LoadFramePosition()
    end
end

-------------------------------------------------------------------------------
-- Display Updates
-------------------------------------------------------------------------------
function addon:SetFrameContent(ttk, trend)
    local frame = self.ttkFrame
    local text = self:FormatTTK(ttk) .. self:GetTrendText(trend)
    frame.Text:SetText(text)
    frame.Text:SetTextColor(self:GetTTKColor(ttk))
    
    local textWidth = frame.Text:GetStringWidth() + 20
    local minWidth = 70
    
    self.frameMaxWidth = self.frameMaxWidth or minWidth
    local targetWidth = math_max(textWidth, self.frameMaxWidth, minWidth)
    
    if textWidth > self.frameMaxWidth then
        self.frameMaxWidth = textWidth
    end
    
    frame:SetWidth(targetWidth)
    frame:Show()
end

function addon:UpdateDisplay()
    if not self.config.showUI or not self.ttkFrame or self.isPreviewMode then return end
    
    local ttk = self:CalculateTTK()
    if ttk then
        self:AddTTKToHistory(ttk)
        self:SetFrameContent(ttk, self:GetTTKTrend())
    else
        self.ttkFrame:Hide()
    end
end

function addon:RefreshDisplay()
    if not self.ttkFrame then return end
    self:ApplyFrameStyle()
    if self.isPreviewMode then
        self:SetFrameContent(4.2, "decreasing")
    elseif self.ttkFrame:IsShown() then
        local ttk = self:CalculateTTK()
        if ttk then
            self:SetFrameContent(ttk, self:GetTTKTrend())
        end
    end
end

-------------------------------------------------------------------------------
-- Preview Mode
-------------------------------------------------------------------------------
function addon:TogglePreview()
    local L = self.L
    self.isPreviewMode = not self.isPreviewMode
    
    if self.isPreviewMode then
        if not self.ttkFrame then self:CreateDisplayFrame() end
        self:SetFrameContent(4.2, "decreasing")
        print(L["PREVIEW_ON"])
    else
        if self.ttkFrame and not self:CalculateTTK() then
            self.ttkFrame:Hide()
        end
        print(L["PREVIEW_OFF"])
    end
end
