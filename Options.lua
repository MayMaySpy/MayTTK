-------------------------------------------------------------------------------
-- MayTTK: Options Window
-- Native WoW-style settings panel
-- Note: UI callbacks use 'addon' explicitly since they're created by builder
-- functions that don't have access to 'self' from the outer method scope.
-------------------------------------------------------------------------------
local addonName, addon = ...

local CreateFrame, UIParent = CreateFrame, UIParent
local UIDropDownMenu_SetWidth, UIDropDownMenu_Initialize = UIDropDownMenu_SetWidth, UIDropDownMenu_Initialize
local UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton = UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton
local UIDropDownMenu_SetSelectedID, UIDropDownMenu_SetText = UIDropDownMenu_SetSelectedID, UIDropDownMenu_SetText
local math_abs, string_format, tinsert, tonumber = math.abs, string.format, tinsert, tonumber

addon.configWindow = nil

function addon:CreateConfigWindow()
    if self.configWindow then
        self.configWindow:Show()
        return
    end
    
    local L = self.L
    local dropdownCounter, sliderCounter, editboxCounter = 0, 0, 0
    
    ---------------------------------------------------------------------------
    -- Main Window
    ---------------------------------------------------------------------------
    local window = CreateFrame("Frame", "MayTTKConfigWindow", UIParent, self.Compat.GetBackdropTemplate())
    window:SetSize(380, 620)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetMovable(true)
    window:EnableMouse(true)
    window:SetClampedToScreen(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    
    window:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    window:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
    window:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
    
    ---------------------------------------------------------------------------
    -- Title Bar
    ---------------------------------------------------------------------------
    local icon = window:CreateTexture(nil, "ARTWORK")
    icon:SetSize(28, 28)
    icon:SetPoint("TOPLEFT", 12, -12)
    icon:SetTexture(self.Media.icon)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    local title = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    title:SetText("|cffffd200MayTTK|r")
    
    local version = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    version:SetPoint("LEFT", title, "RIGHT", 8, 0)
    version:SetText("v" .. self.VERSION)
    version:SetTextColor(0.6, 0.6, 0.6)
    
    local closeBtn = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() window:Hide() end)
    
    local titleDivider = window:CreateTexture(nil, "ARTWORK")
    titleDivider:SetHeight(1)
    titleDivider:SetPoint("TOPLEFT", 12, -48)
    titleDivider:SetPoint("TOPRIGHT", -12, -48)
    titleDivider:SetColorTexture(0.4, 0.4, 0.4, 0.5)
    
    ---------------------------------------------------------------------------
    -- Scroll Frame
    ---------------------------------------------------------------------------
    local scrollFrame = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -56)
    scrollFrame:SetPoint("BOTTOMRIGHT", -28, 48)
    
    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(330, 800)
    scrollFrame:SetScrollChild(content)
    
    local y = -4
    
    ---------------------------------------------------------------------------
    -- UI Builder Functions
    ---------------------------------------------------------------------------
    local function Header(text)
        y = y - 8
        local h = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetPoint("TOPLEFT", 4, y)
        h:SetText(text)
        h:SetTextColor(1, 0.82, 0)
        y = y - 20
    end
    
    local function Separator()
        y = y - 4
        local sep = content:CreateTexture(nil, "ARTWORK")
        sep:SetHeight(1)
        sep:SetPoint("TOPLEFT", 0, y)
        sep:SetPoint("TOPRIGHT", 0, y)
        sep:SetColorTexture(0.4, 0.4, 0.4, 0.3)
        y = y - 8
    end
    
    local function Checkbox(label, get, set, description)
        local cb = CreateFrame("CheckButton", nil, content, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 0, y)
        cb:SetChecked(get())
        cb:SetScript("OnClick", function(self) set(self:GetChecked()) end)
        
        local text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("LEFT", cb, "RIGHT", 0, 0)
        text:SetText(label)
        
        if description then
            local desc = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            desc:SetPoint("LEFT", text, "RIGHT", 8, 0)
            desc:SetText("(" .. description .. ")")
            desc:SetTextColor(0.5, 0.5, 0.5)
        end
        
        y = y - 26
        return cb
    end
    
    local function Slider(label, min, max, step, get, set, fmt)
        sliderCounter = sliderCounter + 1
        
        local lbl = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOPLEFT", 4, y)
        lbl:SetText(label)
        
        local val = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        val:SetPoint("TOPRIGHT", -4, y)
        val:SetText(string_format(fmt or "%.1f", get()))
        val:SetTextColor(1, 1, 1)
        
        y = y - 16
        
        local name = "MayTTKSlider" .. sliderCounter
        local s = CreateFrame("Slider", name, content, "OptionsSliderTemplate")
        s:SetPoint("TOPLEFT", 4, y)
        s:SetPoint("TOPRIGHT", -4, y)
        s:SetHeight(17)
        s:SetMinMaxValues(min, max)
        s:SetValueStep(step)
        s:SetObeyStepOnDrag(true)
        s:SetValue(get())
        
        _G[name.."Low"]:SetText(tostring(min))
        _G[name.."High"]:SetText(tostring(max))
        _G[name.."Text"]:SetText("")
        
        s:SetScript("OnValueChanged", function(_, v)
            set(v)
            val:SetText(string_format(fmt or "%.1f", v))
            addon:RefreshDisplay()
        end)
        
        y = y - 26
        return s
    end
    
    local function Dropdown(label, options, get, set)
        dropdownCounter = dropdownCounter + 1
        
        local lbl = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOPLEFT", 4, y)
        lbl:SetText(label)
        y = y - 16
        
        local dd = CreateFrame("Frame", "MayTTKDD" .. dropdownCounter, content, "UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT", -16, y)
        UIDropDownMenu_SetWidth(dd, 280)
        
        UIDropDownMenu_Initialize(dd, function(_, level)
            for i, opt in ipairs(options) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = opt.name or opt
                info.value = i
                info.checked = (get() == i)
                info.func = function()
                    set(i)
                    UIDropDownMenu_SetSelectedID(dd, i)
                    UIDropDownMenu_SetText(dd, opt.name or opt)
                    addon:RefreshDisplay()
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        
        local cur = options[get()]
        UIDropDownMenu_SetText(dd, cur and (cur.name or cur) or "")
        y = y - 28
        return dd
    end
    
    local function AnchorDropdown(label, options, get, set)
        dropdownCounter = dropdownCounter + 1
        
        local lbl = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOPLEFT", 4, y)
        lbl:SetText(label)
        y = y - 16
        
        local dd = CreateFrame("Frame", "MayTTKDD" .. dropdownCounter, content, "UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT", -16, y)
        UIDropDownMenu_SetWidth(dd, 280)
        
        UIDropDownMenu_Initialize(dd, function(_, level)
            for i, opt in ipairs(options) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = opt.name or opt
                info.value = i
                info.checked = (get() == i)
                info.func = function()
                    set(i)
                    UIDropDownMenu_SetSelectedID(dd, i)
                    UIDropDownMenu_SetText(dd, opt.name or opt)
                    if addon.config.attachToTarget then addon:UpdateTargetAnchor() end
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        
        local cur = options[get()]
        UIDropDownMenu_SetText(dd, cur and (cur.name or cur) or "")
        y = y - 28
        return dd
    end
    
    local function OffsetSlider(label, min, max, step, get, set)
        sliderCounter = sliderCounter + 1
        editboxCounter = editboxCounter + 1
        
        local row = CreateFrame("Frame", nil, content)
        row:SetHeight(20)
        row:SetPoint("TOPLEFT", 4, y)
        row:SetPoint("TOPRIGHT", -4, y)
        
        local lbl = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("LEFT", 0, 0)
        lbl:SetWidth(60)
        lbl:SetJustifyH("LEFT")
        lbl:SetText(label)
        
        local editName = "MayTTKEdit" .. editboxCounter
        local editBox = CreateFrame("EditBox", editName, row, "InputBoxTemplate")
        editBox:SetSize(50, 20)
        editBox:SetPoint("RIGHT", 0, 0)
        editBox:SetAutoFocus(false)
        editBox:SetText(tostring(get()))
        
        local name = "MayTTKSlider" .. sliderCounter
        local s = CreateFrame("Slider", name, row, "OptionsSliderTemplate")
        s:SetPoint("LEFT", lbl, "RIGHT", 8, 0)
        s:SetPoint("RIGHT", editBox, "LEFT", -8, 0)
        s:SetHeight(17)
        s:SetMinMaxValues(min, max)
        s:SetValueStep(step)
        s:SetObeyStepOnDrag(true)
        s:SetValue(get())
        
        _G[name.."Low"]:SetText("")
        _G[name.."High"]:SetText("")
        _G[name.."Text"]:SetText("")
        
        s:SetScript("OnValueChanged", function(_, v)
            local newVal = math.floor(v + 0.5)
            set(newVal)
            editBox:SetText(tostring(newVal))
            if addon.config.attachToTarget then addon:UpdateTargetAnchor() end
        end)
        
        editBox:SetScript("OnEnterPressed", function(self)
            local v = tonumber(self:GetText()) or 0
            v = math.max(min, math.min(max, v))
            set(v)
            s:SetValue(v)
            self:SetText(tostring(v))
            self:ClearFocus()
            if addon.config.attachToTarget then addon:UpdateTargetAnchor() end
        end)
        
        editBox:SetScript("OnEscapePressed", function(self)
            self:SetText(tostring(get()))
            self:ClearFocus()
        end)
        
        y = y - 28
        return s, editBox
    end
    
    ---------------------------------------------------------------------------
    -- Build Options UI
    ---------------------------------------------------------------------------
    Header(L["HEADER_GENERAL"])
    Checkbox(L["OPT_ENABLED"],
        function() return addon.config.enabled end,
        function(v) addon.config.enabled = v addon:UpdateMinimapIcon() end)
    Checkbox(L["OPT_SHOW_UI"],
        function() return addon.config.showUI end,
        function(v) addon.config.showUI = v if not v and addon.ttkFrame then addon.ttkFrame:Hide() end end)
    Checkbox(L["OPT_LOCK_FRAME"],
        function() return addon.config.lockFrame end,
        function(v) addon.config.lockFrame = v end)
    Checkbox(L["OPT_HISTORY"],
        function() return addon.config.historyEnabled end,
        function(v) addon.config.historyEnabled = v end,
        L["OPT_HISTORY_DESC"])
    Checkbox(L["OPT_MINIMAP"],
        function() return not addon.config.minimap.hide end,
        function(v)
            addon.config.minimap.hide = not v
            addon:ToggleMinimapButton()
        end)
    
    Separator()
    Header(L["HEADER_APPEARANCE"])
    Dropdown(L["OPT_FONT"], addon.FONTS,
        function() return addon.config.fontIndex end,
        function(v) addon.config.fontIndex = v end)
    Slider(L["OPT_FONT_SIZE"], 12, 28, 1,
        function() return addon.config.fontSize end,
        function(v) addon.config.fontSize = v end, "%dpt")
    Dropdown(L["OPT_COLORS"], addon.COLOR_PRESETS,
        function() return addon.config.colorPresetIndex end,
        function(v) addon.config.colorPresetIndex = v end)
    Dropdown(L["OPT_TREND_STYLE"], addon.TREND_STYLES,
        function() return addon.config.trendStyleIndex end,
        function(v) addon.config.trendStyleIndex = v end)
    Slider(L["OPT_SCALE"], 0.5, 2, 0.1,
        function() return addon.config.frameScale end,
        function(v) addon.config.frameScale = v end, "%.1fx")
    
    Separator()
    Header(L["HEADER_FRAME_STYLE"])
    Checkbox(L["OPT_SHOW_BG"],
        function() return addon.config.showBackground end,
        function(v) addon.config.showBackground = v addon:RefreshDisplay() end)
    Checkbox(L["OPT_SHOW_BORDER"],
        function() return addon.config.showBorder end,
        function(v) addon.config.showBorder = v addon:RefreshDisplay() end)
    Slider(L["OPT_BG_OPACITY"], 0, 100, 5,
        function() return addon.config.bgOpacity * 100 end,
        function(v) addon.config.bgOpacity = v / 100 end, "%.0f%%")
    
    Separator()
    Header(L["HEADER_POSITIONING"])
    Checkbox(L["OPT_ATTACH_TARGET"],
        function() return addon.config.attachToTarget end,
        function(v)
            addon.config.attachToTarget = v
            if v then
                addon.detectedTargetFrame = nil
                addon:GetTargetFrame(true)
            end
            addon:UpdateTargetAnchor()
        end)
    AnchorDropdown(L["OPT_ANCHOR_POINT"], addon.ANCHOR_POINTS,
        function() return addon.config.anchorPoint end,
        function(v) addon.config.anchorPoint = v end)
    AnchorDropdown(L["OPT_ANCHOR_TO"], addon.ANCHOR_POINTS,
        function() return addon.config.anchorToPoint end,
        function(v) addon.config.anchorToPoint = v end)
    OffsetSlider(L["OPT_OFFSET_X"], -200, 200, 1,
        function() return addon.config.targetOffsetX end,
        function(v) addon.config.targetOffsetX = v end)
    OffsetSlider(L["OPT_OFFSET_Y"], -200, 200, 1,
        function() return addon.config.targetOffsetY end,
        function(v) addon.config.targetOffsetY = v end)
    
    content:SetHeight(math_abs(y) + 20)
    
    ---------------------------------------------------------------------------
    -- Bottom Buttons
    ---------------------------------------------------------------------------
    local buttonContainer = CreateFrame("Frame", nil, window)
    buttonContainer:SetHeight(36)
    buttonContainer:SetPoint("BOTTOMLEFT", 8, 8)
    buttonContainer:SetPoint("BOTTOMRIGHT", -8, 8)
    
    local btnDivider = buttonContainer:CreateTexture(nil, "ARTWORK")
    btnDivider:SetHeight(1)
    btnDivider:SetPoint("TOPLEFT", 0, 0)
    btnDivider:SetPoint("TOPRIGHT", 0, 0)
    btnDivider:SetColorTexture(0.4, 0.4, 0.4, 0.5)
    
    local btn1 = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    btn1:SetSize(100, 24)
    btn1:SetPoint("BOTTOMLEFT", 0, 0)
    btn1:SetText(L["BTN_PREVIEW"])
    btn1:SetScript("OnClick", function() addon:TogglePreview() end)
    
    local btn2 = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    btn2:SetSize(100, 24)
    btn2:SetPoint("LEFT", btn1, "RIGHT", 6, 0)
    btn2:SetText(L["BTN_RESET_POS"])
    btn2:SetScript("OnClick", function() addon:ResetFramePosition() end)
    
    local btn3 = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    btn3:SetSize(100, 24)
    btn3:SetPoint("LEFT", btn2, "RIGHT", 6, 0)
    btn3:SetText(L["BTN_CLEAR_DATA"])
    btn3:SetScript("OnClick", function() addon:ClearAllData() print(L["DATA_CLEARED"]) end)
    
    tinsert(UISpecialFrames, "MayTTKConfigWindow")
    
    self.configWindow = window
    window:Show()
    self:Debug("Config window created")
end

function addon:ShowConfig()
    self:CreateConfigWindow()
end
