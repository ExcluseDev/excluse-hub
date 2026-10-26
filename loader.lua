--[[
    excluse universal loader (Master Build)
--]]

-- ===================================================================
-- === PART 1: TELEPORT HANDLER (AUTO-RELOAD) ===
-- ===================================================================
local LOADER_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/loader.lua" 

if LOADER_URL ~= "" then
    local payload = string.format([[loadstring(game:HttpGet("%s"))()]], LOADER_URL)
    if type(syn) == "table" and syn.queue_on_teleport then pcall(function() syn.queue_on_teleport(payload) end) end
    if type(queue_on_teleport) == "function" then pcall(function() queue_on_teleport(payload) end) end
    if type(fluxus) == "table" and fluxus.queue_on_teleport then pcall(function() fluxus.queue_on_teleport(payload) end) end
end

-- ===================================================================
-- === PART 2: SETUP & THEME ===
-- ===================================================================
-- 🛑 TURNED OFF SECURE MODE (This prevents Xeno from crashing the game)
getgenv().SecureMode = false 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local PlaceId = game.PlaceId

local GalaxyTheme = {
    TextColor = Color3.fromRGB(230, 220, 255), Background = Color3.fromRGB(12, 8, 25),
    Topbar = Color3.fromRGB(20, 12, 40), Shadow = Color3.fromRGB(5, 2, 10),
    NotificationBackground = Color3.fromRGB(25, 15, 45), NotificationActionsBackground = Color3.fromRGB(35, 20, 60),
    TabBackground = Color3.fromRGB(30, 18, 55), TabStroke = Color3.fromRGB(60, 40, 100),
    TabBackgroundSelected = Color3.fromRGB(180, 50, 255), TabTextColor = Color3.fromRGB(180, 160, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(25, 15, 45),
    ElementBackgroundHover = Color3.fromRGB(40, 25, 70), SecondaryElementBackground = Color3.fromRGB(20, 10, 35),
    ElementStroke = Color3.fromRGB(80, 50, 130), SecondaryElementStroke = Color3.fromRGB(50, 30, 90),
    SliderBackground = Color3.fromRGB(180, 50, 255), SliderProgress = Color3.fromRGB(0, 200, 255),
    SliderStroke = Color3.fromRGB(200, 100, 255), ToggleBackground = Color3.fromRGB(30, 20, 50),
    ToggleEnabled = Color3.fromRGB(0, 200, 255), ToggleDisabled = Color3.fromRGB(80, 70, 90),
    ToggleEnabledStroke = Color3.fromRGB(0, 220, 255), ToggleDisabledStroke = Color3.fromRGB(100, 90, 110),
    ToggleEnabledOuterStroke = Color3.fromRGB(255, 100, 200), ToggleDisabledOuterStroke = Color3.fromRGB(70, 60, 80),
    DropdownSelected = Color3.fromRGB(180, 50, 255), DropdownUnselected = Color3.fromRGB(25, 15, 45),
    InputBackground = Color3.fromRGB(20, 10, 35), InputStroke = Color3.fromRGB(80, 50, 130),
    PlaceholderColor = Color3.fromRGB(150, 130, 180)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse universal loader", LoadingTitle = "Initializing Loader...",
    LoadingSubtitle = "by excluse", Theme = GalaxyTheme, DisableRayfieldPrompts = true, 
    DisableBuildWarnings = true, ConfigurationSaving = { Enabled = false }, KeySystem = false
})

-- ===================================================================
-- === PART 3: YOUR DATABASE ===
-- ===================================================================
local Scripts = {
    ["15899178400"] = { 
        Name = "Call of Mini: Zombies 2",
        URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua"
    },
    ["77649408247578"] = {
        Name = "Dungeon Quest Reborn",
        URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua"
    },
    ["6447798030"] = {
        Name = "Funky Friday",
        URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader"
    }
}

local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

-- ===================================================================
-- === PART 4: UI & EXECUTION ===
-- ===================================================================
local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end

local mainTab = Window:CreateTab("🏠 Home")
mainTab:CreateSection("Detection")
mainTab:CreateLabel("Game: " .. GameName)
mainTab:CreateSection("Launch")

if Scripts[tostring(PlaceId)] then
    local s = Scripts[tostring(PlaceId)]
    mainTab:CreateButton({
        Name = "🚀 Launch " .. s.Name,
        Callback = function()
            -- 1. Safely destroy the current window first
            pcall(function() Window:Destroy() end)
            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pg and pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
            
            -- 2. Wait for the game to clear the memory
            task.wait(1.5) 
            
            -- 3. Load the script
            local ok, err = pcall(function() loadstring(game:HttpGet(s.URL))() end)
            if not ok then 
                print("[Loader Error] ", err) 
            end
        end,
    })
else
    mainTab:CreateLabel("❌ No script found for this game.")
    mainTab:CreateButton({
        Name = "🌐 Launch Universal Hub",
        Callback = function()
            pcall(function() Window:Destroy() end)
            task.wait(1.5)
            local ok, err = pcall(function() loadstring(game:HttpGet(UNIVERSAL_URL))() end)
            if not ok then print("[Loader Error] ", err) end
        end,
    })
end

Rayfield:Notify({ Title = "Loader Ready", Content = "Detected: " .. GameName, Duration = 5 })
