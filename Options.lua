-- CDMTweaker Options Panel
-- Separated options UI for the addon

local function CreateOptionsPanel()
    local panel = CreateFrame("Frame")
    panel.name = "CDMTweaker"
    
    local INDENT = 16
    local SPACING = 8
    local SECTION_SPACING = 24
    
    -- Title
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", INDENT, -INDENT)
    title:SetText("CDMTweaker")
    
    -- Version/Description
    local version = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    version:SetText("Tweaks and enhancements for Cooldown Manager")
    
    -- ==================== GENERAL SECTION ====================
    local generalHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    generalHeader:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -SECTION_SPACING)
    generalHeader:SetText("General")
    generalHeader:SetTextColor(1, 0.82, 0) -- Gold color like Blizzard headers
    
    -- Separator line
    local generalLine = panel:CreateTexture(nil, "ARTWORK")
    generalLine:SetPoint("TOPLEFT", generalHeader, "BOTTOMLEFT", 0, -4)
    generalLine:SetSize(350, 1)
    generalLine:SetColorTexture(0.6, 0.6, 0.6, 0.4)
    
    -- /cdm checkbox
    local cdmCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    cdmCheckbox:SetPoint("TOPLEFT", generalLine, "BOTTOMLEFT", 0, -SPACING)
    cdmCheckbox.Text:SetText("Enable /cdm slash command")
    cdmCheckbox:SetChecked(CDMTweakerDB.cdmCommandEnabled)
    cdmCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.cdmCommandEnabled = self:GetChecked()
        -- Show reload confirmation dialog
        StaticPopupDialogs["CDMTWEAKER_RELOAD_UI"] = {
            text = "Changing this setting requires a UI reload to take effect.\n\nReload now?",
            button1 = "Reload",
            button2 = "Later",
            OnAccept = function()
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("CDMTWEAKER_RELOAD_UI")
    end)
    
    -- /cdm description
    local cdmDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    cdmDesc:SetPoint("TOPLEFT", cdmCheckbox, "BOTTOMLEFT", 26, -2)
    cdmDesc:SetText("Toggles the Cooldown Viewer Settings window (requires reload)")
    cdmDesc:SetTextColor(0.5, 0.5, 0.5)
    
    -- ==================== MOUNTED OPACITY SECTION ====================
    local dimHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    dimHeader:SetPoint("TOPLEFT", cdmDesc, "BOTTOMLEFT", -26, -SECTION_SPACING)
    dimHeader:SetText("Mounted Opacity")
    dimHeader:SetTextColor(1, 0.82, 0)
    
    -- Separator line
    local dimLine = panel:CreateTexture(nil, "ARTWORK")
    dimLine:SetPoint("TOPLEFT", dimHeader, "BOTTOMLEFT", 0, -4)
    dimLine:SetSize(350, 1)
    dimLine:SetColorTexture(0.6, 0.6, 0.6, 0.4)
    
    -- Mount dimming description
    local dimDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    dimDesc:SetPoint("TOPLEFT", dimLine, "BOTTOMLEFT", 0, -SPACING)
    dimDesc:SetText("Select which frames to dim while mounted")
    dimDesc:SetTextColor(0.5, 0.5, 0.5)
    
    -- Essential Cooldowns checkbox
    local essentialCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    essentialCheckbox:SetPoint("TOPLEFT", dimDesc, "BOTTOMLEFT", 0, -SPACING)
    essentialCheckbox.Text:SetText("Essential Cooldowns")
    essentialCheckbox:SetChecked(CDMTweakerDB.dimEssentialCooldowns)
    essentialCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.dimEssentialCooldowns = self:GetChecked()
        if CDMTweaker_IsDimmed() then
            CDMTweaker_RestoreCooldownWindows()
            CDMTweaker_DimCooldownWindows()
        end
    end)
    
    -- Utility Cooldowns checkbox
    local utilityCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    utilityCheckbox:SetPoint("TOPLEFT", essentialCheckbox, "BOTTOMLEFT", 0, -SPACING)
    utilityCheckbox.Text:SetText("Utility Cooldowns")
    utilityCheckbox:SetChecked(CDMTweakerDB.dimUtilityCooldowns)
    utilityCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.dimUtilityCooldowns = self:GetChecked()
        if CDMTweaker_IsDimmed() then
            CDMTweaker_RestoreCooldownWindows()
            CDMTweaker_DimCooldownWindows()
        end
    end)
    
    -- PrimaryResourceBar checkbox
    local primaryResourceCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    primaryResourceCheckbox:SetPoint("TOPLEFT", utilityCheckbox, "BOTTOMLEFT", 0, -SPACING)
    primaryResourceCheckbox.Text:SetText("Primary Resource Bar")
    primaryResourceCheckbox:SetChecked(CDMTweakerDB.dimPrimaryResourceBar)
    primaryResourceCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.dimPrimaryResourceBar = self:GetChecked()
        if CDMTweaker_IsDimmed() then
            CDMTweaker_RestoreCooldownWindows()
            CDMTweaker_DimCooldownWindows()
        end
    end)
    
    -- SecondaryResourceBar checkbox
    local secondaryResourceCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    secondaryResourceCheckbox:SetPoint("TOPLEFT", primaryResourceCheckbox, "BOTTOMLEFT", 0, -SPACING)
    secondaryResourceCheckbox.Text:SetText("Secondary Resource Bar")
    secondaryResourceCheckbox:SetChecked(CDMTweakerDB.dimSecondaryResourceBar)
    secondaryResourceCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.dimSecondaryResourceBar = self:GetChecked()
        if CDMTweaker_IsDimmed() then
            CDMTweaker_RestoreCooldownWindows()
            CDMTweaker_DimCooldownWindows()
        end
    end)
    
    -- BuffCooldownIconViewer checkbox
    local buffCooldownCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    buffCooldownCheckbox:SetPoint("TOPLEFT", secondaryResourceCheckbox, "BOTTOMLEFT", 0, -SPACING)
    buffCooldownCheckbox.Text:SetText("Buff Cooldown Icon Viewer")
    buffCooldownCheckbox:SetChecked(CDMTweakerDB.dimBuffCooldownIconViewer)
    buffCooldownCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.dimBuffCooldownIconViewer = self:GetChecked()
        if CDMTweaker_IsDimmed() then
            CDMTweaker_RestoreCooldownWindows()
            CDMTweaker_DimCooldownWindows()
        end
    end)
    
    -- Dim on all mounts checkbox
    local allMountsCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    allMountsCheckbox:SetPoint("TOPLEFT", buffCooldownCheckbox, "BOTTOMLEFT", 0, -SECTION_SPACING)
    allMountsCheckbox.Text:SetText("Also dim during ground and normal flying")
    allMountsCheckbox:SetChecked(CDMTweakerDB.dimOnAllMounts)
    allMountsCheckbox:SetScript("OnClick", function(self)
        CDMTweakerDB.dimOnAllMounts = self:GetChecked()
        CDMTweaker_UpdateMountDim()
    end)
    
    -- All mounts description
    local allMountsDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    allMountsDesc:SetPoint("TOPLEFT", allMountsCheckbox, "BOTTOMLEFT", 26, -2)
    allMountsDesc:SetText("When disabled, only dims while skyriding")
    allMountsDesc:SetTextColor(0.5, 0.5, 0.5)
    
    -- Opacity slider label
    local sliderLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    sliderLabel:SetPoint("TOPLEFT", allMountsDesc, "BOTTOMLEFT", -26, -SECTION_SPACING)
    sliderLabel:SetText("Dim Opacity")
    
    -- Opacity slider
    local opacitySlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    opacitySlider:SetPoint("TOPLEFT", sliderLabel, "BOTTOMLEFT", 0, -24)
    opacitySlider:SetWidth(200)
    opacitySlider:SetMinMaxValues(0, 100)
    opacitySlider:SetValueStep(1)
    opacitySlider:SetObeyStepOnDrag(true)
    opacitySlider.Low:SetText("")
    opacitySlider.High:SetText("")
    
    -- Create tick marks and labels for 0%, 25%, 50%, 75%, 100%
    local tickPositions = {0, 25, 50, 75, 100}
    for _, pct in ipairs(tickPositions) do
        local xOffset = (pct / 100) * 200  -- slider width is 200
        
        -- Tick mark
        local tick = opacitySlider:CreateTexture(nil, "ARTWORK")
        tick:SetSize(1, 8)
        tick:SetPoint("TOP", opacitySlider, "BOTTOMLEFT", xOffset, 2)
        tick:SetColorTexture(0.6, 0.6, 0.6, 0.8)
        
        -- Label
        local label = opacitySlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        label:SetPoint("TOP", tick, "BOTTOM", 0, -2)
        label:SetText(pct .. "%")
        label:SetTextColor(0.7, 0.7, 0.7)
    end
    
    -- Manual input edit box
    local inputBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    inputBox:SetPoint("LEFT", opacitySlider, "RIGHT", 20, 0)
    inputBox:SetSize(45, 20)
    inputBox:SetAutoFocus(false)
    inputBox:SetNumeric(false)
    inputBox:SetMaxLetters(3)
    
    -- Percent label next to input
    local percentLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    percentLabel:SetPoint("LEFT", inputBox, "RIGHT", 4, 0)
    percentLabel:SetText("%")
    
    -- Update function to sync slider and input box
    local function UpdateOpacity(value, fromSlider)
        local clampedValue = math.max(0, math.min(100, value))
        local alpha = clampedValue / 100
        CDMTweakerDB.skyridingDimAlpha = alpha
        
        -- Always update the input box to match the slider
        inputBox:SetText(math.floor(clampedValue))
        
        if not fromSlider then
            opacitySlider:SetValue(clampedValue)
        end
        
        if CDMTweaker_IsDimmed() then
            CDMTweaker_DimCooldownWindows()
        end
    end
    
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        UpdateOpacity(value, true)
    end)
    
    -- Set initial slider value after OnValueChanged is set up
    opacitySlider:SetValue(CDMTweakerDB.skyridingDimAlpha * 100)
    
    inputBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText()) or 0
        UpdateOpacity(value, false)
        self:ClearFocus()
    end)
    
    inputBox:SetScript("OnEscapePressed", function(self)
        self:SetText(math.floor(CDMTweakerDB.skyridingDimAlpha * 100))
        self:ClearFocus()
    end)
    
    -- Slider description
    local sliderDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    sliderDesc:SetPoint("TOPLEFT", opacitySlider, "BOTTOMLEFT", 0, -24)
    sliderDesc:SetText("0% = invisible, 100% = fully visible")
    sliderDesc:SetTextColor(0.5, 0.5, 0.5)
    
    -- Register with the Settings API (modern WoW)
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)
    
    -- Store category globally for slash command access
    CDMTweaker_SettingsCategory = category
end

-- Global function to create options panel (called from main file)
function CDMTweaker_CreateOptionsPanel()
    CreateOptionsPanel()
end
