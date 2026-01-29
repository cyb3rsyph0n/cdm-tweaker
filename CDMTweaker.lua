-- CDMTweaker Addon
-- Tweaks and enhancements for Cooldown Manager
-- Adds mount dim feature and quick settings access

-- /cdm Slash Command
SLASH_CDM1 = "/cdm"

SlashCmdList["CDM"] = function(msg)
    -- Check if command is enabled (default to true if not yet initialized)
    if _G.CDMTweakerDB and _G.CDMTweakerDB.cdmCommandEnabled == false then
        print("|cFFFFFF00[CDMTweaker]|r /cdm command is disabled. Enable it in the addon options.")
        return
    end
    if CooldownViewerSettings then
        if CooldownViewerSettings:IsShown() then
            CooldownViewerSettings:Hide()
        else
            CooldownViewerSettings:Show()
        end
    else
        print("|cFFFFFF00[CDMTweaker]|r CooldownViewerSettings not found.")
    end
end

-- /cdmt Slash Command - Open CDMTweaker options
SLASH_CDMT1 = "/cdmt"

SlashCmdList["CDMT"] = function(msg)
    if CDMTweaker_SettingsCategory then
        Settings.OpenToCategory(CDMTweaker_SettingsCategory:GetID())
    else
        print("|cFFFFFF00[CDMTweaker]|r Options panel not yet initialized.")
    end
end

-- Mount Dim Feature
-- CDMTweakerDB is a global SavedVariable, don't declare it as local
local skyridingDimFrame = CreateFrame("Frame")
local originalAlphas = {}

-- Default settings
local defaults = {
    cdmCommandEnabled = true, -- Enable /cdm slash command
    skyridingDimAlpha = 0.1,  -- 10% opacity when mounted
    dimOnAllMounts = false,   -- Also dim on regular (non-skyriding) mounts
    dimEssentialCooldowns = true, -- Dim Essential Cooldown Viewer windows
    dimUtilityCooldowns = true, -- Dim Utility Cooldown Viewer windows
    dimPrimaryResourceBar = true, -- Dim PrimaryResourceBar
    dimSecondaryResourceBar = true, -- Dim SecondaryResourceBar
}

-- Get cooldown manager windows to dim
local function GetCooldownWindows()
    local windows = {}
    local addedFrames = {}
    
    -- Search through global frames for matching patterns
    for name, frame in pairs(_G) do
        if type(name) == "string" and type(frame) == "table" and frame.GetAlpha and frame.SetAlpha then
            -- Skip settings windows and already added frames
            if not name:find("Settings") and not addedFrames[frame] then
                -- Check Essential CooldownViewer frames
                if CDMTweakerDB.dimEssentialCooldowns and not addedFrames[frame] then
                    if name:find("EssentialCooldownViewer") then
                        table.insert(windows, frame)
                        addedFrames[frame] = true
                    end
                end
                -- Check Utility CooldownViewer frames
                if CDMTweakerDB.dimUtilityCooldowns and not addedFrames[frame] then
                    if name:find("UtilityCooldownViewer") then
                        table.insert(windows, frame)
                        addedFrames[frame] = true
                    end
                end
                -- Check PrimaryResourceBar (only if not already added)
                if CDMTweakerDB.dimPrimaryResourceBar and not addedFrames[frame] then
                    if name:find("PrimaryResourceBar") then
                        table.insert(windows, frame)
                        addedFrames[frame] = true
                    end
                end
                -- Check SecondaryResourceBar (only if not already added)
                if CDMTweakerDB.dimSecondaryResourceBar and not addedFrames[frame] then
                    if name:find("SecondaryResourceBar") then
                        table.insert(windows, frame)
                        addedFrames[frame] = true
                    end
                end
            end
        end
    end
    
    return windows
end

-- Dim the cooldown windows
local function DimCooldownWindows()
    -- Check if any frame dimming is enabled
    if not CDMTweakerDB.dimEssentialCooldowns and not CDMTweakerDB.dimUtilityCooldowns and not CDMTweakerDB.dimPrimaryResourceBar and not CDMTweakerDB.dimSecondaryResourceBar then
        return
    end
    
    local windows = GetCooldownWindows()
    for _, window in ipairs(windows) do
        if window and window:IsShown() then
            -- Store original alpha if not already stored
            if not originalAlphas[window] then
                originalAlphas[window] = window:GetAlpha()
            end
            window:SetAlpha(CDMTweakerDB.skyridingDimAlpha)
        end
    end
end

-- Restore the cooldown windows to original alpha
local function RestoreCooldownWindows()
    -- Restore ALL frames that were dimmed, not just currently enabled ones
    for window, originalAlpha in pairs(originalAlphas) do
        if window and window.SetAlpha then
            window:SetAlpha(originalAlpha)
        end
    end
    wipe(originalAlphas)
end

-- Check if player should have dimmed UI (skyriding or any mount)
local function ShouldDimUI()
    if IsMounted() then
        -- If dim on all mounts is enabled, return true for any mount
        if CDMTweakerDB.dimOnAllMounts then
            return true
        end
        -- Otherwise, only dim for skyriding
        -- C_PlayerInfo.GetGlidingInfo returns isGliding, canGlide, forwardSpeed
        local isGliding, canGlide = C_PlayerInfo.GetGlidingInfo()
        if canGlide then
            return true
        end
    end
    return false
end

-- Track dim state
local wasDimmed = false

local function UpdateMountDim()
    local shouldDim = ShouldDimUI()
    
    if shouldDim and not wasDimmed then
        -- Just started mounting/skyriding
        DimCooldownWindows()
        wasDimmed = true
    elseif not shouldDim and wasDimmed then
        -- Just stopped mounting/skyriding
        RestoreCooldownWindows()
        wasDimmed = false
    elseif shouldDim and wasDimmed then
        -- Still mounted, ensure windows are dimmed (in case new windows opened)
        DimCooldownWindows()
    end
end

-- Global functions for Options.lua to access
function CDMTweaker_DimCooldownWindows()
    DimCooldownWindows()
end

function CDMTweaker_RestoreCooldownWindows()
    RestoreCooldownWindows()
end

function CDMTweaker_UpdateMountDim()
    UpdateMountDim()
end

function CDMTweaker_IsDimmed()
    return wasDimmed
end

-- Register events for skyriding detection
skyridingDimFrame:RegisterEvent("PLAYER_LOGIN")
skyridingDimFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
skyridingDimFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")

skyridingDimFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Initialize saved variables (global CDMTweakerDB for SavedVariables system)
        if not CDMTweakerDB then CDMTweakerDB = {} end
        _G.CDMTweakerDB = CDMTweakerDB  -- Ensure global reference is set
        for k, v in pairs(defaults) do
            if CDMTweakerDB[k] == nil then
                CDMTweakerDB[k] = v
            end
        end
        
        -- Create options panel (defined in Options.lua)
        CDMTweaker_CreateOptionsPanel()
        
        -- Start update ticker for smooth detection
        C_Timer.NewTicker(0.5, UpdateMountDim)
    else
        -- For mount changes, update after a short delay
        C_Timer.After(0.1, UpdateMountDim)
    end
end)
